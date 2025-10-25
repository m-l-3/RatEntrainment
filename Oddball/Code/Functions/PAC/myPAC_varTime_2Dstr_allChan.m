function [PAC,tout,fph,famp,trialvec,tfd_all] = myPAC_varTime_2Dstr_allChan(EEG,fph,famp,twin,tovp,ttype,method,fres_param,nbins,nperm)

if ~exist('method','var') || isempty(method)
    method = "wavelet";
end

if ~exist('nperm','var') || isempty(nperm)
    nperm = 0;
end

if ~exist('nbins','var') || isempty(nbins)
    nbins = 3;
end

if ~exist('fres_param','var') || isempty(fres_param)
    switch lower(string(method))
        case "wavelet"
            fres_param = 10;
        case "rid-rihaczek"
            fres_param = 1;
        otherwise
            error('Unknown method!')
    end
end


data = EEG.data;
data = zscore(data,[],2);
t = EEG.times;
Fs = EEG.srate;
nch = size(data,1);
ntr = size(data,3);
L = length(t);
switch method
    case 'wavelet'
        fb = cwtfilterbank('Wavelet','amor','SignalLength',length(t),'FrequencyLimits',[0,max(famp)],'SamplingFrequency',Fs,'VoicesPerOctave',fres_param);
        
        [~,ff,cod] = cwt(data(1,:,1),FilterBank=fb);

        % Trimming the start and end of the window
        idx_start = find(cod < fph(1),1,'first');
        idx_end = length(t) - idx_start + 1;
        t = t(idx_start:idx_end);
        L = length(t);

        t_idx = buffer(1:L,round(twin*Fs),round(twin*Fs*tovp))';
        [r,~] = find(t_idx==0);
        t_idx(r,:) = [];
        [L,Lwin] = size(t_idx);

        if ~exist('ttype','var') || isempty(ttype)
            tout = t(t_idx(:,ceil(Lwin/2)));
        else
            switch ttype
                case "center"
                    tout = t(t_idx(:,ceil(Lwin/2)));
                case "first"
                    tout = t(t_idx(:,1));
                case "last"
                    tout = t(t_idx(:,end));
                otherwise
                    error('Unknown ttype')
            end
        end

        fph = ff(ff>=fph(1) & ff<=fph(end));
        famp = ff(ff>=famp(1) & ff<=famp(end));
        Lfp = length(fph);
        Lfa = length(famp);

        tfd_all = cell(nch,ntr);
        for tr = 1:ntr
            for ch = 1:nch
                % Getting t-f distribution
                if(all(isnan(data(ch,:,tr))))
                    tfd_all{ch,tr} = NaN(length(ff),length(t));
                else
                    tfd_all{ch,tr} = cwt(data(ch,:,tr),FilterBank=fb);
                    tfd_all{ch,tr} = tfd_all{ch,tr}(:,idx_start:idx_end);
                end

            end
        end

        PAC = NaN(nch,nch,L,Lfp,Lfa,ntr);
        for tr = 1:ntr
            for ch1 = 3%1:nch
                for ch2 = 3%1:nch
                    if(all(isnan(tfd_all{ch1,tr}),'all') || all(isnan(tfd_all{ch2,tr}),'all'))
                        continue;
                    end

                    Phase_allwin = angle(tfd_all{ch1,tr}(ismember(ff,fph),:));
                    Amp_allwin = abs(tfd_all{ch2,tr}(ismember(ff,famp),:));

                    % Reshape to be used in parfor
                    Phase_temp = zeros(size(Phase_allwin,1),length(tout),size(t_idx,2));
                    Amp_temp = zeros(size(Amp_allwin,1),length(tout),size(t_idx,2));
                    for ti = 1:length(tout)
                        Phase_temp(:,ti,:) = Phase_allwin(:,t_idx(ti,:));
                        Amp_temp(:,ti,:) = Amp_allwin(:,t_idx(ti,:));
                    end

                    parfor ti = 1:L
                        disp(['trial: ',num2str(tr),'/',num2str(ntr),' | channels: [',num2str([ch1,ch2]),'] | ',num2str(ti/L*100),'%'])
                       
                        % Finding PAC at each window
                        PAC(ch1,ch2,ti,:,:,tr) = myPAC_MI(squeeze(Phase_temp(:,ti,:)), squeeze(Amp_temp(:,ti,:)), nbins, nperm);
                    end
                end
            end
        end

    case 'rid-rihaczek'

        fph = fph(1):fres_param:fph(2);
        famp = famp(1):fres_param:famp(2);
        Lfp = length(fph);
        Lfa = length(famp);

        t_idx = buffer(1:L,round(twin*Fs),round(twin*Fs*tovp))';
        [r,~] = find(t_idx==0);
        t_idx(r,:) = [];
        [L, Lwin] = size(t_idx);
        
        if ~exist('ttype','var') || isempty(ttype)
            tout = t(t_idx(:,ceil(Lwin/2)));
        else
            switch ttype
                case "center"
                    tout = t(t_idx(:,ceil(Lwin/2)));
                case "first"
                    tout = t(t_idx(:,1));
                case "last"
                    tout = t(t_idx(:,end));
                otherwise
                    error('Unknown ttype')
            end
        end
        
        data_buff = cell(ntr,nch);
        for tr = 1:ntr
            for ch = 1:nch
               data_buff_temp = buffer(data(ch,:,tr),round(twin*Fs),round(twin*Fs*tovp))';
               [r,~] = find(data_buff_temp==0);
               data_buff_temp(r,:) = [];
               data_buff{tr,ch} = data_buff_temp;
            end
        end
        clear data_buff_temp
        
        PAC = zeros(nch,nch,L,Lfp,Lfa,ntr);
        for tr = 1:ntr
            for ch1 = 1:nch
                for ch2 = 1:nch
                    data_buff_ch1 = data_buff{tr,ch1};
                    data_buff_ch2 = data_buff{tr,ch2};
                    parfor ti = 1:L
                        disp(['trial: ',num2str(tr),'/',num2str(ntr),' | channels: [',num2str([ch1,ch2]),'] | ',num2str(ti/L*100),'%'])
                        
                        tfd_str1 = nf_ridrihaczek(squeeze(data_buff_ch1(ti,:)),Fs,1,0.001,1);
                        if ch1 == ch2
                            tfd_str2 = tfd_str1;
                        else
                            tfd_str2 = nf_ridrihaczek(squeeze(data_buff_ch2(ti,:)),Fs,1,0.001);
                        end
                        ff = tfd_str1.freqs;
                        Phase = tfd_str1.phase(ismember(ff,fph),:);
                        Amp = tfd_str2.power(ismember(ff,famp),:);
                        
                        PAC(ch1,ch2,ti,:,:,tr) = myPAC_MI(Phase,Amp,nbins);
                    end
                end
            end
        end
        tfd_all = [];

    otherwise
        error('Unknown method!')

