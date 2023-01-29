function [F,Q]=img_manip(ALLFILES,queryimg,imagenames)

querytxt = ALLFILES(queryimg);
querytxt = string(querytxt);
querysplit = split(querytxt,'Images/');
querysplit = querysplit(2);
imagespl=split(imagenames,'Images/');
imagespl=imagespl(:,:,2);
imagespl=split(imagespl,'.bmp');
imagespl = imagespl(:,:,1);
querysplit = split(querysplit,'.bmp');
querysplit = querysplit(1);

Q=querysplit;
F=imagespl;
return;