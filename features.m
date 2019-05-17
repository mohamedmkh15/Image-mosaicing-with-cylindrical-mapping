function [features] = features(img, x, y, descriptor_window_image_width)



%initial constants 
sobel_y= [1 2 1 ; 0 0 0 ; -1 -2 -1];  %sobel filters
sobel_x= sobel_y';
dw=descriptor_window_image_width;
features = zeros(size(x,1), 128, 'single');
[r,c]=size(x);

bins=0:10:360; % 10-spaced-angles bins
bins2=0:45:360; %45-spaced-angles bins 
index=1:4:dw;  %indices used in generating sift features loop 


%loop on the entire interest points
for i=1:1:r
    
    %convolving the window around the interesting point with sobel filters
    Gx=imfilter(img(x(i)-dw/2:x(i)+(dw/2)-1 , y(i)-dw/2: y(i)+(dw/2)-1),sobel_x);
    Gy=imfilter(img(x(i)-dw/2:x(i)+(dw/2)-1 , y(i)-dw/2: y(i)+(dw/2)-1),sobel_y);
    
    %finding the direction of the window
    Gdir=round(abs(atan2(Gy,Gx))*180/pi);
    
    bins_hist=[];  %array to store the first historgram
    
    %Discretization of the window's angles to 36 bins and finding the histogram
    for j=1:1:length(bins)-1
        bins_hist(j)=sum(sum(Gdir<bins(j+1) & Gdir>bins(j)));
        Gdir(Gdir<bins(j+1) & Gdir>bins(j))=bins(j+1);
    end 
    
    %finding the maximum orientation and rotating the window
    final_orientation(i)=find(max(bins_hist))*10;
    Gdir=Gdir-final_orientation(i);
    
   co=0;
   bins_hist2=[];
   feat=zeros(16,8);
    %two loops on the divided windows 
    for l=1:1:(dw/4)
        for v=1:1:(dw/4)
    
            Gdir2=Gdir(index(l):index(l)+3, index(v):index(v)+3);
            Gdir2(Gdir2<0)= Gdir2(Gdir2<0)+360; %removing negative angles
            
            
            %Discretization of the window's angles to 10 bins and finding the histogram
            for m=1:1:length(bins2)-1
                bins_hist2(m)=sum(sum(Gdir2<bins2(m+1) & Gdir2>bins2(m)));
                Gdir2(Gdir2<bins2(m+1) & Gdir2>bins2(m))=bins2(m+1);
            end
%             disp(co)
%             disp('errorrrrrr')
%             disp(bins_hist2)
            co=co+1
            %concatenating the 8 bits angles 
            feat(co,:)=bins_hist2;

        end

    end


      feat=reshape(feat', [1,128]);
      features(i,:)=feat
          
     disp('aaa')
     disp(feat)
      [gg,hh]=size(feat);
      features(i,:)=feat;
           
end 

end

