function [B,A] = BiQuadLPF(fc,fs,q)
%BiQuadLPF - Returns the coefficients of a 2-stage LPF with Q-factor
%   fc = desired cutoff frequency (Hz), Fs = sampling rate, q = quality
%   factor *typical value range of 0.5(flat) - 5
% PC OURE 24-25
if nargin ~= 3
    error('Invalid number of input variables')
elseif fc >= fs/2 
    error('Nyquist criteria required, choose fc < Fs/2')
end
    
wc = 2*pi*fc/fs; % Get the desired cutoff freq
%-----------------------------------------
c = cos(wc);
s = sin(wc);
a = s/(2*q);
%-----------------------------------------
a1 = -2*c;   
a2 = 1 - a;
b0 = (1-c)/2;
b1 = 1-c;
b2 = (1-c)/2;
%Normalizing factor-----------------------
div = 1/(1+a);   
%-----------------------------------------
A = [1, a1*div, a2*div]; % return coefficients
B = [b0*div, b1*div, b2*div];
end

