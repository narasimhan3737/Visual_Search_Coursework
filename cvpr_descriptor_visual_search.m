close all;
clear all;

DATASET_FOLDER = 'D:\Work\CVPR-Lab\Coursework\MSRC_ObjCategImageDatabase_v2';
RANDOM_QUERY = false; %Decide random query or fixed query
STACK_RESULTS = true;

CLASS_NAMES = {'Farm','Tree','Building','Flight','Cow','Face','Car','Bicycle','Sheep','Flower','Sign','Birds','Books','Furniture','Cat','Dog','Road','Water','People','Scenary'} ;

%% 1) Processing images and extracting feature
totalNoOfClass = 20;
clusterNumber = 500;
meanAveragePrecision = [];
descriptorStack = []
descriptorCountIndex = []
% histindex = 1;
% for histogramBin = 2:2:16
ALLFEAT=[];
%ALLCLASS=cell(20)
ALLFILES=cell(1,0);
classCounter = zeros(1,totalNoOfClass);
classImageIndex = cell(1,totalNoOfClass);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'\Images\*.bmp']));


fprintf("\n1. Processing images and extracting feature\n");
tic;
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'\Images\',fname]);
    fprintf('\nProcessing file %d/%d - %s\n',filenum,length(allfiles),fname);
    classIndexCell = split(fname,'_');
    classIndex = str2double(classIndexCell{1});
    classCounter(classIndex) = classCounter(classIndex)+1 ;
    classImageIndex{classIndex} = [classImageIndex{classIndex} ctr];
    
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
%     featfile=[DESCRIPTOR_FOLDER,'\',DESCRIPTOR_SUBFOLDER,'\',fname(1:end-4),'.mat'];%replace .bmp with .mat
%     load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    F  = siftFeatures(img);
    numberOfDescriptors = size(F,1);
    descriptorStack = [descriptorStack; F];
    descriptorCountIndex(filenum) = numberOfDescriptors;
%     save(fout,'F');
    
    
    ctr=ctr+1;
end
[idx, C, sumd] = kmeans(descriptorStack,clusterNumber,'MaxIter',10000);

NIMG = length(allfiles);
indexOffset = 0;
histogramMat = zeros(NIMG,clusterNumber);
for i = 1:NIMG
    for j = 1:descriptorCountIndex(i)
        if(i > 1)
            indexOffset = descriptorCountIndex(i-1);
        end
        index = idx(indexOffset+j);
        histogramMat(i,index) = histogramMat(i,index)+1; 
    end



end

for k=1:length(allfiles)
    ALLFEAT=[ALLFEAT ; histogramMat(k,:);];
end

TOTALNIMG=size(ALLFEAT,1); 
queryImageIndices = zeros(1,totalNoOfClass);
%% 2) Pick an image at random from each class to be the 
if (RANDOM_QUERY)
    fprintf("\n2. Picking Random query\n");

    for class = 1:totalNoOfClass
        NIMG = classCounter(class);
        queryImageRandomNo = rand()*NIMG;
        if(queryImageRandomNo  < 1) 
            queryImageNo = ceil(queryImageRandomNo);
        else 
            queryImageNo = floor(queryImageRandomNo); 
        end
        queryImageIndices(class) = classImageIndex{class}(queryImageNo);
    end
    % NIMG=size(ALLFEAT,1);           % number of images in collection
    % queryimg=floor(rand()*NIMG);    % index of a random image
else
    fprintf("\n2. Picking pre-set query\n");
    queryImageIndices = [325 376 384 417 444 485 517 556 562 5 59 74 107 156 168 206 222 250 276 333];
end


%% 3) Compute the distance of image to the query
distanceq2t=zeros(TOTALNIMG,2,totalNoOfClass);
fprintf("\n3. Calculating distance\n");
for class = 1:totalNoOfClass
    dst=[];
    for i=1:TOTALNIMG
        candidate=ALLFEAT(i,:);
        query=ALLFEAT(queryImageIndices(class),:);
        thedst=getL1norm(query,candidate);
    %     global_index = global_index+index;
        dst=[dst ; [thedst i]];
    end
    dst=sortrows(dst,1);  % sort the results
    distanceq2t(:,:,class)=dst;
end


%% 4) Visualise the results
%% These may be a little hard to see using imgshow
%% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)

