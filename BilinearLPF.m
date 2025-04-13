function [Num,Den] = BilinearLPF(fc,fs,N)
% PC OURE 24-25
if nargin ~= 3
    disp('Please provide all input arguments');
    return
elseif fc >= fs/2
    disp('Please provide a cutoff frequency within the nyquist criteria');
    return
elseif N < 1 || N > 20
    disp('Filter order N range 1 to 20')
else

j = 1i; %j because EE 
M = 1:N; 
polesS = zeros(1,N);
polesZ = zeros(1,N);
zerosZ = zeros(1,N);
Den = zeros(1,N+1);
Num = zeros(1,N+1);
%-----------------------------------------------------
phi = (2*M - 1) * pi/(2*N); %Pole mapping in S-Domain
polesS = -sin(phi) + j*cos(phi);  %Map poles
Fc = fs/pi * tan(pi*fc/fs);  %pre-warped fc
polesS = polesS * 2 * pi * Fc; %scaled poles to meet Fc
%-----------------------------------------------------
polesZ = (1 + polesS/(2*fs)) ./ (1 - polesS/(2*fs));  %bilinear transform mapping to Z-Domain
zerosZ = -ones(1,N);  %zeros to be added from +/-inf to unit circle
Den = poly(polesZ);  %converting the pole locations to polynomials with coefficients
Den = real(Den); %Real values only
Num = poly(zerosZ); %numerator polynomial 
Kgain = sum(Den)/sum(Num); %Normalize 
Num = Kgain*Num;   %scale gain factor for 0 dB at passband

end