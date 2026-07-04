function [Dct_zzn_rest] = Attack_DCT(Dct_zzn);

set_params;

Qzz = Q(ZZ)';

Qzz_Matr = Qzz*ones(1,size(Dct_zzn,2));

%dequatization
Dct_zzn_unq = Dct_zzn.*Qzz_Matr;


%requatization
q = 0.2;%1/17; %another quality factor
Qn = round(Q_orig* q)+1;

Qnz = Qn(ZZ)';
Qnz_Matr = Qnz*ones(1,size(Dct_zzn,2));

Dct_zzn_att = round(Dct_zzn_unq./Qnz_Matr);


%restore with previos quanta
Dct_zzn_unq_rest =  Dct_zzn_att.* Qnz_Matr;

Dct_zzn_rest = round(Dct_zzn_unq_rest./Qzz_Matr);


