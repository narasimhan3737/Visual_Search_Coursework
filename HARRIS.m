function F=HARRIS(img)

% Calculates the Harris Descriptor
arr=[];
x = detectHarrisFeatures(rgb2gray(img)); 
zer(1:1080)=0;
HarrisMetrics=x.selectStrongest(3); %The top three strongest features are selected
HarrisMetrics = HarrisMetrics.Location; %Location metric of the descriptor
feat = extractFeatures(rgb2gray(img),x); %The strongest features are extracted.
for i=1:length(HarrisMetrics)
    arr=[arr,HarrisMetrics(i)];
end


F=mean(feat.Features); 


return;