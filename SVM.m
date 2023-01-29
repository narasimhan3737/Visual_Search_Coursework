% Objection classification using SVM.
close all

IMFOLDER='D:\Work\CVPR-Lab\Coursework\MSRC_ObjCategImageDatabase_v2\Images\';
DATASET_FOLDER = 'D:\Work\CVPR-Lab\Coursework\MSRC_ObjCategImageDatabase_v2';
OUT_FOLDER = 'D:\Work\CVPR-Lab\Coursework\descriptors';
OUT_SUBFOLDER='BOW';
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));

% Splitting the dataset into train and test sets
l=length(allfiles);
idx = randperm(l)  ;
P=0.7;
Training = allfiles(idx(1:round(P*l)),:) ; 
Testing = allfiles(idx(round(P*l)+1:end),:) ;

listDescript=[];
trainlist=[];
testlist=[];

%Adding images in train and test set.
for i=1:length(Training)
fname = Training(i).name;
trainlist=[trainlist,fname];
end

for i=1:length(Testing)
fname = Testing(i).name;
testlist=[testlist,fname];
end


trainlist=split(trainlist,'.bmp');
trainlist=trainlist(1:length(trainlist)-1);
trainnames=trainlist;
trainlist=string(trainlist);
trainlist=IMFOLDER+trainlist+".bmp";

testlist=split(testlist,'.bmp');
testlist=testlist(1:length(testlist)-1);
testnames=testlist;
testlist=string(testlist);
testlist=IMFOLDER+testlist+".bmp";

%Labels of train and test split
imds= imageDatastore(trainlist);
x=split(trainnames,'_');
x=x(:,1,:);
x=string(x);
y=[];

for i=1:length(x)
y(i)=str2num(x(i));
end

xi=split(testnames,'_');
xi=xi(:,1,:);
xi=string(xi);
yi=[];

for i=1:length(xi)
yi(i)=str2num(xi(i));
end

%% calculating BOW

%bow=load('bow.mat').bow; %Can be uncommented for using the saved bow file.
%bow = bagOfFeatures(imds);
bow = bagofw(IMFOLDER)

%encoding image features using BOW for trainset.
for filenum=1:length(Training)
    fname=Training(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(Training),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    coder=encode(bow,img);
    F=coder;

    listDescript=[listDescript;F];
    save(fout,'F');
    toc
end

%plotting visual word occurances for a train image.
bar(coder)
title('Visual word occurrences')
xlabel('Visual word index')
ylabel('Frequency of occurrence')


ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;

% Extracting image features from BOW for trainset.
for filenum=1:length(Training)
    fname=Training(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    featfile=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end


Mdl=fitcecoc(ALLFEAT,y);  %Training a SVM with train set and appropriate labels.
OUT_SUBFOLDER='BOWTEST';

%Encoding image using BOW for testset. 
for filenum=1:length(Testing)
    fname=Testing(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(Testing),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    coder=encode(bow,img);
    F=coder;

    listDescript=[listDescript;F];
    save(fout,'F');
    toc
end

ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
%Extracting image features of testset from BOW.
for filenum=1:length(Testing)
    fname=Testing(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    featfile=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end



%Predicting performance of model with image features of testset.
[label,score] = predict(Mdl,ALLFEAT);

yi=transpose(yi);
Accuracy = sum(yi == label,'all')/numel(label)
figure
%Plotting visual word occurances of a test image.
bar(coder)
title('Visual word occurrences')
xlabel('Visual word index')
ylabel('Frequency of occurrence')
legend