function bitrate=bit_rate(imQDCT)
% Bit-rate calculation routine
% Usage: bitrate=bit_rate(imQDCT)
% imQDCT image after DCT and Quantization
% bitrate: corresponding bit-rate (aclenght + dclenght)
% nonzerocoeff: number of non-zero coefficients (should be uncomments)
% copyright(c) 2003 by Evgeny Kaminsky

zigzag_ord = [1 9 2 3 10 17 25 18 11 4 5 12 19 26 33 41 34 27 20 13 6 7 14 21 28 35 42 49 57 50 43 36 29 22 15 8 16 23 30 ...
        37 44 51 58 59 52 45 38 31 24 32 39 46 53 60 61 54 47 40 48 55 62 63 56 64];
% --- Extract DC+AC coeff ---
dc = imQDCT(1:8:end,1:8:end);
acseq = [];
acmat = im2col(imQDCT,[8 8], 'distinct');
dcseq = [dc(1) dc(2:end)-dc(1:end-1)];

% --- DC Huffman codes length ---
dclength = 0;
for n = 1:length(dcseq)
    dclength = dclength + length(jdcenc(dcseq(n)));
end

% --- AC Huffman codes length ---
aclength = 0;
%nonzerocoeff = 0; % check non-zero coeff
for n = 1:length(acmat)
    eob = max(find(acmat(zigzag_ord, n)));
    if isempty(eob)
        eob = 0;
    elseif (eob == 1) | (eob == 0)
        aclength = aclength + length(jacenc(999));
    else
        aclength = aclength + length(jacenc([acmat(zigzag_ord(2:eob), n)' 999]));
    end
    %nonzerocoeff = nonzerocoeff + eob; %non zero coefficient calculation
end

bitrate = aclength + dclength;
%zeroper = (1 - nonzerocoeff/N)*100;