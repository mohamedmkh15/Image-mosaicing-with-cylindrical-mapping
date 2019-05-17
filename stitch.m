% This function receives the two images and homography matrix and then
% transforms the second image into the coordinates of the first image


function stitchedImage = stitch( im1, im2, homography)
 
stitchedImage = im1;
%pad image one with extra columns equal to no. of columns of image two
stitchedImage = padarray(stitchedImage, [0 size(im2, 2)], 0, 'post');
%pad image one with extra rows before and after image one, equal to no. of rows of image two
stitchedImage = padarray(stitchedImage, [size(im2, 1) 0], 0, 'both');

for i = 1:size(stitchedImage, 2)
    for j = 1:size(stitchedImage, 1)
        % multiply each point in the padded image twith the homography
        % matrix to change it into im2 coordinates
        % ---> the indexing below to make sure the origin(0,0) point is at
        % the start of the image not the padding as shown in the explantion
        % attached.
        p2 = homography * [i; j-floor(size(im2, 1)); 1];
        p2 = p2 ./ p2(3);   % Normalization

        x2 = floor(p2(1));
        y2 = floor(p2(2));
        
        % we have transformed im1 to  coordinates of im2...now we just add
        % im 2 over that transformed image (over the common points only)
        if x2 > 0 && x2 <= size(im2, 2) && y2 > 0 && y2 <= size(im2, 1)
            stitchedImage(j, i) = im2(y2, x2);
        end
    end
end

% now we hav a mosaic but still the extra padding so we will just crop it
% below
%crop
[row,col] = find(stitchedImage); % excluding the padding (the black area)
c = max(col(:));
d = max(row(:));

st=imcrop(stitchedImage, [1 1 c d]);
% crops the image  according to rectangle [xmin ymin width height].
% it leaves onnly the image inside the rect so it works as a down right
% boundary to the image

a = min(col(:));
b = min(row(:));
st=imcrop(st, [1 b c d]);
% upper boundary to the image
stitchedImage = st;

end
