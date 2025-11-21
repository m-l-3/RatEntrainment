function a = flicker_sine(w, wRect, Hz, MaxTime, ni)
 %Set Hz for stimulus flicker
Screen('Flip',w);
Frametime=Screen('GetFlipInterval',w); %Find refresh rate in seconds

FramesPerFull = round(MaxTime/Frametime); % Number of frames for all stimuli
%FramesPerStim = round((1/Hz)/Frametime); %Number of frames for each stimulus

time = 0:Frametime:MaxTime;
% StartT = GetSecs; %Measure start time of session
Framecounter = 0; %Frame counter begins at 0
% my_counter = 0;

write(ni, decimalToBinaryVector(128, 8, 'LSBFirst'));
% sound(y,Fs)
% play(player)
a = [];
while 1

    if Framecounter==FramesPerFull
        break; %End session
    end
    
    
    % sinusidal stim

    est_time = time(Framecounter + 1);
    randomcolour = 255 * (sin(2*Hz*pi*est_time)+1)/2;

    a = [a, randomcolour];
    Screen('FillRect', w, randomcolour, wRect);
    Screen('Flip',w);

    Framecounter = Framecounter + 1; %Increase frame counter
end
% stop(player)

Framecounter = 0; %Frame counter begins at 0
write(ni, decimalToBinaryVector(0, 8, 'LSBFirst'));
while 1

    if Framecounter==FramesPerFull
        break; %End session
    end

    Screen('FillRect', w, 0, wRect);
    Screen('Flip',w);

    Framecounter = Framecounter + 1; %Increase frame counter
end
end

