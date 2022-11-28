function [sig, sig_length] = QAM_MOD( Modulation_Order, QAMSymbolSize, ZeroSymbolSize )

% sig               - output M-QAM modulated symbols
% Modulation_Order  - modulation size, M (4, 16, 64, 256)
% QAMSymbolSize     - M-QAM modulated symbol size to be generated
% ZeroSymbolSize    - zero symbols (no modulation, etc)

%clc;
%close all;
%Modulation_Order = 64;
%QAMSymbolSize = 200;


% Visualize the constellation for M-QAM modulation, with gray mapping, bit input and constellation scaled to average power of 1.
x = randi([0, 1], QAMSymbolSize*log2(Modulation_Order), 1);
x_mod = qammod(x, Modulation_Order);
%x_mod = qammod(x, Modulation_Order, 'InputType', 'bit', 'UnitAveragePower', true);
%x_mod = qammod(x, Modulation_Order, 'InputType', 'bit', 'UnitAveragePower', true, 'PlotConstellation', true);
%scatterplot(x_mod);

sig = [x_mod; zeros(ZeroSymbolSize, 1)];
sig = sig( randperm( QAMSymbolSize + ZeroSymbolSize ) );

sig_length = length(sig);


