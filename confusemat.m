function p=confusemat(NIMG,gt_image,pred_image,mat)


pred_image=pred_image(2:11);
pred_image = string(pred_image);



% Calculating confusion matrix for first 10 images.

for i=1:10
    x=str2num(gt_image(i));
    y=str2num(pred_image(i));
    numx=mat(x,y);
    mat(str2num(gt_image(i)),str2num(pred_image(i)))=numx+1;
end

p=mat;
return 


