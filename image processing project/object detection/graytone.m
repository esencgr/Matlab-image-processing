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
    img =rgb2gray( data );
    imshow(img,'Parent',hmain); % resmin gri hali
stop (video);
