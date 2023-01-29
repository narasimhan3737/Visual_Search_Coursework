function dst=L1(F1, F2)
% L1 Distance measure
x=abs(F1-F2);
dst=sum(x);

return