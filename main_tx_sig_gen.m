%................................................................................................................
% Erhan YILMAZ - STIIM 12.03.2021
%................................................................................................................
%................................................................................................................
%...................................... LTE FRAME Configuration Parameters ......................................
% Fs = 30.72 MHz
% Normal Cyclic Prefix is assumes
% Subcarrier spacing = 15KHz
% FFT_SIZE = 2048
% Channel BW = 20 MHZ
% Occupied BW = 18MHz
% # of Resource Blocks = 100  (1 RB = 12 sub-carriers (= 180kHz spectrum with 15kHz spacing) and a single LTE time slot of duration 0.5ms )
% # of Non-Zero Subcarriers = 1200
%................................................................................................................
clc;
clear all;
close all;

Fs = 30720000/2; % Sampling rate: 30.72MHz (20MHz), 15.36MHz (10MHz), 7.68MHz (5MHz), 3.84MHz (3MHz), 1.92MHz (1.4MHz)
Ts = 1 / Fs;     % Sampling period: 1/30.72MHz = 66,7us

FFT_SIZE                 = 1024; % 2048(20MHz); 1024(10MHz); 512(5MHz); 256(3MHz); 128 (1.4MHz)
NUM_OF_CARRIERS          = FFT_SIZE;
NUM_OF_NONZERO_CARRIERS  = 600; %600; %1200; %
NUM_OF_ZERO_CARRIERS     = NUM_OF_CARRIERS - (NUM_OF_NONZERO_CARRIERS + 1);  % DC carrier is NOT added
PrefixType               = 'NORMAL'; % 'NORMAL', 'EXTENDED'
ModulationOrder          = 64;       % M-QAM modulation

NUM_OF_FRAMES             = 1;   % Number of LTE Frames to generate
NUM_OF_SUBFRAME_PER_FRAME = 10;  % 10 SubFrame/Frame
NUM_OF_SLOTS_PER_SUBFRAME = 2;   % 2 Slot/SubFrame
NUM_OF_SLOTS_PER_FRAME    = NUM_OF_SUBFRAME_PER_FRAME * NUM_OF_SLOTS_PER_SUBFRAME;  % 10 SubFrame/Frame * 2 Slot/SubFrame = 20 Slot/Frame

%num_empty_useful_carriers_array = floor(NUM_OF_NONZERO_CARRIERS * (0.8 * rand(1, NUM_OF_FRAMES)));
num_empty_useful_carriers_array = 0;
sizeArr = length(num_empty_useful_carriers_array);

%.......................... Transmit Baseband ...............................
sig = [];
for frame=1:NUM_OF_FRAMES
    num_empty_carriers = num_empty_useful_carriers_array(mod(frame-1, sizeArr)+1);
    for slot=1:NUM_OF_SLOTS_PER_FRAME
        temp_sig = OFDM_TX_LTE_SLOT( ModulationOrder, NUM_OF_CARRIERS, num_empty_carriers, NUM_OF_ZERO_CARRIERS, PrefixType );
        sig = [sig temp_sig];
    end
end

% PAPR Calculation
[result_PAPR, RMS_Value] = OFDM_PAPR_Calculation( sig );
10*log10(RMS_Value)

%............................................................................





% Plot
figure;
t = 1000*Ts*(0:(length(sig)-1));
plot(t, abs(sig(:)));
title(sprintf('Time Domain Tx Frames'));
xlabel(' time (ms) ');
ylabel(' |x(nTs)| ');

%---------------------------------------------------
% Double-Sided Amplitude Spectrum of OFDM Signal
%---------------------------------------------------
N = length(sig);
f = Fs * (-N/2+1:N/2) / N;
X = fftshift(fft(sig));
Y = abs(X)/N;
Y_dB = 20*log10(Y/max(Y)); % normalize

% Plot
figure;
plot (f, Y_dB);
title('Double-Sided Amplitude Spectrum of OFDM Signal tx_frame' );
xlabel(' f (Hz) ');
ylabel(' |X(f)| ');
axis([-Fs/2 Fs/2  -100 5]);


%................................. Channel ..................................


%.......................... Receiver Baseband ...............................











