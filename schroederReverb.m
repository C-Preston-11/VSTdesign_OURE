function [out,combBuffers,allpassBuffers] = schroederReverb(x, fs, rt60)
% SCHROEDERREVERB Implementation of a simple Schroeder reverberator
% in   - input audio signal (mono)
% fs   - sample rate
% rt60 - desired reverb time
% out  - processed output
if size(x,2) > 1
    x = mean(x,2); %convert to mono
end
numCombFilters = 4;       %number of parallel comb filters
numAllPassFilters = 2;        %number of all-pass filters in series
% delay in samples
% using prime numbers helps reduce resonances
combDelays = [1557, 1617, 1491, 1422];  % set delay for comb filters
allpassDelays = [225, 556];             % set delay for allpass filters

%comb filter gains based on rt60
combGains = zeros(1, numCombFilters);
for i = 1:numCombFilters
    combGains(i) = 10^(-3 * combDelays(i) / (rt60 * fs)); 
end
%allpass gain
allpassGain = 0.7;  
%comb filter delay lines
combBuffers = cell(1, numCombFilters);
for i = 1:numCombFilters
    combBuffers{i} = zeros(combDelays(i), 1);
end

%init allpass delay lines
allpassBuffers = cell(1, numAllPassFilters);
for i = 1:numAllPassFilters
    allpassBuffers{i} = zeros(allpassDelays(i), 1);
end
%(dry/wet)
dryMix = 0.7;
wetMix = 0.5;
%preallocate
out = zeros(length(x),2);
%MAIN LOOP
for n = 1:length(x)
    combOut = 0;
    for i = 1:numCombFilters
        %REAd delay line
        delayedSample = combBuffers{i}(end);
        %output
        filterOut = delayedSample * combGains(i);      
        %update delay
        combBuffers{i} = [x(n) + filterOut; combBuffers{i}(1:end-1)];
        combOut = combOut + filterOut;
    end

    combOut = combOut / numCombFilters;
    
    %series allpass
    allpassOut = combOut;
    for i = 1:numAllPassFilters
        %read delay
        delayedSample = allpassBuffers{i}(end);
        
        filterIn = allpassOut;
        filterOut = delayedSample - allpassGain * filterIn;
        
        %update delay
        allpassBuffers{i} = [filterIn + allpassGain * filterOut; allpassBuffers{i}(1:end-1)];
        
        %series allpass
        allpassOut = filterOut;
    end
    out(n,:) = [dryMix * x(n) + wetMix * allpassOut,dryMix * x(n) + wetMix * allpassOut];
end
% Normalize output to avoid clipping
maxAmp = max(abs(out));
if maxAmp > 0.99
    out = out / maxAmp * 0.99;
end





%[appendix]
%---
%[metadata:styles]
%   data: {"code":{"fontFamily":"Courier New"},"heading1":{"fontFamily":"Monospaced"},"heading2":{"fontFamily":"Monospaced"},"heading3":{"fontFamily":"Monospaced"},"normal":{"fontFamily":"Monospaced"},"title":{"fontFamily":"Monospaced"}}
%---
