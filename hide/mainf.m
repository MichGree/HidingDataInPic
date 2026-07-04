%EMBED main function
% 

function mainf(inbits)

set_params;

%get host picture
[Host,Num_of_blks_row,Num_of_blks_clmn] = Get_picture(7);

%show host picture
figure(1);subplot(2,2,1);imshow(Host,[]);

%convert host to DCT domain
[Dct_zz,Dct_org] = Make_dct_ZZ(Host,Num_of_blks_row,Num_of_blks_clmn);

%Sviva - calculate standard deviation
%T = [0 40 80 120]; %typical STD bondaries

%1 T = [5 8 15 50 80]; %typical STD bondaries
%T = [7 15 30 60 120];

%LAST
T = [7 10 30 80 120];% 60->80  

%compar with JMark
%2034 bits: payload_factor= 8, lenna=R+B+G, Q = 0.48(0.5), *1.3
%1938 bits: payload_factor= 8, lenna=R+B+G, Q = 0.97(1), T=T*1.347
%1667 bits: payload_factor= 8, lenna=R+B+G, Q = 1.5, T=T*1.485
%1582 bits: payload_factor= 8, lenna=R+B+G, Q = 2, T=T*1.533
%1653 bits: payload_factor= 8, lenna=R+B+G, Q = 2.5, T=T*1.493
%1364 bits: payload_factor= 8, lenna=R+B+G, Q = 3, T=T*1.72

Std=std(Dct_org(2:end,:)) + (abs(Dct_org(1,:))).^0.3;

%Calc Mean & Energ AC DCT
if mean_energ_f ==1,
 MeanAC_DCT = mean(Dct_org(2:end,:));
 EnergyAC_DCT = mean(abs(Dct_org(2:end,:)));
end
%T = [0 200 600 80]; %typical STD bondaries
%Std=std(Dct_org(2:end,:)).*(abs(Dct_org(1,:)).^0.5);


figure(10);plot(Std);

if inbits == -1,
 %Adaptive stream set   
 
 states = ones(size(Std))*max(4/payload_factor,1);
 t1  = find(Std<T(1));
 
 t12  = find(Std>=T(1) & Std<T(2));
 states(t12)=max(8/payload_factor,1);
 
 t23 = find(Std>=T(2) & Std<T(3));
 states(t23)=max(16/payload_factor,1);

 t34=find(Std>=T(3) & Std<T(4));
 states(t34)=max(32/payload_factor,1);
 
 t45 = find(Std>T(4));
 states(t45)=max(64/payload_factor,1);
 
[length(t1) length(t12) length(t23) length(t34) length(t45)]


else
%Fix stream set
 state = 2^inbits;
 states = ones(1,Num_of_blks_row*Num_of_blks_clmn)*state;%32;%16;
end

%calculate num of embedded bits
bits = sum(log2(states))

%watermark set
rand('state',0); 
Secret=round(rand(1,Num_of_blks_row*Num_of_blks_clmn).*(states-1));
%Secret=ones(1,Num_of_blks_row*Num_of_blks_clmn)*0;
%Secret = read_jpg(states);
%Secret = Get_watrp(Num_of_blks_row*Num_of_blks_clmn,inbits);

%Embedding
[Dct_zzn] = Pcost3(states,Dct_zz,Secret,Dct_org);

%Attack
if attack_requant == 1,
   [Dct_zzn] = Attack_DCT(Dct_zzn);
end

if attack_pict_dom == 1,   
  %Restore to picture domain
 [WdHost] = ReBuildHost(Dct_zzn,Num_of_blks_row,Num_of_blks_clmn); 
 [WdHost] = Attack_pict(WdHost);
 
 figure(1);subplot(2,2,3);imshow(WdHost/max(max(Host)),256);
 title(['Attack picture domain']);

  %convert host to DCT domain
 [Dct_zzn,Dct_org] = Make_dct_ZZ(WdHost,Num_of_blks_row,Num_of_blks_clmn);
 Dct_zzn = round(Dct_zzn);
end

%Calc bit rate
if calc_bit_rate_f == 1,
 [bitrate]=Conv_for_bit_rate(Dct_zzn,Num_of_blks_row,Num_of_blks_clmn)
 bpp = bitrate/(size(Host,1)*size(Host,2))
end

%find zeros before and after
before=zeros(1,Num_of_blks_row*Num_of_blks_clmn);
after=zeros(1,Num_of_blks_row*Num_of_blks_clmn);

for i=1:Num_of_blks_row*Num_of_blks_clmn,
  before(i) = length(find(round(Dct_zz(:,i))==0));
  after(i) = length(find(Dct_zzn(:,i)==0));
end
hold off;
figure(3);plot(before(1:100),'-');
hold on;
figure(3);plot(after(1:100),'r:');
hold off;

zeros_before=sum(before)/(Num_of_blks_row*Num_of_blks_clmn)
zeros_after=sum(after)/(Num_of_blks_row*Num_of_blks_clmn)


%extract secr (from JPEG)
Ext =  mod(sum(abs(Dct_zzn),1),states);
cmp = Ext - Secret;
figure(2);stem(cmp);

if attack_pict_dom == 1 | attack_requant == 1,
 cmp(find(cmp~=0))=1;
 PROc = (length(cmp)-sum(cmp))/length(cmp)*100
 Recove_watrp(Ext,Num_of_blks_row,Num_of_blks_clmn,inbits);
end

%Restore to picture domain
WdHost = ReBuildHost(Dct_zzn,Num_of_blks_row,Num_of_blks_clmn);

%Watermarked Image show
figure(1);subplot(2,2,2);imshow(WdHost,[]);
if pict_sv  == 1,
 imwrite(WdHost/max(max(Host)),['wp_' num2str(Q_factor) '_' num2str(inbits) '_' num2str(Metods) '.bmp'],'bmp');
end

%picture diff
r = Host - WdHost;
r1 = abs(r);

[M,N]=size(r);
mse = sum(sum(r.^2))/(M*N);
PSNR = 10 *log10(255^2/mse)
figure(1);subplot(2,2,4);imshow(r1,[]);
title(['PSNR = ' num2str(PSNR)]);

%QVM
Mean_Dist=1000*mean(mean(r1));
Max_Dist=1000*max(max(r1));
VQM = Mean_Dist + 0.005*Max_Dist

