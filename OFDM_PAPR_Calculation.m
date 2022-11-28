%........................................
%.......... PAPR Calculation ............
%........................................
function [result_PAPR, RMS_Value] = OFDM_PAPR_Calculation( data )

peak_value = max(data);
total_sum = 0;
for n=1:length(data)
    total_sum = abs(data(n))^2 + total_sum;
    %rms_value = norm(rx_signal)/sqrt(length(rx_signal));
end
rms_value = total_sum / length(data);
PAPR = 10*log10(abs(peak_value)^2/rms_value);
result_PAPR = PAPR;
RMS_Value = rms_value;
end
