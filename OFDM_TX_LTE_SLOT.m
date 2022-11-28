function sig = OFDM_TX_LTE_SLOT( Modulation_Order, num_carriers, num_empty_carriers, num_zeros, PrefixType )

% sig               - output signal
% sig_length        - output signal length
% Modulation_Order  - M-QAM with M = 4, 16, 64, 256
% num_carriers      - number of sub-carriers
% num_zeros         - number of zero carriers minus 1 (DC)
% prefix_length     - length of cyclic prefix
% num_symbols_slot  - number of OFDM symbols per LTE slot (0.5ms)

if ( strcmp(PrefixType, 'NORMAL') )
    NUM_OF_OFDM_SYMBOLS_PER_SLOT = 7;                 % Normal Prefix is assumed
    CP_SAMPLE_LENGTH = [160 144 144 144 144 144 144]; % Normal Prefix is assumed
    
elseif ( strcmp(PrefixType, 'EXTENDED') )
    NUM_OF_OFDM_SYMBOLS_PER_SLOT = 6;             % Extended Prefix is assumed
    CP_SAMPLE_LENGTH = [512 512 512 512 512 512]; % Extended Prefix is assumed
end

num_useful_carriers = num_carriers - (num_empty_carriers + num_zeros + 1);

sig = [];
for k = 1:NUM_OF_OFDM_SYMBOLS_PER_SLOT
     QAM_data = QAM_MOD( Modulation_Order, num_useful_carriers, num_empty_carriers);       
     temp_sig = OFDM_TX( num_carriers, num_zeros, CP_SAMPLE_LENGTH(k), QAM_data );
     sig = [sig temp_sig ];
end