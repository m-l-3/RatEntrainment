
addpath(genpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1"))

%%
clc
close all
clear

L = 10;
Fs = 1000;
t = linspace(0,L,Fs*L);



fc = 23;
fn1 = 50;
fn2 = 10;
w = 0.75;
order = 4;

sig = cos(2*pi*fc*t+3/4*pi).*cos(2*pi*2*t);
sig = sig.*ecg(L*Fs);
sig_noise = sig + randn(size(t)) + sin(2*pi*fn1*t+pi/8).*cos(2*pi*3*t) + sin(2*pi*fn2*t+5*pi/6);

[b,a] = butter(order,[(fc-w/2)/(Fs/2) (fc+w/2)/(Fs/2)],'bandpass');
sig_fil = filter(b,a,sig_noise);
sig_fil2 = filtfilt(b, a, sig_noise);


figure(1)
ax1 = subplot(2,1,1);
plot(t,sig_noise,'DisplayName','signal')
subplot(2,1,2)
plot(t,sig./max(sig),'DisplayName','signal')
hold on
plot(t,sig_fil./max(sig_fil),'DisplayName','butter filter')
plot(t,sig_fil2./max(sig_fil2),'DisplayName','butter filtfilt')
legend()
xlabel('Time (sec)')

EEG.data = sig_noise;
EEG.nbchan = 1;
EEG.srate = Fs;
EEG.trials = 1;
EEG.event = [];
EEG.pnts = L*Fs;

[EEG, com, b] = pop_eegfiltnew(EEG, 'locutoff', (fc-w/2), 'hicutoff', (fc+w/2), 'plotfreqz', 1);
figure(1)
ax2 = subplot(2,1,2);
plot(t,EEG.data./max(EEG.data),'DisplayName','EEGLAB fir filternew')

linkaxes([ax1,ax2],'x')


%%
function x = ecg(L)
%ECG Electrocardiogram (ECG) signal generator.
%   ECG(L) generates a piecewise linear ECG signal of length L.
%
%   EXAMPLE:
%   x = ecg(500).';
%   y = sgolayfilt(x,0,3); % Typical values are: d=0 and F=3,5,9, etc. 
%   y5 = sgolayfilt(x,0,5); 
%   y15 = sgolayfilt(x,0,15); 
%   plot(1:length(x),[x y y5 y15]);

%   Copyright 1988-2002 The MathWorks, Inc.

a0 = [0,1,40,1,0,-34,118,-99,0,2,21,2,0,0,0]; % Template
a0 = [a0, a0*1.5];
d0 = [0,27,59,91,131,141,163,185,195,275,307,339,357,390,440];
d0 = [d0, d0+(d0(end))];
a = a0/max(a0);
d = round(d0*L/d0(30)); % Scale them to fit in length L
d(30)=L;

for i=1:29
       m = d(i):d(i+1)-1;
       slope = (a(i+1)-a(i))/(d(i+1)-d(i));
       x(m+1) = a(i)+slope*(m-d(i));
end

end