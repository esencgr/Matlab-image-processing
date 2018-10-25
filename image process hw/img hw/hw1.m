clear all;
clc; 
close all;
Image=imread('barbara.png');% imgenin okunmasý
figure;imshow(Image);       % imgenin ekrana basýlmasý 

% belirlenen piksel deðerlerinin omut satýrýna yazdýrýlmasý
disp('image(0,0)')
Image(1,1)
disp('----------')

disp('image(4,5)')
Image(4,5)
disp('----------')

disp('image(5,1)')
Image(5,1)
disp('----------')

disp('image(20,20)')
Image(20,20)
disp('----------')