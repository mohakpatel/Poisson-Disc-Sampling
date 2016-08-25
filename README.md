# Poisson-Disc-Sampling
Matlab script for N-dimensional Poisson-Disc Sampling. This can also be used this to randomly sample k pts from N-dimensional space with minimum separation distance between the points.

###Download
[Download the latest version v1.0](https://github.com/mohakpatel/Poisson-Disc-Sampling/releases)

### Inputs:  
* sizeI -    [required] Size of volume from which points are to be sampled  
* spacing -  [required] Minimum sepration distance between points  
* nPts -     [Default is 0] if nPts = 0 For poisson disc sampling. nPts = k to sample k-pts from N-dimensional space with minimum separation distance  
* showIter - [Default is 0] If showIter == 1, this option can be used to see how points are generated through each iteration. It can be useful when code is taking a long time to generate points. 

### Output:
* pts -      All eligible points 


## Example:
* Poisson disc sampling in 2D space.  
```matlab
sizeI = [512,512];  
spacing = 30;  
pts = poissonDisc(sizeI,spacing);  
```
* Sample k-pts in 3D space.  
```matlab
sizeI = [512,512,192];  
spacing = 6;  
nPts = 10000;  
pts = poissonDisc(sizeI,nPts,spacing);  
```
* Show iteration progress from poisson disc sampling in 2D  
```matlab
sizeI = [512,512];  
spacing = 6;  
nPts = 0;  
showIter = 1;  
pts = poissonDisc(sizeI,nPts,spacing,showIter);  
```
