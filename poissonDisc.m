function [pts] = poissonDisc(sizeI,spacing,nPts,showIter)

% Purpose:
% N-dimensional poisson disc sampling function. This can also be used to
% randomly sample k pts from N-dimensional space with a minimum separation
% distance.
%
% Input:
% sizeI -   [required] Size of volume from which points are to be 
%           sampled
% spacing - [required] Minimum sepration distance between points
% nPts -    [Default is 0] if nPts = 0 For poisson disc sampling.
%           nPts = k to sample k-pts from N-dimensional space with
%           minimum separation distance
% showIter - [Default is 0] If showIter == 1, this option can be used to 
%            see how points are generated through each iteration. It can be
%            useful when code is taking a long time to generate points. 
%
% Outputs:
% pts - All eligible points
%
%
% Example:
% 1. Poisson disc sampling in 2-dimensional space. 
% sizeI = [512,512];
% spacing = 30;
% pts = poissonDisc(sizeI,spacing);
%
% 2. Sample k-pts in 3-dimensional space.
% sizeI = [512,512,192];
% spacing = 6;
% nPts = 10000;
% pts = poissonDisc(sizeI,nPts,spacing);
% 
% 3. Show iteration progress from poisson disc sampling in 2-dimension
% sizeI = [512,512];
% spacing = 6;
% nPts = 0;
% showIter = 1;
% pts = poissonDisc(sizeI,nPts,spacing,showIter);

% Mohak Patel, Brown University, 2016


% Parsing inputs


ndim = length(sizeI);   % Number of Dimensions
k = 7;  % Number of darts try

%Make Grid such that there is just one pt in each grid
dm = spacing/sqrt(ndim);    % grize cell size [Bridson 2007]

for i = 1:ndim
    sGrid{1,i} = 1:dm:sizeI(i);
end
[sGrid{:}] = ndgrid(sGrid{:});
sizeGrid = size(sGrid{1});

% Convert Grid points into a nx3 array;
for i = 1:ndim
    sGrid{i} = sGrid{i}(:);
end
sGrid = cell2mat(sGrid);

% Structures for available grids
emptyGrid = logical(ones(size(sGrid,1),1));
nEmptyGrid = sum(emptyGrid);
scoreGrid = zeros(size(emptyGrid));
if nPts == 0
    nPts = length(sGrid);
    sampleSize = round(nEmptyGrid/4);
end
sampleSize = round(nPts/4);
% While loop parameter initialization
ptsCreated = 0;
pts = [];
iter = 0;

% Start Iterative process
tic
while ptsCreated<nPts & nEmptyGrid >0 & iter<2000
    
    availGrid = find(emptyGrid == 1);
    dataPts = min([nEmptyGrid,sampleSize]);
    p = datasample(availGrid,dataPts,'Replace',false);
    tempPts = sGrid(p,:) + dm*rand(length(p),ndim);
    [~,D] = knnsearch([pts;tempPts],tempPts,'k',2);
    D = D(:,2);
    
    withinI = logical(prod(bsxfun(@lt,tempPts,sizeI),2)); %Eligible pts should be withing size 
    eligiblePts = withinI & D>spacing; %Withing Ptsand spacing should be less than D
    scorePts = tempPts(~eligiblePts,:);
    tempPts = tempPts(eligiblePts,:);
    
    %Update empty Grid
    emptyPts = floor((tempPts+dm-1)/dm);
    emptyPts = num2cell(emptyPts,1);
    emptyIdx = sub2ind(sizeGrid,emptyPts{:});
    emptyGrid(emptyIdx) = 0;
    
    %Update score pts
    scorePts = floor((scorePts+dm-1)/dm);
    scorePts = num2cell(scorePts,1);
    scoreIdx = sub2ind(sizeGrid,scorePts{:});
    scoreGrid(scoreIdx) = scoreGrid(scoreIdx) + 1;
    
    %emptyGrid update based on score too
    emptyGrid = emptyGrid & (scoreGrid<k);
    
    nEmptyGrid = sum(emptyGrid);
    pts = [pts;tempPts];
    ptsCreated = size(pts,1);
    iter = iter+1;
    ttoc = toc;
    if showIter == 1
        disp(sprintf('Iteration: %d    Points Created: %d   EmptyGrid:%d   Time: %0.3f',iter,ptsCreated,nEmptyGrid,ttoc));
    end
    
end

if size(pts,1)>nPts
    p = 1:size(pts,1);
    p = datasample(p,nPts,'Replace',false);
    pts = pts(p,:);
end

end
