
clc
clear all 

close all


devs = daqlist;
if isempty(devs)
    fprintf(fid, "Failed!\n");
    fprintf(fid, "\t*Finishsed: %s\n", datestr(datetime('now'), "HH:MM:SS"));
    fclose(fid);
    error("Could not find the NI DAQ")
end
ni = daq('ni');
warning off
addoutput(ni, 'Dev1', 'Port0/Line0:7', 'Digital');
warning on
clear ans devs
write(ni, decimalToBinaryVector(255, 8, 'LSBFirst'));
WaitSecs(1)
write(ni, decimalToBinaryVector(0, 8, 'LSBFirst'));
WaitSecs(1)


%% Visual


[w, wRect]=Screen('OpenWindow', 1);
freq = 40;
time_block = 3600; % or 3
num_trial = 1; % or 120
for i=1:num_trial
%     write(ni, decimalToBinaryVector(132, 8, 'LSBFirst'));
    
%       flicker_square(w, wRect,freq,time_block, ni, player)
      flicker_sine(w, wRect,freq,time_block, ni)
%     flicker_sham(w, wRect,time_block, ni)
    
%     write(ni, decimalToBinaryVector(0, 8, 'LSBFirst'));
end
Screen('CloseAll');


