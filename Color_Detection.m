clc
clear

%input image
ImageOri = imread('pc-01.jpg');
figure, imshow(ImageOri), title('Original Image')

%Convert image from RGB to HSV
HSV = rgb2hsv(ImageOri);
figure, imshow(HSV), title('HSV Image')

%Extract each component of HSV image to Hue, Saturation, and Value
Hue = HSV(:,:,1);
Saturation = HSV(:,:,2);
Value = HSV(:,:,3);
figure, imshow(Hue), title('Hue Image')
figure, imshow(Saturation), title('Saturation Image')
figure, imshow(Value), title('Value Image')

%Threshold value
bw_image = im2bw(Saturation,0.4);
figure, imshow(bw_image), title('Binary Image')

%Filling some of blank spot
bw_image = bwareaopen(bw_image,100);
bw_image = imfill(bw_image,'holes');
str = strel('disk', 5);
bw_image = imclose(bw_image, str);
bw_image = imclearborder(bw_image);
figure, imshow(bw_image), title('Filled Image')

%Labeling the color color
[L, num] = bwlabel(bw_image);
stats = regionprops(bw_image,'All');

%Output
figure, imshow(ImageOri);
hold on

Boundaries = bwboundaries(bw_image,'noholes');

%Color value
for n = 1:num
    bw2 = L==n;
    
    [a,b] = find(bw2==1);
    HueValue=0;
    
    for m = 1:numel(a)
        HueValue = HueValue+double(Hue(a(m), b(m)));
    end
    
    HueValue = HueValue/numel(a);
    
    if HueValue < 11/255 %Red color
        warna(n) = 1;
    elseif HueValue < 116/255 %Hijau color
        warna(n) = 2;
    elseif HueValue < 185/255 %Blue color
        warna(n) = 3;
    else %Red color
        warna(n) = 1;
    end
    
    boundary = Boundaries{n};
    centroid = stats(n).Centroid;
    
    text(centroid(1)-4, centroid(2), num2str(warna(n)),'Color','y','FontSize',8,'FontWeight','bold');
end

%Dataset
if warna == [1,2,3,1,2,3]
    Color_Tag = 'PC';
    title('PC Image');
elseif warna == [3,1,2,1,2,3]
    Color_Tag = 'Monitor';
    title('Monitor Image');
elseif warna == [3,1,2,3,1,2]
    Color_Tag = 'Meja';
    title('Meja Image');
elseif warna == [2,3,1,3,1,2]
    Color_Tag = 'Kursi';
    title('Kursi Image');
elseif warna == [2,3,1,2,3,1]
    Color_Tag = 'Keyboard';
    title('Keyboard Image');
elseif warna == [1,2,3,2,3,1]
    Color_Tag = 'Papan';
    title('Papan Image');
elseif warna == [1,3,2,2,1,3]
    Color_Tag = 'Laptop';
    title('Laptop Image');
else
    Color_Tag = 'Invalid Color';
end

fprintf('Tag  = %s\n', Color_Tag)
