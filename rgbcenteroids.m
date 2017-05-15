function [numberofspots,center] = rgbcenteroids(redPlane,greenPlane,bluePlane,RGBimage)


G= greenPlane;
B= bluePlane;
R= redPlane;
% 
GBW = im2bw(G);
% subplot(3,2,1)
% imshow(GBW);
BBW = im2bw(B,.11);
% subplot(3,2,2)
% imshow(BBW);
GBBW = GBW.* BBW;
% subplot(3,2,3)
% imshow(GBBW);
GBMASKED = bsxfun(@times,  cast(GBBW, 'like', RGBimage),RGBimage);
% subplot(3,2,4)
% imshow(GBMASKED);
RBW = im2bw(R,.11);
RGBMASKED = RBW.* (im2bw(GBMASKED));
RGBMASKEDOR = bsxfun(@times,  cast(RGBMASKED, 'like', RGBimage),RGBimage);
% subplot(3,2,5)
% imshow(RGBMASKEDOR);

stats = regionprops('table',im2bw(RGBMASKEDOR),'Centroid','MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
% imshow(RGBimage);
center =[0,0];
[nofarea,jj]=size(diameters);
% j=1;
% for i=1:nofarea
%     if diameters(i)>20 && diameters(i)<60000000
%         
%         diameter(j,1)=diameters(i);
%         center(j,:)=centers(i,:);
%         radiu(j,1)=diameter(j,1)/2;
%         j=j+1;
%     end
%     
% end
% numberofspots = j-1;
center = centers;

numberofspots = nofarea;

