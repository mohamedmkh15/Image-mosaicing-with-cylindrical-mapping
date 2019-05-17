function [k,d]=sift_features(img,w)

img= im2double(img);
img= rgb2gray(img);

[x,y]= interest_points(img);
[f] = features(img, x, y, w);

k(1,:)=x';
k(2,:)=y';

d=f';


end
