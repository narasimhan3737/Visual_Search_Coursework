function dst=cvpr_compare(F1, F2)

% This function should compare F1 to F2 - i.e. compute the distance
% between the two descriptors

% For now it just returns a random number

% x = F1-F2;
% x=sqrt(sum((F1-F2).^2));
dst=norm(F1-F2);

% fprintf("dst - %f x - %f \n",dst,x);



return;
