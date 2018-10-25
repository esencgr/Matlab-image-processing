hardwareInfo=imaqhwinfo; % Kamera donan�m� hakk�nda gerekli bilgilerin al�nmas�
[camera_name, camera_id, format]=cameraInfo(hardwareInfo); % Donan�m bilgilerinden kameran�n �zelliklerinin ay�klanmas�
memoryInfo=imaqmem; % Bilgisayar�n bellek bilgisinin al�nmas�
imaqmem(memoryInfo.AvailPhys); % Kullan�ma m�sait b�t�n belle�in g�r�nt�  i�leme i�lemleri i�in kullan�labilir hale getirilmesi
video = videoinput(camera_name, camera_id, format); % Kamera �zelliklerine g�re video objesinin olu�turulmas�
 
set(video, 'FramesPerTrigger', Inf); % Videonun s�rekli frame almas� i�in gerekli d�zeltme
set(video, 'ReturnedColorspace', 'rgb'); % Videonun rgb uzayda d�nmesi i�in gerekli ayarlama
video.FrameGrabInterval = 1; % Videodan ne kadar s�kl�kla frame �ekilece�i.
 
start(video); % Videonun ba�lat�lmas�
% ��z�n�rl���n dinamik olarak ayarlanmas�
resolutionY = str2double(format(strfind(format,'_')+1:strfind(format,'x')-1));
resolutionX = str2double(format(strfind(format,'x')+1:length(format)));
% De�i�kenlerin �n tan�mlanmas�
hmain = gca;
img = zeros(resolutionX,resolutionY);
imgSize = resolutionX*resolutionY;
threshold = 33; % Mavi renk katman�ndan ne kadar mavi olan renklerin se�ilece�inin e�ik de�eri
preview(video);
data = getsnapshot(video); % Videodan ekran g�r�nt�s� al�nmas�
    img = imsubtract(data(:,:,3), rgb2gray(data)); % Mavi resim katman�ndan gri katman�n ��kar�lmas�
    img = medfilt2(img, [9 9]); % 9x9 Median filtresi uygulanmas�
    % E�ik de�erine g�re renklerin ay�klanmas�
    img(img<threshold) = 0;
    img(img>=threshold) = 255;
    img = bwareaopen(img,(imgSize)/1200); % K���k objelerin resimden ay�klanmas� (Resim alan�n 1200'de birinden k���k objeler at�lmaktad�r
    data(img>0) = 255; % Bulunan mavi b�lgelerin resim �zerine boyanmas�
    imshow(data,'Parent',hmain); % Mavi objelerin boyanm�� halde g�sterilmesi
stop (video);
