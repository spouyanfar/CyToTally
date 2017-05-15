function [numberofspots,center] = ctctes(redPlane,greenPlane,bluePlane,RGBimage)
% clc
% clear
% 
% O=imread('RGB.jpg');
% RGBimage = O;
% B(:,:,3)=O(:,:,3);
% 
% G(:,:,2)=O(:,:,2);G(:,:,3)=0;
% 
% % R(:,:,2)=0;
% R(:,:,1)=O(:,:,1);R(:,:,3)=0;
% load('CAFCTC.mat');
G= greenPlane;
B= bluePlane;
R= redPlane;
% 
% % GBW = im2bw(G,0.05);
% subplot(3,2,1)
% imshow(GBW);

% % BBW = im2bw(B,0.05);
% subplot(3,2,2)
% imshow(BBW);
GB=G(:,:,2).*B(:,:,3);
GBBW = im2bw(GB);

% GBBW = GBW;
% % GBBW = GBW.* BBW;
% subplot(3,2,3)
% imshow(GBBW);
GBMASKED = bsxfun(@times,  cast(GBBW, 'like', RGBimage),RGBimage);
%                     GBMASKED = bsxfun(@times,  cast(GBBW, 'like', RGBimage),RGBimage);

% subplot(3,2,4)
% imshow(GBMASKED);

% % RCBW = imcomplement(im2bw(R,.05));
% % RGBMASKED = RCBW.* (im2bw(GBMASKED));
% % RGBMASKEDOR = bsxfun(@times,  cast(RGBMASKED, 'like', RGBimage),RGBimage);
% subplot(3,2,5)
% imshow(RGBMASKEDOR);

% stats = regionprops('table',im2bw(RGBMASKEDOR),'Centroid','MajorAxisLength','MinorAxisLength');
stats = regionprops('table',im2bw(GBMASKED),'Centroid','Area');

centers = stats.Centroid;
AreaSpot = stats.Area; %mean([stats.MajorAxisLength stats.MinorAxisLength],2);
% imshow(RGBimage);
center =[0,0];
[nofarea,jj]=size(AreaSpot);
j=1;
for i=1:nofarea
    if AreaSpot(i)>30 && AreaSpot(i)<200
        SelArea(j,1)=AreaSpot(i);
        center(j,:)=centers(i,:);
%         radiu(j,1)=diameter(j,1)/2;
        j=j+1;
    end
end
% center = centers;
% numberofspots = nofarea;
numberofspots = j-1; 
% 
