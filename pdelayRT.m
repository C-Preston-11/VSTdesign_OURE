function [y, buffer1, buffer2, index1, index2] = pdelayRT(x, fs, d, g, width, pan, mix, buffer1, buffer2, index1, index2)
%pdelayRT Function designed specifically for RT audio processing. Ping-Pong
%delay with a frame size of 1024. PC OURE 24-25
%   x - input signal
%   fs - sampling rate
%   d - delay in ms
%   g - feedback gain 0 - 1
%   width - stereo width 0 - 1
%   pan - stereo panning -100 - +100
%   mix - wet/dry mix 0 - 1
%   buffer1 & 2 - buffers for storing delays
%   index1 & 2 - index of buffers
if size(x,2) > 1
    x = mean(x,2); % convert to mono
end
    sampleD = fix(d / 1000 * fs); %delay in samples

    % panning using square law *smoother transitions - equal power
    pann = (pan / 200) + 0.5; % normalize
    leftA = sqrt(1 - pann);  
    rightA = sqrt(pann);     
   
    y = zeros(size(x, 1), 2); %preallocate

    % MAIN LOOP
    for n = 1:size(x, 1)
        %delayed samples
        delayed1 = buffer1(index1);
        delayed2 = buffer2(index2);

        %stereo width
        widthLeft = (1-width) * delayed1 + width * delayed2;
        widthRight = (1-width) * delayed2 + width * delayed1;

       %compute width + panning
        wetLeft = widthLeft * leftA;
        wetRight = widthRight * rightA;

        %wet-dry mix
        y(n,1) = x(n,1) * (1-mix) + wetLeft * mix;
        y(n,2) = x(n,1) * (1-mix) + wetRight * mix;

        %cross-channel feedback 
        buffer1(index1) = x(n,1) + g * widthRight;
        buffer2(index2) = x(n,1) + g * widthLeft;

        %update circular buffers
        index1 = mod(index1, sampleD) + 1;
        index2 = mod(index2, sampleD) + 1;
    end
end