SHOW=11; % Show top 10 results + 1 query
outdisplay=[];

whitebar = zeros(10,(160*SHOW),3);
whitebar(:,:,:) = 255;

precisionatk = zeros(totalNoOfClass,TOTALNIMG-1);
recallatk = zeros(totalNoOfClass,TOTALNIMG-1);
correctatk = zeros(totalNoOfClass,TOTALNIMG-1);
averagePrecision = zeros(1,totalNoOfClass);

confusionMatrix = zeros(totalNoOfClass);
fprintf("\n4. Retrieval and Evaluation\n");
for class = 1:totalNoOfClass
    dist = distanceq2t(:,:,class);
%     dist = dist(1:SHOW,:);
    display=[];
    correct = 0;
    incorrect = 0;
    for i=1:size(dist,1)
       locateFile = ALLFILES{dist(i,2)};
       imageNameCell = split(locateFile,'\Images\');
       imageName = imageNameCell{end};
       classIndexCell = split(imageName,'_');
       classIndexNumber = str2double(classIndexCell{1});
       img=imread(ALLFILES{dist(i,2)});
       img=img(1:2:end,1:2:end,:); % make image a quarter size
       img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
       img = imresize(img,[81 160]);
       img(1:3,:,1:3) = 0;
       img(:,1:3,1:3) = 0;
       img(end-4:end,:,1:3) = 0;
       img(:,end-4:end,1:3) = 0;
       if(i==1)
            queryClassIndex = classIndexNumber;
            img(:,end-4:end,3) = 200;
            img(1:3,:,3) = 200;
            img(end-4:end,:,3) = 200;
            img(:,1:3,3) = 200;
       else
           if(classIndexNumber == queryClassIndex)
            correct = correct+1;
            correctatk(class,i-1) = 1;
            img(:,end-4:end,2) = 200;
            img(1:3,:,2) = 200;
            img(end-4:end,:,2) = 200;
            img(:,1:3,2) = 200;

           else
            img(:,end-4:end,1) = 200;
            img(1:3,:,1) = 200;
            img(end-4:end,:,1) = 200;
            img(:,1:3,1) = 200;
           end
       end
       if(i>1)
           if(i <= SHOW)
            confusionMatrix(class,classIndexNumber) = confusionMatrix(class,classIndexNumber)+1;
           end
           precisionatk(class,i-1) = correct/(i-1);
           recallatk(class,i-1) = correct/(classCounter(class)-1);
           averagePrecision(class) = averagePrecision(class) + (precisionatk(class,i-1)*correctatk(class,i-1));
           if((correct/(classCounter(class)-1)) > 1)
             %fprintf("Class %d i %d correct %d imageName %s queryClassString %s classIndexString %s\n",class,i,correct,imageName,queryClassString,classIndexString);
           end
       end
       if(i <= SHOW)
        display  = [display img];
       end
       
    end
%     figure(class)
    confusionMatrixClassSum = sum(confusionMatrix(class,:));
    confusionMatrix(class,:) = confusionMatrix(class,:)./ confusionMatrixClassSum;
    averagePrecision(class) = averagePrecision(class)/(classCounter(class)-1);
    plot(recallatk(class,:),precisionatk(class,:)); 
    xlabel('Recall');
    ylabel('Precision');
    title("PR curve/ PR @ 1 to PR @ 591 for 20 classes")
    hold on;
    
    outdisplay = [outdisplay; display; whitebar];
    if(~STACK_RESULTS)
       figure(class+1)
       imgshow(display)
       axis off;
   end
end
meanAveragePrecision = mean(averagePrecision);
% histindex = histindex+1
% end
toc
hold off;
% legend(CLASS_NAMES);
% plot(recallatk(5,:),precisionatk(5,:));

if(STACK_RESULTS)
    figure(2)
    imgshow(outdisplay);
    axis off;
end
figure(3)
heatmap(CLASS_NAMES,CLASS_NAMES,confusionMatrix)
title('Confusion Matrix for Global Histogram - 16 quantization param/ L1 norm')

figure(4)
plot(mean(recallatk),mean(precisionatk))
 xlabel('Recall');
    ylabel('Precision');
    title("Mean PR curve")
figure(5)
plot(max(recallatk),max(precisionatk))
 xlabel('Recall');
    ylabel('Precision');
    title("Max PR curve")
% imgshow(display);




