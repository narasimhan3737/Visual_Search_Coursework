close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'C:\Users\Asus\Documents\MATLAB\MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = 'D:\MATLAB-D\descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
OUT_SUBFOLDER='bovwTrial';

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
descriptorStack = [];
descriptorCountIndex = zeros(1,length(allfiles));
clusterNumber = 40;


for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
%     fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
%     F=extractRandom(img);
%     F = averageRGB(img);
%     F = spatialGridDescriptor(img,5,5);
    %F = globalRGBHistogram(img,8);
    F  = siftFeatures(img,filenum);
    numberOfDescriptors = size(F,1);
    descriptorStack = [descriptorStack; F];
    descriptorCountIndex(filenum) = numberOfDescriptors;
%     save(fout,'F');
    toc
end

for clusterNumber = 10000
    tic;
    clusterNumber
    [idx, C, sumd] = kmeans(descriptorStack,clusterNumber,'MaxIter',10000,'Replicates',5);
    sumd
    toc
end

% NIMG = length(allfiles);
% indexOffset = 0;
% histogramMat = zeros(NIMG,clusterNumber);
% for i = 1:NIMG
%     for j = 1:descriptorCountIndex(i)
%         if(i > 1)
%             indexOffset = descriptorCountIndex(i-1);
%         end
%         index = idx(indexOffset+j);
%         histogramMat(i,index) = histogramMat(i,index)+1; 
%     end



% end
% 
% for k=1:length(allfiles)
%     fname=allfiles(k).name;
%     fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
%     F = histogramMat(k);
%     save(fout,'F');
% end


