function WLPF(audioin,M,fc)
%MYFIR Custom FIR LPF to filter a given audio signal using the window
%method
%   audioin - signal to be filtered and returned
%   M - FIR filter order
%   fc - cutoff frequency in hertz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read in the audio signal
[sig, fs] = audioread(audioin);

if nargin ~= 3
    disp('Please provide all input arguments');
    return
elseif fc >= fs/2
    disp('Please provide a cutoff frequency within the nyquist criteria');
    return
else
%-----------------------------------------------------
n = 0:1:M; %elements equal to filter length

wh = 0.54 - 0.46*cos(2*n*pi/M); %Hamming window
FC = fc/fs;  %normalize cutoff frequency

LPFimp = 2*FC*sinc(2*FC*(n-(M/2)));  %IDEAL LPF impulse response - Shifts to one sided impulse response

%-----------------------------------------------------
LPFt_wh = LPFimp.*wh; %%Multiply in time domain to create a windowed LPF impulse response 
nlength = pow2(nextpow2(length(sig))); %Padding the signal length
X = fft(sig,nlength); %FFT of audio signal
LPF_WH1 = fft(LPFt_wh,nlength); %%FFT of LPF - length1 points
Xnew = X.*(LPF_WH1.'); %Apply LPF to audio signal
Xtime = ifft(Xnew); %Convert filtered signal back to time domain
%-----------------------------------------------------
%save the file
audiowrite('LPFaudio.wav',Xtime,fs);
end