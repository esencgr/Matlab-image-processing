clear all; 
close all;
clc;
img =imread ('rgbresim.png');
imshow(img);


img1=rgb2gray(img);
imshow(img1);

[m n]=size(img1);

for i=1:m
    for j=1:n
        
       % imgtranspoze (j,i) = img1(i,j);
        imgmirror (i,n-j+1) = img1(i,j);
        
    end 
end 

figure 
imshow (imgmirror);





