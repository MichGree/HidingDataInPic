% for Q_factor=1/10 & Lenna -> PSNR for 0.5 + Amp criteria is better
% than only 0.5 criteria

% for Q=1/2 & Baboon (4 bits) ~ 0.4 db better Amp crit than 0.5 crit

%--------- Max float number ---------
Float_big = 1e32;

%--------- Block zize 8x8,16x16,etc ---------
Blk_size     = 8;

%--------- Quatization parameters---------
Q = [16 11 10 16 24  40  51  61;
     12 12 14 19 26  58  60  55;
     14 13 16 24 40  57  69  56;
     14 17 22 29 51  87  80  62;
     18 22 37 56 68  109 103 77;
     24 35 55 64 81  104 113 92;
     49 64 78 87 103 121 120 101;
     72 92 95 98 112 100 103 99;];
  
 Q_orig = Q; 
 
  % Set step factor s =1/q 
  Q_factor = 0.24;%0.5;%3*0.67;%0.5;%0.2;%0.1; 1/5, 1/10, 1/20, 1/40, 1/60, 1/80
  
  %Q = round(Q* Q_factor)+1;
  Q = round(Q* Q_factor);

 %---------Zig zag order ---------
ZZ = [1 9 2 3 10 17 25 18 11 4 5 12 19 26 33 41 ...  
      34 27 20 13 6 7 14 21 28 35 42 49 57 50 43 ...
      36 29 22 15 8 16 23 30 37 44 51 58 59 52 45 38 ...
      31 24 32 39 46 53 60 61 54 47 40 48 55 62 63 56 64];   
  
%Payload factor for Adaptive Emb
if Q_factor < 0.25
  payload_factor = 1;
elseif Q_factor >= 0.25 & Q_factor < 1.4
    payload_factor = 2;
else
    payload_factor = 4;
end

%Metods: JPEG(no embed)=0; Half_way=1;My=2;
Metods=2;

%Save watwemarked pictures =1; not save=0
pict_sv=0;

%attack flags
attack_requant = 0;
attack_pict_dom = 0;

%calculate bit rate flag
calc_bit_rate_f = 0;

%calculate mean & energy flag
mean_energ_f = 0;