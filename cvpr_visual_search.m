%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m
%% Skeleton code provided as part of the coursework assessment
%%
%% This code will load in all descriptors pre-computed (by the
%% function cvpr_computedescriptors) from the images in the MSRCv2 dataset.
%%
%% It will pick a descriptor at random and compare all other descriptors to
%% it - by calling cvpr_compare.  In doing so it will rank the images by
%% similarity to the randomly picked descriptor.  Note that initially the
%% function cvpr_compare returns a random number - you need to code it
%% so that it returns the Euclidean distance or some other distance metric
%% between the two descriptors it is passed.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'D:\Work\CVPR-Lab\Coursework\MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = 'D:\Work\CVPR-Lab\Coursework\descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
DESCRIPTOR_SUBFOLDER='globalRGBhisto';
precision_val=[];
recall_val=[];
avpval=[];

%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end
precision_val_fin=[];
recall_val_fin=[];
mat=zeros(20,20);
for loo=1:30
    precision_val=[];
    recall_val=[];
    %% 2) Pick an image at random to be the query
    NIMG=size(ALLFEAT,1);           % number of images in collection
    queryimg=floor(rand()*NIMG);    % index of a random image
    
    
    %% 3) Compute the distance of image to the query
    dst=[];
    for i=1:NIMG
        candidate=ALLFEAT(i,:);
        if(queryimg<1)
            queryimg = 1;
        end
        query=ALLFEAT(queryimg,:);
        thedst=cvpr_compare(query,candidate);
        dst=[dst ; [thedst i]];

    end
    dst=sortrows(dst,1);  % sort the results
       
    
    
    
    %% 4) Visualise the results
    %% These may be a little hard to see using imgshow
    %% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)
    imagenames=[];
    imagenos=[];
    SHOW=10; % Show top 15 results
    dstx=dst;
    dst=dst(1:SHOW,:);
    outdisplay=[];

    for i=1:size(dst,1)
       img=imread(ALLFILES{dst(i,2)});
       imagenos=[imagenos,dst(i,2)];
       imagenames=[imagenames ALLFILES{dst(i,2)}];
       img=img(1:2:end,1:2:end,:); % make image a quarter size
       img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
       outdisplay=[outdisplay img];
    end
    imagenames=ALLFILES(dstx(:,2));
    imshow(outdisplay);
    axis off;
    
    
    %Query and Predicted filenames

    [imagespl,queryspl]=img_manip(ALLFILES,queryimg,imagenames);
    imagesplz=split(imagespl,'_');
    imagesplz=imagesplz(:,:,1);
    
    %Class number of Query
    labn = split(queryspl,'_');
    labn=labn(1);
    
    %Full name of query
    imgfname_query=([DATASET_FOLDER,'/Images/',queryspl,'.bmp']);
    imgfname_query=strjoin(imgfname_query,'');
    eln = switchcall(str2double(labn));
    
    %Class values of all Images
    nos=split(ALLFILES,'Images/');
    nos=nos(:,:,2);
    nos=split(nos,'_');
    nos=nos(:,:,1);
    
    gt_image=[];
    eln;
    labn;
    
    % Array of query class number
    for i=1:eln
        imgfname_list=([labn,'_',string(i),'_s']);
        imgfname_list=strjoin(imgfname_list,'');
        
        gt_image = [gt_image,imgfname_list];
    end
    
    gt_image=split(gt_image,'_');
    gt_image=gt_image(1:eln);
    gt_image(1:NIMG)=gt_image(1);
    
    
    pred_image=imagesplz;
    

    correct=0;
    incorrect=0;
    val=0;
    %Calculating Confusion Matrix
    mat=confusemat(NIMG,gt_image,pred_image,mat);
%Precision and Recall calculation.
[precision,recall,avp]=precision_recall(NIMG,gt_image,pred_image,eln);
precision_val=[precision_val precision];
recall_val=[recall_val recall];
avpval(loo)=avp;
precision_val_fin=[precision_val_fin;precision_val];
recall_val_fin=[recall_val_fin;recall_val];

end

avpval;
avp=sum(avpval) %Mean Average Precision

%Plotting PR curve.
figure
for i=1:loo
    plt=plot(recall_val_fin(i,:,:),precision_val_fin(i,:,:));
    xlim([0 1])
    legend()
    title('PR Curve');
    xlabel('Recall');
    ylabel('Precision');
    hold on
end
hold off

figure,confusionchart(mat);
MahDist=[];

codebook=load("codebook.mat"); 

%PCA and Mahanobis Distance
E = PCA(ALLFEAT);
queryimage = imread(fullimg(queryspl,DATASET_FOLDER));
queryfeat=clrhis(queryimage); %Change Descriptor Function.
%% Uncomment for computing BOW descriptor

%queryfeat=encode(codebook.codebook,queryimage);    
%%
for i=2:length(imagespl)
    predimage = imread(fullimg(imagespl(i),DATASET_FOLDER));
    imgfeat=clrhis(predimage);
    %imgfeat=encode(codebook.codebook,predimage); %BOW descriptor predicted.
    subimg=queryfeat-imgfeat;
    MahD = Eigen_Mahalanobis(subimg,E);
    MahDist=[MahDist;MahD];
end
Mahdistance=sum(MahDist);
Mahdistance=sum(Mahdistance) %Mahalanobis Distance


%Codebook

idx = kmeans(ALLFEAT,20);
figure
h=histogram(idx); %Plot codebook.

title("Codebook of Features")   
xlabel("Labels")
ylabel("No of occurences")
