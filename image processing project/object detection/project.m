%% �n Tan�mlama B�lgesi
clc;
% Kolay kullan�m a��s�ndan de�i�kenleri silmeden durdurup tekrar
% �al��t�r�lmas� i�in yap�lan kontrol. B�ylelikle stop d��mesi ile program
% durdurulup, tekrar run ile kald��� yerden devam edilebilir
if(~exist('video','var'))
    hardwareInfo=imaqhwinfo; % Kamera donan�m� hakk�nda gerekli bilgilerin al�nmas�
    [camera_name, camera_id, format]=cameraInfo(hardwareInfo); % Donan�m bilgilerinden kameran�n �zelliklerinin ay�klanmas�
    memoryInfo=imaqmem; % Bilgisayar�n bellek bilgisinin al�nmas�
    imaqmem(memoryInfo.AvailPhys); % Kullan�ma m�sait b�t�n belle�in g�r�nt� i�leme i�lemleri i�in kullan�labilir hale getirilmesi
    video = videoinput(camera_name, camera_id, format); % Kamera �zelliklerine g�re video objesinin olu�turulmas�
    %% Videonun ve bulunan objelerin g�sterilmesi i�in gerekli figure'lerin a��lmas�
    figure;
    hmain = gca;
    f=figure;
    % Durdurma Butonu
    isRunning = 1;
    u=uicontrol('String','Stop','Callback','isRunning = 0; disp(''Hesaplamalar Durduruldu.'')',...                                                                                                             %
    'ForegroundColor','w','BackgroundColor','r','Fontsize',14,'FontWeight','Demi','Position',[1 1 60 60]); 
    set(u,'position',[1 1 60 60])
    %stop butonunun g�r�n�m� ile ilgili yaz� ve 
    %butonun b�y�kl�k ve pozisyon ayarlar� 
    hsub = zeros(1,16);           %bulunan ve g�sterilecek olan maksimium nesne say�s�n�n belirlenmesi 
    for i = 1:16                  %ve gerekli figure pencerelerinin a��lmas�
         hsub(i) = subplot(4,4,i);
    end
else
    isRunning = 1;
    stop(video);                      %videonun durdurulmas� 
    flushdata(video);                 %belle�in bo�alt�lmas�
end
%% Ana D�ng�de kullan�lan De�i�kenlerin Tan�mlanmas�
% ("doc framegrabinterval" komutundaki �ekil incelerek bu k�s�m�n i�leyi�i hakk�nda bilgi edinilmi�tir .)
set(video, 'FramesPerTrigger', Inf); % Videonun s�rekli frame almas� i�in gerekli d�zeltme
set(video, 'ReturnedColorspace', 'rgb'); % Videonun rgb uzayda d�nmesi i�in gerekli ayarlama
video.FrameGrabInterval = 1; % Videodan ne kadar s�kl�kla frame �ekilece�i.

start(video); % Videonun ba�lat�lmas�
% ��z�n�rl���n dinamik olarak ayarlanmas�
resolutionY = str2double(format(strfind(format,'_')+1:strfind(format,'x')-1));
resolutionX = str2double(format(strfind(format,'x')+1:length(format)));
% De�i�kenlerin �n tan�mlanmas�
img = zeros(resolutionX,resolutionY);
imgSize = resolutionX*resolutionY;
objPosition = zeros(3,3,16);
filledImage = cell(16,1);
boundingBox = cell(16,1);
centroid = cell(16,1);
area = zeros(16,2);
threshold = 33; % Mavi renk katman�ndan ne kadar mavi olan renklerin se�ilece�inin e�ik de�eri

