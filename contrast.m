% 
% image = imread('kids.tif');
% equalized = histogramEq(image);
% final = contrastStretch(equalized);
% showImages(image, equalized, final)
% 
% image = imread('spine.tif');
% equalized = histogramEq(image);
% final = contrastStretch(equalized);
% showImages(image, equalized, final)

image = imread('line.jpg');

hsvImage = rgb2hsv(image);
hue = hsvImage(:,:,1);
saturation = hsvImage(:,:,2);
value = hsvImage(:,:,3);

equalized = hist_eq(value);
finalValue = contrastStretch(equalized);
figure,imshow(finalValue)

newHsvImage = cat(3,hue,saturation,finalValue);
finalImage = hsv2rgb(newHsvImage);

subplot(2,2,3);
imshow(hsvImage);
title("Original HSV");

subplot(2,2,2);
imshow(newHsvImage);
title("Equalized and Contrasted Image");

subplot(2,2,1);
imshow(image);
title("Original Image");

subplot(2,2,4);
imshow(finalImage);
title("Equalized and Constrated Image");


function y = contrastStretch(img)
    % transforma a imagem de signed pra double precision para evitar erros
    % de calculos abaixo de -255
    i = img(:,:,1);
%    i = im2double(i);                       
    % acha o pixel de menor valor na imagem
    minValue = min(min(i));
    % acha o pixel de maior valor na imagem
    maxValue = max(max(i));
    % acha a inclinaçcao do ponto de junção (0,255) para (minValue,maxValue)
    slope = 255 /(maxValue - minValue);
    % acha a intersecção da linha com o eixo
    intersection = 255 - slope*maxValue;
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

function y = showImages(image, equalized, final)
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

function I_out=hist_eq(I_in)
[M,N]=size(I_in);
for i=1:256
    % Soma todos os valores de "i-1" da imagem no H(i)
   h(i)=sum(sum(I_in == i-1));
end;

% Imagem de saida = Imagem de entrada
I_out=I_in;

% Soma todos os valores de todos os pixeis da imagem (já foram somados em
% cada h(i)

s=sum(h);

for i=1:256
    % Posicoes é um vetor de todas as posicoes que "i-1" aparece na imagem
    % I_in
   posicoes=find(I_in==i-1);
   % Todas as posicoes de I_out recebem a soma de H(1) até H(i) dividido
   % pela soma de todos os pixeis da imagem * 255
   I_out(posicoes)=sum(h(1:i))/s*255;
end
end


