function bitrate=Conv_for_bit_rate(Dct_zzn,Num_of_blks_row,Num_of_blks_clmn)

set_params;

imQDCT = zeros(Num_of_blks_row*Blk_size,Num_of_blks_clmn*Blk_size);

dct_bq=zeros(Blk_size);

dct_ind = 1;

for i=1:Num_of_blks_row,
 for j=1:Num_of_blks_clmn,
     
  %Extract Block 
  dctzz_blck = Dct_zzn(:,dct_ind);
  dct_ind = dct_ind + 1;

  %reshape into dct block
  dct_bq(ZZ) = dctzz_blck;
  
  imQDCT(1+(i-1)*Blk_size:i*Blk_size,1+(j-1)*Blk_size:j*Blk_size) = dct_bq;

end

%i

end

bitrate=bit_rate(imQDCT);
