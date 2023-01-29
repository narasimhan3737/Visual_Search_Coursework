function F=bagofw(location)

imds= imageDatastore(location,"FileExtensions",".bmp");
% Used for performing Bag of Words
bow = bagOfFeatures(imds);


F=bow;
return