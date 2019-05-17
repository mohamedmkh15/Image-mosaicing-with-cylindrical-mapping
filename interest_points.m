function [x,y]= interest_points(img)


%horizontal and vertical derivatives
sobel_y= [-1 0 1; 0 0 0 ; -1 0 1];
sobel_x= [-1 -1 -1; 0 0 0 ; 1 1 1];

%convolution with sobel filters
Ix= imfilter(img, sobel_x);
Iy= imfilter(img, sobel_y);

%convolving Ix^2, Iy^2 and Ixs with gaussian filters
f = fspecial('gaussian');
Ixx = imfilter(Ix.^2, f);
Iyy = imfilter(Iy.^2, f);
Ixy = imfilter(Ix.*Iy, f);

[r,c]=size(img);

%computing harris corners matrix
k=0.04;
H = (Ixx.*Iyy - Ixy.^2) - k*(Ixx + Iyy).^2;

%nom-maximum suppression 
R=(1000/max(max(H)))*H;
radius=1;
threshold=80;
sze = 2+radius;
MX = ordfilt2(R,sze^2,ones(sze));
R11 = (R==MX)&(R>threshold); 
[x,y]=find(R11);

%removing corners at the corners of the image
a=find(x==1)
x(a)=[];
y(a)=[];

b=find(x==max(x))
x(b)=[];
y(b)=[];

%uncomment when you want to plot 
% figure,
% imshow(img),
% hold on,
% plot(y,x,'ys')

end 