end

trialvec = 1:size(PAC,6);



%% OLD CODE

% function [MVL,t_int_out] = myPAC_varTime_2Dstr_allChan(EEG,fph,famp,twin,tovp,winovp_type,ffixed,ttype)
% % [MVL,t_int_out] = myPAC_varTime_2Dstr_allChan(EEG,fph,famp,twin,tovp,winovp_type,ffixed,ttype)
% % 
% % This function calculates the dynamic Phase-Amplitude coupling by the
% % sliding windows with specific overlap between windows. It uses tf-MVL [1]
% % method between ALL channels in each trial of an EEG or LFP signal. The 
% % tf decomposition would be calculated by RID-Rihaczek [1] Method.
% %
% % Inputs:
% % - <EEG> : EEG struct data format in the EEGLAB
% %
% % - <fph> : The interval of lower frequency (in Hz) that the phase is 
% %   going to be extracted from. e.g. [4,8]
% %
% % - <famp> : The interval of higher frequency (in Hz) that the amplitude
% %   is going to be extracted from. e.g. [30,80]
% %
% % - <twin> : The window size (in seconds) in each sliding window
% %
% % - <tovp> : The percentage of overlap between two windows - [0,1)
% %
% % - <winovp_type> : The approach of sliding window to the onset of stimulus.
% %   it can be one of these options:
% %   -- "hardwin" : no window covers the onset of stimulus
% %   -- "softwin" : the center of the window till end covers the onset of
% %      stimulus
% %   -- "fulloverlapp" : sliding windows will cover the whole around the 
% %       onset of the stimulus
% %
% % - <ffixed> : The fixed frequency for dynamic PAC. It can be one of these
% %   options:
% %   -- "fixedfamp" : The PAC would get averaged in the "famp" interval
% %   -- "fixedfph" : The PAC would get averaged in the "fph" interval
% %   -- "fixedboth" : The PAC would get averaged in both "fph" and famp
% %       interval
% %   -- "varboth" : No average through frequencies.
% %
% % - <ttype> : The position of zero-point in time considerations of 
% %   sliding windows. It can be one of these options:
% %   -- <"first"> : first sample of the window
% %   -- <"center"> : center sample of the window
% %   -- <"last"> : last sample of the window
% %
% % Outputs:
% % - <MVL> : The mean vector length of phase of lower frequncies and the
% %   amplitude of higher frequencies. For each condition of "ffixed" parameter
% %   the size of "MVL" would be variable:
% %   -- for ffixed = "fixedfamp" : (nchannel,nchannel,window,fph,ntrials)
% %   -- for ffixed = "fixedfph" : (nchannel,nchannel,window,famp,ntrials)
% %   -- for ffixed = "fixedboth" : (nchannel,nchannel,window,ntrials)
% %   -- for ffixed = "varboth" : (nchannel,nchannel,window,fph,famp,ntrials)
% %
% % - <t_int_out> : The time vector with respect to the chosen cosideration
% %   for the zero-point by "ttype" input.
% %
% %
% % References:
% % [1] Munia, Tamanna TK, and Selin Aviyente. "Time-frequency based 
% %     phase-amplitude coupling measure for neuronal oscillations." 
% %     Scientific reports 9.1 (2019): 12441.
% %
% % 
% % March 2024
% % by Matin Arman Mehr
% % Email: matinarmanmehr@proton.me

