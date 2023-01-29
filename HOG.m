function F=HOG(img)
%Calculates the Harris feature Descriptor
arr=[];
corners   = detectFASTFeatures(im2gray(img)); % Corner features are measured
strongest = selectStrongest(corners,3); %Strongest 3 features are taken into consideration
[hog2,validPoints,ptVis] = extractHOGFeatures(img,strongest); %The HOG features are calculated using the strongest features.

hog = extractHOGFeatures(img);

for i=1:length(validPoints.Location)
    arr=[arr,hog2(i)];
end
F=hog2;


return;