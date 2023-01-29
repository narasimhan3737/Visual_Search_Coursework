function F=fullimg(img,DATASET_FOLDER)
imgr=[];
% Returns the full image description including it's address
for i=1:length(img)
    imgfname_full=([DATASET_FOLDER,'/Images/',img,'.bmp']);
    imgfname_full=strjoin(imgfname_full,'');
    imgr=[imgr , imgfname_full];
end

F = imgfname_full;
%F=imread(imgfname_full);
return