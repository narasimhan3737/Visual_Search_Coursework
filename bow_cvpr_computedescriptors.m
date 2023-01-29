% This program is specifically used for computing descriptors using Bag of
% Words.

close all;
clear all;

codebook=load("codebook.mat");   %Load Codebook from Bag of Words.

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'D:\Work\CVPR-Lab\Coursework\MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = 'D:\Work\CVPR-Lab\Coursework\descriptors';
IMFOLDER='D:\Work\CVPR-Lab\Coursework\MSRC_ObjCategImageDatabase_v2\Images';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
OUT_SUBFOLDER='globalRGBhisto';
listDescript=[];
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));

%codebook=bagofw(IMFOLDER);         %Bag of Words

for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    coder=encode(codebook.codebook,img);
    F=coder;

    listDescript=[listDescript;F];
    save(fout,'F');
    toc
end


