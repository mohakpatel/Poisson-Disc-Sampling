%% Test PDS
clear; 
%%
sizeI = [512,512,192];
spacing = 30;
nPts = 10000;
pts = poissonDisc3D(sizeI,nPts,spacing,0);


[~,D] = knnsearch(pts,pts,'k',2);
mean(D(:,2))
std(D(:,2))
max(D(:,2))
