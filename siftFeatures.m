function siftFeatures = siftFeatures(img)

gryimg = img(:,:,1) * 0.3 + img(:,:,2) * 0.59 + img(:,:,3) * 0.11;

siftPoints = detectSIFTFeatures(gryimg);
[siftFeatures,] = extractFeatures(gryimg,siftPoints);



% figure(i), imshow(img);
% hold on;
% plot(siftPoints.selectStrongest(10))



end