%% As�l Video D�ng�s�
while isRunning
    data = getsnapshot(video); % Videodan ekran g�r�nt�s� al�nmas�
    img = imsubtract(data(:,:,3), rgb2gray(data)); % Mavi resim katman�ndan gri katman�n ��kar�lmas�
    img = medfilt2(img, [9 9]); % 9x9 Median filtresi uygulanmas�
    % E�ik de�erine g�re renklerin ay�klanmas�
    img(img<threshold) = 0;
    img(img>=threshold) = 255;
    img = bwareaopen(img,(imgSize)/1200); % K���k objelerin resimden ay�klanmas� (Resim alan�n 1200'de birinden k���k objeler at�lmaktad�r)
    
    data(img>0) = 255; % Bulunan mavi b�lgelerin resim �zerine boyanmas�
    imshow(data,'Parent',hmain); % Mavi objelerin boyanm�� halde g�sterilmesi
    
    hold(hmain,'on')
    
    [Label, Count] = bwlabel(img, 4); % 4 Kom�ulu�una g�re ba�l� bile�enlerin bulunmas� (8 kom�ulu�u ile ayn� sonucu daha h�zl� sa�lamakta)
    clc
    disp(['Count = ' num2str(Count)]);
    stats = regionprops(logical(Label),'BoundingBox','Centroid','FilledImage','Area'); % Ba�l� bile�enlerin �zelliklerinin ��kar�lmas�
    
    if(exist('stats','var')) % Herhangi bir obje bulunmas� durumunda
        for object = 1:length(stats) % Bulunan her obje i�in
            if(object < 16 && object > 0) % Obje say�s� s�n�rlamas�
                boundingBox{object} = stats(object).BoundingBox; % Objeyi �evreleyen dikd�rtgenin koordinatlar�
                centroid{object} = stats(object).Centroid; % Objenin merkez noktas� koordinatlar�
                area(object,2) = stats(object).Area; % Objenin alan�
                if(area(object,2) >= 0) % Objenin alan�n�n kontrol�ne g�re �nceki alan bilgisinin g�ncellenmesi
                    area(object,1) = area(object,2);
                end
                
                % Objenin bir �nceki konumundan ne kadar uzakla�t���n�n hesaplanmas�
                dx=round(objPosition(2,1,object)-objPosition(1,1,object));
                dy=round(objPosition(2,2,object)-objPosition(1,2,object));
                
                filledImage{object} = stats(object).FilledImage; % Objenin k���k resminin al�nmas�
                rectangle('Position',boundingBox{object},'EdgeColor','r','LineWidth',2,'Parent',hmain) % Objenin etraf�na dikd�rtgen �izilmesi
                plot(hmain,centroid{object}(1),centroid{object}(2), ' ys','MarkerSize',6,'MarkerFaceColor','y') % Merkez noktas�na sar� i�aret�i konulmas�
                imshow(filledImage{object},'Parent',hsub(object)) % Bulunan k���k resimlerin ikinci grafi�e �izilmesi
                title(hsub(object),[num2str(object) '. Obje']); % Objelerin ba�l�klar�n�n atanmas�
                objPosition(1,:,object) = objPosition(2,:,object); % Objenin eski konumunun g�ncellenmesi
                objPosition(2,:,object) = [centroid{object}(1),centroid{object}(2),area(object,2)/imgSize]; % Objenin yeni konumunun bulunmas�
                
              
                if(length(stats) == 1) % Tek obje bulunmas� durumunda
                    % Objenin konumlar�n�n bulunmas�n ve tek obje olmas�
                    % durumunda h�z ,konum ,alan bilgileri
                   
                    x = boundingBox{object}(1);
                    y = boundingBox{object}(2);
              
                    txtInfo = text(centroid{object}(1)+15,centroid{object}(2),...
                    [num2str(object) '. X: ' num2str(round(centroid{object}(1))) ' Y: ' num2str(round(centroid{object}(2)))],'Parent',hmain);
                    txtSpeed = text(centroid{object}(1),centroid{object}(2)+15,...
                    [' dx: ' num2str(dx) ' dy: ' num2str(dy) '  area: ' num2str(round(area(object,2)))],'Parent',hmain);
                    set(txtInfo, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
                    set(txtSpeed, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
                    % G�r�lt�den veya objenin engel arkas�na gitmesindendolay� alandaki de�i�ikliklerin ekarte edilmesi
                    % bu k�s�m tek obje olmas� durumunda hesaplanabilece�inden
                    % if else kullan�larak ayr�ca belirtildi     
                   
                    if(area(object,2)/area(object,1) >= 0.9 && area(object,2)/area(object,1) <= 1.1)
                        theImage = stats(object).FilledImage;
                    end
                    
                    
                else % Birden fazla obje olmas� durumunda
                    % H�z, Konum, Alan bilgilerinin kullan�c�ya g�sterilmesi
                    txtInfo = text(centroid{object}(1)+15,centroid{object}(2), [num2str(object)...
                        '. X: ' num2str(round(centroid{object}(1))) '   Y: ' num2str(round(centroid{object}(2)))],'Parent',hmain);
                    txtSpeed = text(centroid{object}(1),centroid{object}(2)+15, ['   dx: ' num2str(dx)...
                        '   dy: ' num2str(dy) '  area: ' num2str(round(area(object,2)))],'Parent',hmain);
                    set(txtInfo, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
                    set(txtSpeed, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
                end
            end
        end
    end
    
    % Objenin bilgileri varsa fakat ekranda hi� obje yoksa cismin
    % hareketinin tahmini
    if(exist('object','var') && exist('x','var') && exist('y','var') && length(stats) < 1)
        % Cismin sabit h�zla ayn� y�nde gitti�i tahmin edilerek bir sonraki
        % konumunun hesaplanmas�
        x=x+dx;
        y=y+dy;
        % Bulunan konuma k���k resmin �izilmesi
        image(x,y,theImage*255,'Parent',hmain);
    end
    
    drawnow
    hold(hmain,'off')
    
    % Performans a��s�ndan RAM'in dolmamas� i�in belle�in her 100 kare
    % al�nd���nda bir s�f�rlanmas�
    if mod(video.FramesAcquired,100)==0
        flushdata(video);
    end
end

% Stop d��mesine bas�ld�ktan sonra d�ng�nden ��k�p videoyu durdurup
% belle�in bo�alt�lmas�
stop(video);
flushdata(video);
