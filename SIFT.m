function F=SIFT(img)

% Calculates the SIFT descriptor

x = detectSIFTFeatures(rgb2gray(img)); %Converted to gray from RGB
zer(1:1080)=0;
SIFTMetrics=x.selectStrongest(3); %Strongest features in the image is taken into consideration.


feat = extractFeatures(rgb2gray(img),x); % The strongest features are extracted from SIFT.



F=mean(feat); 

return;