function [ img2 ] = odev2imrotate( img)

img = imread(img);

img2=imrotate(img,180,'bilinear','crop');

subplot(121), imshow(img); title ('original image');
subplot(122), imshow(img2); title ('180 degree rotate image');


end
