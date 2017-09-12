function [BW,maskedImage] = Si_region_AlN(X)
%segmentImage Segment image using auto-generated code from imageSegmenter App
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the imageSegmenter App. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 11-Sep-2017
%----------------------------------------------------


% Normalize input data to range in [0,1].
Xmin = min(X(:));
Xmax = max(X(:));
if isequal(Xmax,Xmin)
    X = 0*X;
else
    X = (X - Xmin) ./ (Xmax - Xmin);
end

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Polygon drawing
xPos = [83.4611 91.3862 100.6081 100.4640];
yPos = [1.0245 87.1916 87.1916 0.8804];
m = size(BW, 1);
n = size(BW, 2);
addedRegion = poly2mask(xPos, yPos, m, n);
BW = BW | addedRegion;

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;