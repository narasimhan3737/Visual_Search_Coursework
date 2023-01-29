% for i=1:eln
%     imgfname_fullz=([DATASET_FOLDER,'/Images/',labn,'_',string(i),'_s','.bmp']);
%     imgfname_fullz=strjoin(imgfname_fullz,'');
%     gt_image = [gt_image,imgfname_fullz];
% end

for i=1:10
    imgfname_fullz=([DATASET_FOLDER,'/Images/',imagespl(i),'.bmp ']);
    imgfname_fullz=strjoin(imgfname_fullz,'');
    pred_image = [pred_image,imgfname_fullz];
end

pred_image=split(pred_image);
pred_image=transpose(pred_image(1:10));