% warning('off');
% 
% fp = fph(1):fph(2);
% fa = famp(1):famp(2);
% Lfp = fph(2)-fph(1)+1;
% Lfa = famp(2)-famp(1)+1;
% 
% ffixed = lower(ffixed);
% 
% data = EEG.data;
% data = zscore(data,[],2);
% t = EEG.times;
% Fs = EEG.srate;
% nch = EEG.nbchan;
% ntr = EEG.trials;
% 
% t_int = myTimeIntervalMaker([t(1),t(end)+1e3/Fs]*1e-3,Fs,twin,tovp,winovp_type);
% Lwin = length(t(t>=0 & t<twin*1e3));
% L = length(t_int);
% switch ffixed
%     case "fixedfamp"
%         MVLch = zeros(nch,nch,L,Lfp,Lfa,ntr);
%     case "fixedfph"
%         MVLch = zeros(nch,nch,L,Lfp,Lfa,ntr);
%     case "fixedboth"
%         MVLch = zeros(nch,nch,L,ntr);
%     case "varboth"
%         MVLch = zeros(nch,nch,L,Lfp,Lfa,ntr);
%     otherwise
%         error('Unknown fixed parameter phrase! It must be one of "fixedfamp", "fixedfph", "fixedboth" or "varboth"')
% end
% 
% 
% 
% for tr = 1:ntr
%     tfd = cell(1,nch);
%     for ch = 1:nch
%         tfd{ch} = zeros(L,Fs,Lwin);
%         for i = 1:L
%             disp("Calculating RID-Rihaczek for Channel: "+ch+" , Trial: "+tr+"/"+ntr+" , Progress: "+i/L*100+"%");
%             tfd{ch}(i,:,:) = rid_rihaczek4(data(ch,t>=t_int(i,1) & t<t_int(i,2),tr),Fs);
%         end
%     end
%     for ch1 = 1:nch
%         for ch2 = 1:nch
%             for i = 1:L
%                 disp(['Calculating PAC for channels:[',num2str([ch1,ch2]),'] , trial:',num2str(tr),'/',num2str(ntr),' , progress:',num2str(i/L*100),'%'])
%                 if ch1==ch2
%                     tfd_temp_ch1 = squeeze(tfd{ch1}(i,:,:));
%                 else
%                     tfd_temp_ch2 = squeeze(tfd{ch2}(i,:,:));
%                 end
% 
%                 for k1 = 1:Lfp
%                     for k2 = 1:Lfa
%                         if ch1==ch2
%                             MVLch(ch1,ch2,i,k1,k2,tr) =  MVL_lab_1freq(tfd_temp_ch1,fp(k1),fa(k2));
%                         else
%                             MVLch(ch1,ch2,i,k1,k2,tr) =  CrossMVL_lab_1freq(tfd_temp_ch1,tfd_temp_ch2,fp(k1),fa(k2));
%                         end
%                     end
%                 end
% 
%                 if ffixed == "fixedboth"
%                     if ch1==ch2
%                         MVLch(ch1,ch2,i,tr) =  MVL_lab(tfd_temp_ch1,fph,famp);
%                     else
%                         MVLch(ch1,ch2,i,tr) =  CrossMVL_lab(tfd_temp_ch1,tfd_temp_ch2,fph,famp);
%                     end
%                 end
%             end
%         end
%     end
% end
% 
% switch ffixed
%     case "fixedfamp"
%         MVL = squeeze(mean(MVLch,5));
%     case "fixedfph"
%         MVL = squeeze(mean(MVLch,4));
%     case "fixedboth"
%         MVL = MVLch;
%     case "varboth"
%         MVL = MVLch;
% end
% 
% switch ttype
%     case "center"
%         t_int_out = mean(t_int,2);
%     case "first"
%         t_int_out = t_int(:,1);
%     case "last"
%         t_int_out = t_int(:,2);
%     otherwise
%         error('Unknown ttype')
% end
% warning('on')
% end
% 
