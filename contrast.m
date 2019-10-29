
image = imread('kids.tif');
equalized = histogramEq(image);
final = contrastStretch(equalized);
showImages(image, equalized, final)

image = imread('spine.tif');
equalized = histogramEq(image);
final = contrastStretch(equalized);
showImages(image, equalized, final)

function y = contrastStretch(img)
    % transforma a imagem de signed pra double precision para evitar erros
    % de calculos abaixo de -255
    i = im2double(img);                       
    % acha o pixel de menor valor na imagem
    minValue = min(min(i));
    % acha o pixel de maior valor na imagem
    maxValue = max(max(i));
    % acha a inclinaçcao do ponto de junção (0,255) para (minValue,maxValue)
    slope = 1 /(maxValue - minValue);
    % acha a intersecção da linha com o eixo
    intersection = 1 - slope*maxValue;
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


