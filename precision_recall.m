function [p,q,avp]=precision_recall(NIMG,gt_image,pred_image,eln)
% Calculation of precsion and recall.
precision_val=[];
recall_val=[];
correct=0;
correct_n=zeros([1,NIMG]);
incorrect=0;
for i=1:NIMG
    val = str2double(gt_image(i)) == str2double(pred_image(i));
    if val == 1
        correct=correct+1;
        correct_n(i)=1;
    else
        incorrect = incorrect+1;
    end
    precision = correct / i;
    recall = correct/ eln;
    


    precision_val(i)=precision;
    recall_val(i)=recall;
end

p=precision_val(2:NIMG); % The precision values are returned.
q=recall_val(2:NIMG);   %The recall values are returned.

average_precision = sum(precision_val .* correct_n) / eln;
AP_values(30) = average_precision;
avp=average_precision; %The Mean average precision is returned
return;