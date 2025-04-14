Custom Audio Effect Plugins in MATLAB

An OURE Research Project
Project Overview

Research Paper --> [Research paper link](https://www.researchgate.net/publication/390740582_Developing_Custom_MATLAB_Functions_for_Real-Time_Audio_Effects_Processing)

Some demonstrations --> [MATLAB VST Effects on Hackaday](https://hackaday.io/project/202844-matlab-vst-effects). 

This repository contains MATLAB-based audio effect plugins designed for digital signal processing (DSP) research. The project focuses on:

    Designing effects for real-time processing.

    Exploring psychoacoustic principles for creative sound manipulation.

    Optimizing real-time performance for potential integration with DAWs (e.g., via VST or Audio Toolbox).

Features

Core Effects:

    Variable order FIR LPF (window method)
    
    Variable order IIR LPF

    Variable resonance IIR LPF (second-order)

    Ping-Pong Delay 

    Reverberator (Schroeder algorithm)

Tools:

    GUI-based parameter tuning

    Spectral analysis (FFT, spectrograms)

    Real-time audio I/O (using audioDeviceReader/audioDeviceWriter)

