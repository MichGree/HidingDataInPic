function [Host,Num_of_blks_row,Num_of_blks_clmn]=Get_picture(indx)

set_params;

switch indx
   case 0, 
      lenna;
      Host  = J';
   case 1, 
      load clown;
      Host  = X; 
      
   case 2,
      [X,map]=bmpread('lee.bmp');    
      Host = X(50:320,20:320);
      
   case 3,
      load swans;
      Host = B;
      
   case 4,
      load babon;
      Host = P;
   case 5,   
      [X,map]=bmpread('full_el.bmp');   
      Host = X(:,:,1);
      
   case 6,
      [X,map] = imread('C:\Program Files\Canon\ZoomBrowser EX\Image Library One\Samples\Transport\SmpImg46.jpg','jpg');
      Host = double(X(:,:,3));
      
   case 7,
      %[X,map] = tiffread('lena_std.tiff');
      % Read the image
       RGB = imread('lena_std.tiff');

     % Extract individual color channels
      R = double(RGB(:,:,1));
      G = double(RGB(:,:,2));
      B = double(RGB(:,:,3));
      
      Host = R+G+B;
   otherwise,
      load trees;
      Host = X;
end

%incrop picture in size of Blk_size*x
[rows,clms] = size(Host);
Num_of_blks_row = fix(rows/Blk_size);
rows = Num_of_blks_row * Blk_size;
Num_of_blks_clmn = fix(clms/Blk_size);
clms = Num_of_blks_clmn* Blk_size;
Host   = Host(1:rows,1:clms);

%Normalize to 0...255 (max contrast)
Host = round(Host/(max(max(Host)))*255);