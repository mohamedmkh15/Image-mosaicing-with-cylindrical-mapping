function cyl_image = cylidrical_image(image,focalLength) 
 
x_c = size(image, 2) / 2;
y_c = size(image, 1) / 2;
for x = 1 : size(image, 2)
            for y = 1 : size(image, 1)
                x_b = focalLength * atan((x - x_c) / focalLength) + x_c;
                y_b = focalLength * (y - y_c) / sqrt((x - x_c)^2 + focalLength^2) + y_c;
                
cyl_image(round(y_b),round(x_b)) = image(y,x);
            end
end

end