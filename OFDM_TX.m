function [sig, sig_length] = OFDM_TX( num_carriers, num_zeros, prefix_length, input )

% OFDM Transmitter - DC removed
% sig         is the output signal
% sig_length  is the length of the output signal
%
% num_carriers  - number of sub-carriers (power of 2)
% num_zeros     - number of zeros minus 1 (DC) in output spectrum (odd)
% prefix_length - length of cyclic prefix
% input         - input dimensions (length = number_carriers - num_zeros - 1)

if (length(input) + num_zeros + 1 ~= num_carriers)
     fprintf('error in lengths\n');
     return;
 end

ext_input = [0 input(1:length(input)/2).' zeros(1,num_zeros) input((1+length(input)/2):length(input)).'];
output_1 = ifft(ext_input);  % time domain signal with 'Ts = 1/Fs' interval
sig = [output_1((num_carriers - prefix_length + 1) : num_carriers) output_1];  % cyclic prefix is added;
sig_length = length(sig);
