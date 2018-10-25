
rgbImg = imread('rgbresim.png');
imshow(rgbImg)
size(rgbImg)

figure
img = rgb2gray(rgbImg);


imshow(img)
truesize(4*size(img))
title('Ekrandaki bir piksele dört resim pikseli geldi')

figure
imgRescaled = imresize(img, 0.75, 'bil');
imshow(imgRescaled)
title('0.75 oranda ölçeklenmiþ resim')

figure 
imgRescaled = imresize(img, [100 150], 'bil');
imshow(imgRescaled)
title('100x150 piksele ölçeklenmiþ resim')

figure
imgRotated = imrotate(img, 30, 'bil', 'crop');
imshow(imgRotated)
title('30 derece döndürülüp orijinal boyutuna kýrpýlmýþ resim')