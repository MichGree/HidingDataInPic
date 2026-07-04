function [WdHost_Alt] = Attack_pict(WdHost)


%Rand noise
Amp = 2.5;
Noise = round(rand(size(WdHost))*Amp*2)-Amp;

%add noise
%WdHost_Alt = WdHost + Noise;


%Low pass filter
k2 = ones(2)/4;
WdHost_Alt = conv2(WdHost,k2,'same');
