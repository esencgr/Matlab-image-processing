hardwareInfo=imaqhwinfo; % Kamera donan�m� hakk�nda gerekli bilgilerin al�nmas�
[camera_name, camera_id, format]=cameraInfo(hardwareInfo); % Donan�m bilgilerinden kameran�n �zelliklerinin ay�klanmas�
memoryInfo=imaqmem; % Bilgisayar�n bellek bilgisinin al�nmas�
imaqmem(memoryInfo.AvailPhys); % Kullan�ma m�sait b�t�n belle�in g�r�nt�  i�leme i�lemleri i�in kullan�labilir hale getirilmesi
video = videoinput(camera_name, camera_id, format); % Kamera �zelliklerine g�re video objesinin olu�turulmas�
 
set(video, 'FramesPerTrigger', Inf); % Videonun s�rekli frame almas� i�in gerekli d�zeltme
set(video, 'ReturnedColorspace', 'rgb'); % Videonun rgb uzayda d�nmesi i�in gerekli ayarlama
video.FrameGrabInterval = 1; % Videodan ne kadar s�kl�kla frame �ekilece�i.
 
start(video); % Videonun ba�lat�lmas�
preview(video);
stop (video);
