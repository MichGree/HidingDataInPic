function [Dct_zz,Dct_org] = Make_dct_ZZ(Host,Num_of_blks_row,Num_of_blks_clmn)
%Dct_zz  - quantized (not rounded)zigzag order matrix 
%          N_coef X N_dct_blocks_zz_order 
%Dct_org - non quantized zigzag order matrix   
%          N_coef X N_dct_blocks_zz_order 


set_params;

% Normalize Host
Host = Host-128;
 
Dct_zz = zeros(Blk_size^2,Num_of_blks_row*Num_of_blks_clmn);
Dct_org = Dct_zz;

dct_ind = 1;

for i=1:Num_of_blks_row,
 for j=1:Num_of_blks_clmn,
     
  %Extract Block 
  host_blck = Host(1+(i-1)*Blk_size:i*Blk_size,1+(j-1)*Blk_size:j*Blk_size);
 
  %Dct
  dct_hostb=dct2(host_blck);
  Dct_org(:,dct_ind)= dct_hostb(ZZ)';
  
  %Quntizer
  dct_hostbq = dct_hostb./Q;
  
  %reshape into zigzag 
  Dct_zz(:,dct_ind)= dct_hostbq(ZZ)';
  dct_ind = dct_ind + 1;
  
end

%i

end

 