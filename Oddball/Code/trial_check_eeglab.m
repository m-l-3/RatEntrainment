clc; clear; close all;

addpath('./Functions')
addpath('./Functions/Visualization')

%%

clc;
rat_no = '9';
block_no = '1';
date = '1403-03-31';

save_path = '../Results/Ch-Spect/';

[data, fs] = load_data(rat_no, block_no, date, '0');
triggers_pulse = diff(data.digitalByte); 
sig = [data.channelData'; double(data.digitalByte)'];


%% Load EEGLAB
eeglab;
EEG.etc.eeglabvers = '2023.0'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = pop_importdata('dataformat','array','nbchan',0,'data','sig','setname','raw','srate',fs,'pnts',0,'xmin',0);
EEG = pop_chanevent(EEG, 5,'edge','leading','edgelen',0);

figure('WindowState', 'maximized');
[spectra, freqs] = spectopo(EEG.data, 0, EEG.srate, 'plot', 'on');
fig_title = strcat('Data-Rat', rat_no, '-Block', block_no, '-', date);
title(fig_title)
save_fig(save_path, fig_title)
close gcf

EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',300,'plotfreqz',1);
EEG.setname='raw-bpfilt';
event_vals = unique(data.digitalByte);
event_vals(event_vals == 0 | event_vals == 255| event_vals == 8| event_vals == 16) = [];
EEG = pop_epoch( EEG, num2cell(event_vals)', [-0.3           1], 'newname', 'raw-bpfilt-epochs', 'epochinfo', 'yes');
pop_eegplot( EEG, 1, 1, 1);
eeglab redraw