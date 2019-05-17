% here Vl_sift is used.. u have to run the Vl_setup at first .. the folder
% is attached 



clc; clear;

%  load images
 Dir = fullfile("..\adobe_panoramas\data\carmel")


Scene = imageDatastore(Dir);

% Display images to be stitched
montage(Scene.Files)

% Read the first image from the image set.
im1 = readimage(Scene, 1);
im1 = im2single(im1);

% Initialize features for im1
[k1,d1] = vl_sift(im1);

mosaicIm = im1;
numImages = numel(Scene.Files);
for i=2:5
    im2 = readimage(Scene, i);
    im2 = im2single(im2);
    [k2,d2] = vl_sift(im2);
   % mosaicIm = im2single(mosaicIm);
    [km,dm] = vl_sift(mosaicIm);

    [matches,~] = match_descr(d2,dm);
    
    [bestHomography, bestInlierCount] = RANSAC(k2,km,matches);
     mosaicIm = stitch (im2,mosaicIm,bestHomography);
%      mosaicIm = stitch_cylinder (im2,mosaicIm,bestHomography);

end
    
    
figure(2);
clf;
imagesc(mosaicIm);
axis image off ;
title('Mosaic') ;
colormap gray;
    
%% cylindrical mosaicing
im1 = readimage(Scene, 1);
f = 800;
im1=cylidrical_image(im1,f);
im1 = im2single(im1);
mosaicIm = im1;
[row,col] = find(im1 ~=0); % excluding the padding (the black area)
a = min(col(:));
b = min(row(:));
c = max(col(:));
d = max(row(:));

im1=imcrop(im1, [a b c d]);

for i=2:5
    im2 = readimage(Scene, i);
    im2=cylidrical_image(im2,f);
    im2 = im2single(im2);
    [row,col] = find(im2 ~=0); % excluding the padding (the black area)
    a2 = min(col(:));
    b2 = min(row(:));
    c2 = max(col(:));
    d2 = max(row(:));

    im2=imcrop(im2, [a2 b2 c2 d2]);
    [k2,d2] = vl_sift(im2);
   % mosaicIm = im2single(mosaicIm);
    [km,dm] = vl_sift(mosaicIm);

    [matches,~] = match_descr(d2,dm);
    
    [bestHomography, bestInlierCount] = RANSAC(k2,km,matches);
     mosaicIm = stitch (im2,mosaicIm,bestHomography);


end
    
    
figure(3);
clf;
imagesc(mosaicIm);
axis image off ;
title('Mosaic') ;
colormap gray;
    