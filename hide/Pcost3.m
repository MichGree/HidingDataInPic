function [new_qdct] = Pcost3(states,Dct_zz,par,Dct_org)

set_params;

deb = 0;


epsilon = 1e-10;
Float_big = 1e32;

x = abs(Dct_zz) + epsilon;

[coef,samples] = size(Dct_zz);


ix=round(x);

new = ix;
newA = new;


default_par=rem(sum(ix),states);
  
wanted_par=par;

steps_up = mod(wanted_par-default_par,states);

steps_down= mod(default_par-wanted_par,states);

   
   
[ru,rd,ruA,rdA] = Generate_Criteria(x,ix,Dct_org);

for k=1:samples,
   
   [up,X] = sort(ru(:,k));
   [down,Y] = sort(rd(:,k));
      
   best=(sum(up(1:steps_up(k)).^2)<sum(down(1:steps_down(k)).^2));
   
   tmp = Q/(max(max(Q)));
   zQ = tmp(ZZ)';
   
   [upA,XA] = sort(ruA(:,k).*zQ);
   [downA,YA] = sort(rdA(:,k).*zQ);
   
   bestA=(sum(upA(1:steps_up(k)).^2)<sum(downA(1:steps_down(k)).^2));
   
   if best,
      new(X(1:steps_up(k)),k)=ix(X(1:steps_up(k)),k)+1;   
   else
      new(Y(1:steps_down(k)),k)=ix(Y(1:steps_down(k)),k)-1;   
   end
  
   
   if bestA,
      newA(XA(1:steps_up(k)),k)=ix(XA(1:steps_up(k)),k)+1;   
   else
      newA(YA(1:steps_down(k)),k)=ix(YA(1:steps_down(k)),k)-1;   
   end
  
 if deb == 1,  
   
   %debug
   new_qdct = new(:,k);%new; % ix- for compression only

   sign_dct = sign(Dct_zz(:,k));
   sign_dct(find(sign_dct==0))=1;
   new_qdct = new_qdct.*sign_dct;   
   
   
   new_qdctA = newA(:,k);%new; % ix- for compression only

   sign_dct = sign(Dct_zz(:,k));
   sign_dct(find(sign_dct==0))=1;
   new_qdctA = new_qdctA.*sign_dct;   
   
   tmp=zeros(8);
   tmp(ZZ)=Dct_org(:,k);
   Orig = idct2(tmp)+128;
      
   tmp(ZZ) = round(Dct_zz(:,k));
   dj =tmp.*Q;   
   JPG = idct2(dj)+128;

   tmp(ZZ) = new_qdct;
   dh =tmp.*Q;   
   Half = idct2(dh)+128;

   tmp(ZZ) = new_qdctA;
   da =tmp.*Q;   
   Amp = idct2(da)+128;
  
   %picture diff      
   
   r = Orig - JPG;
   mse = sum(sum(r.^2))/64;
   PSNRj = 10 *log10(255^2/mse);
 
   r = Orig - Half;
   mse = sum(sum(r.^2))/64;
   PSNRh = 10 *log10(255^2/mse);
  
   r = Orig - Amp;
   mse = sum(sum(r.^2))/64;
   PSNRa = 10 *log10(255^2/mse);
   
   if PSNRa + 2 < PSNRh,
         figure(6);subplot(2,2,1);stem(Dct_org(:,k));
         figure(6);subplot(2,2,2);stem(dj(ZZ));
         figure(6);subplot(2,2,3);stem(dh(ZZ));
         figure(6);subplot(2,2,4);stem(da(ZZ));
   figure(7);subplot(2,2,1);imshow(Orig/255,256);
   figure(7);subplot(2,2,2);imshow(JPG/255,256);
   title(['JPG:PSNR = ' num2str(PSNRj)]);
   figure(7);subplot(2,2,3);imshow(Half/255,256);
   title(['Half:PSNR = ' num2str(PSNRh)]);
   figure(7);subplot(2,2,4);imshow(Amp/255,256);
   title(['Amp:PSNR = ' num2str(PSNRa)]);

      a=1;
   end
   
   SPSNRa(k) = PSNRa;
   SPSNRh(k) = PSNRh;
         
  end 
   
end
 
 %add
 if Metods == 0,
   new_qdct = ix;
elseif Metods==1,
    new_qdct = new; 
else
   new_qdct = newA;%newA;%new % ix- for compression only
end
        
sign_dct = sign(Dct_zz);
sign_dct(find(sign_dct==0))=1;
new_qdct = new_qdct.*sign_dct;
   
   
%save  SPSNR  SPSNRa SPSNRh