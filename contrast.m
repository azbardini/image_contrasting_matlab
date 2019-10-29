image = imread('kids.tif');
equalized = histogramEq(image);
final = contrastStretch(equalized, 1);
showWBImages(image, equalized, final)

image = imread('spine.tif');
equalized = histogramEq(image);
final = contrastStretch(equalized, 1);
showWBImages(image, equalized, final)

image = imread('line.jpg');
hsvImage = rgb2hsv(image);
hue = hsvImage(:,:,1);
saturation = hsvImage(:,:,2);
value = hsvImage(:,:,3);

equalized = histogramEq(im2uint8(value));
final= contrastStretch(equalized, 0);

%concatena H S e V em 3 dimensoes
hsvHighValue = cat(3,hue,saturation,im2double(final));
backToRGB = hsv2rgb(hsvHighValue);
showColorImages(image, hsvImage, hsvHighValue, backToRGB);

function y = contrastStretch(img, useDouble)
    % transforma a imagem de signed pra double precision para evitar erros
    % de calculos abaixo de -255
    i = img(:,:,1);
    if useDouble == 1
        i = im2double(i);  
        topValue = 1;
    else
        topValue = 255;
    end
    % acha o pixel de menor valor na imagem
    minValue = min(min(i));
    % acha o pixel de maior valor na imagem
    maxValue = max(max(i));
    % acha a inclinaçcao do ponto de junção (0,255) para (minValue,maxValue)
    slope = topValue /(maxValue - minValue);
    % acha a intersecção da linha com o eixo
    intersection = topValue - slope*maxValue;
    % transforma a imagem de acordo com a inclinação
    y = slope*i + intersection;
end

function y = histogramEq(img)
    numofpixels=size(img,1)*size(img,2);
    %cria uma imagem preta
    imgHistogramed=uint8(zeros(size(img,1),size(img,2)));

    %cria vetor coluna de 0s para:
    %frequencia de intensidade
    freq=zeros(256,1);
    %probabilidade de cada intensidade (n/total)
    probf=zeros(256,1);
    %probabilidade acumulada
    probc=zeros(256,1);
    %resultado parcial
    cum=zeros(256,1);
    output=zeros(256,1);

    for i=1:size(img,1) %itera linhas
        for j=1:size(img,2) %itera colunas
            value=img(i,j); %value é a intensidade de um pixel
            freq(value+1)=freq(value+1)+1; %faz o somatorio de quantidade de valores dessa intensidade
            probf(value+1)=freq(value+1)/numofpixels; %faz a probabilidade de cada intensidade
        end
    end

    %itera sobre a matriz coluna de frequencia
    sumOfFrequencies=0;
    for i=1:size(freq)
        sumOfFrequencies = sumOfFrequencies + freq(i); %soma as frequencias
        cum(i) = sumOfFrequencies; %adiciona a frequencia somada de cada linha nesse vetor coluna
        probc(i) = cum(i)/numofpixels; %cria a probabilidade acumulada
        output(i) = round(probc(i)*255); %arredonda o resultado para colocar no histograma
    end

    %transcreve of valores da equalização para uma imagem
    for i=1:size(img,1)
        for j=1:size(img,2)
            imgHistogramed(i,j)=output(img(i,j)+1);
        end
    end
    y = imgHistogramed;
end

function y = showWBImages(image, equalized, final)
    figure
    subplot(2,3,1);
    imhist(image);
    title("Original");
    subplot(2,3,2);
    imhist(equalized);
    title("Equalizado");
    subplot(2,3,3);
    imhist(final);
    title("Equalizado com Contraste");
    subplot(2,3,4);
    imshow(image);
    subplot(2,3,5);
    imshow(equalized);
    subplot(2,3,6);
    imshow(final);
end

function y = showColorImages(image, hsvImage, hsvHighValue, backToRGB)
    figure
    subplot(2,2,1);
    imshow(image);
    title("Imagem Original");
    subplot(2,2,2);
    imshow(hsvImage);
    title("Imagem em HSV");
    subplot(2,2,3);
    imshow(hsvHighValue);
    title("Imagem em HSV com V alterado");
    subplot(2,2,4);
    imshow(backToRGB);
    title("Convertida para RGB");
end

