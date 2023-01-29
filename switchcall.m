function f=switchcall(n)

% Returns number of images in each class.
switch n
    case 12
        n=34;
    case 15
        n=24;
    case 20
        n=21;
    otherwise
        n=30;
end

f=n;
return;