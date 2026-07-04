function [ru,rd,ruA,rdA] = Generate_Criteria(x,ix,Dct_org)

 set_params;

 %Generate functions nearest to 0.5 q
  ru=(0.5-x+ix);
  rd=(x-0.5+(1-ix));
   
 %Insert Inf if ru or rd >= 0.5
  ru(find(ru>=0.5)) = Float_big;
  rd(find(rd>=0.5)) = Float_big;
  
  
  %Reference to amplitude
  Amp_dct = abs(Dct_org);
  Amp_dct(find(Amp_dct==0)) = 1e-10;
  
  ruA = ru./Amp_dct;
  rdA = rd./Amp_dct;
  
  
  %Position
  fr_id_cut = 0;%1
  
  filt = [ones(1,fr_id_cut)*Float_big ones(1,size(ru,1)-fr_id_cut)]';
  filtm = filt*ones(1,size(ru,2));
  
  ruA = ruA.*filtm;
  rdA = rdA.*filtm;