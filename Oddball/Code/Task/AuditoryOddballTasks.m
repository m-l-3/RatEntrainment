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
%% Initial Sound setting
InitializePsychSound(1);

% set the random seed
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

% Setup sounds
echant=8000; duree=0.2;

freq=440;
Tone(1,:)=sin(2*pi*freq*[1/echant:1/echant:duree]);

freq=660;
Tone(2,:)=sin(2*pi*freq*[1/echant:1/echant:duree]);

%freq=300;
%Tone(3,:)=sin(2*pi*freq*[1/echant:1/echant:duree]);
%%

RestTime = 2;
nTrial = 240;

% Set the serial port to connect to the Odor Set
% serial_port = "COM6";
% bioarma =  serial(serial_port,'BaudRate',9600);
% serial_port = "COM1";

pause(3)

%%
% ncount = 1;

MEGA = zeros(nTrial,1);
% MEGA = [1,1,0,1,1,0,1,0];
for seti=1:1  % 100 trials per set - - 200 total
%     tonejitters=repmat(Shuffle(.5:.005:1),1,2);
    
%     MEGA=zeros(3,1);
%     for shuffi=1:2
%         tonetypes=Shuffle([{A},{B},{C},{D},{E},{F},{G},{H},{I},{J},{K}]);
%         MEGA=[MEGA,tonetypes{1},tonetypes{2},tonetypes{3},tonetypes{4},tonetypes{5},tonetypes{6},tonetypes{7},...
%             tonetypes{8},tonetypes{9},tonetypes{10},tonetypes{11}];
%         clear tonetypes;
%     end
    for i=1:length(MEGA) 
        r = unifrnd(0,1);
        if r<0.2
           MEGA(i) = 0; 
        else
           MEGA(i) = 1;     
        end
        
    end    
     
    % To get to a nice 100 trials with 15 Novels and 15 Oddballs
%     MEGA=[MEGA,L];
    
    pahandle0  = PsychPortAudio('Open',[],[],0, echant, 1);
    buhandle0 = PsychPortAudio('CreateBuffer', pahandle0 , Tone(2,:));
    pahandle1  = PsychPortAudio('Open',[],[],0, echant, 1);
    buhandle1 = PsychPortAudio('CreateBuffer', pahandle1 , Tone(1,:));
    pahandles=[pahandle0,pahandle1,%pahandle2];
        ];    
    buhandles=[buhandle0,buhandle1,%buhandle2];
        ];

    for ai=1:length(MEGA)
%         pahandle2 = PsychPortAudio('Open',[],[],0, IADS_frex{ncount}, 1);
%         buhandle2 = PsychPortAudio('CreateBuffer', pahandle2 , IADS_sound{ncount}');

        % -------------
        PsychPortAudio('FillBuffer', pahandles(MEGA(ai)+1) , buhandles(MEGA(ai)+1));
        %Tag
        write(ni, decimalToBinaryVector((MEGA(ai)+1)*10, 8, 'LSBFirst'));
        PsychPortAudio('Start', pahandles(MEGA(ai)+1) , 1, 0, 1);
      
        write(ni, decimalToBinaryVector(0, 8, 'LSBFirst'));
        WaitSecs(RestTime);
        
        LOG(seti,ai)=MEGA(ai);
        
    end

        
end

 
save([datestr(now, 'mm-dd-yyyy_HH-MM-SS'),'.mat']','LOG');


close all;

ListenChar(0);
