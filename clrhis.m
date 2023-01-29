function F=clrhis(img)


%Average of red channel
red=img(:,:,1);
red=reshape(red,1,[]);
average_red=mean(red); 

%Average of green channel
green=img(:,:,2);
green=reshape(green,1,[]);
average_green=mean(green); 

%Average of blue channel
blue=img(:,:,3);
blue=reshape(blue,1,[]);
average_blue=mean(blue); 

F=[average_red average_green average_blue]; 


return;