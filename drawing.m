close all
% For plotting distance values.
X=[ 0.0000e+00, 0.0000e+00];
bar(X);
title('Euclidean vs L1 - HOG');
text(1:length(X),X,num2str(X'),'vert','bottom','horiz','center'); 
box off
