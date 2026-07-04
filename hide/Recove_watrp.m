function Recove_watrp(Ext,Num_of_blks_row,Num_of_blks_clmn,inbits)

xx = 41;
yy = 50;

%restore pict
Wa_str = dec2bin(Ext,4);

wapart1 = Wa_str(1:2:end,:); 
wapart2 = Wa_str(2:2:end,:); 

recbins = dec2bin(zeros(1,size(Wa_str,1)/2),8);

recbins(:,1:2:end) = wapart1;
recbins(:,2:2:end) = wapart2;

Ln_p_w = bin2dec(recbins);

%append
pnd =xx*yy-length(Ln_p_w);
Ln_p_w = [Ln_p_w ; zeros(pnd,1)];

Yr = reshape(Ln_p_w,xx,yy);

figure(20);subplot(1,2,2);imshow(Yr/255,256);

