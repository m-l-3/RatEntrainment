function [PAC,tout,fph,famp,trialvec,tfd_all] = myPAC_varTime_2Dstr_allChan2(EEG,fph,famp,twin,tovp,ttype,method,fres_param,nbins,nperm)

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

        disp('true PAC')
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
                        PAC(ch1,ch2,ti,:,:,tr) = myPAC_MI(squeeze(Phase_temp(:,ti,:)), squeeze(Amp_temp(:,ti,:)), nbins, 0);
                    end

                end
            end
        end

        if(nperm>0)
            PAC_surr = NaN(nch,nch,L,Lfp,Lfa,ntr);
            disp('computing surrogates')
            for ch1 = 3%1:nch
                for ch2 = 3%1:nch
                    if(all(isnan(tfd_all{ch1,1}),'all') || all(isnan(tfd_all{ch2,1}),'all'))
                        continue;
                    end
                    for ti = 1:L  
                        PAC_temp = NaN(Lfp,Lfa,ntr,nperm);
                        parfor iperm=1:nperm                            
                            disp(['permutation: ',num2str(iperm),'/',num2str(nperm),' | win: [',num2str(ti), '] | ', ' | channels: [',num2str([ch1,ch2]),'] | ',num2str(iperm/nperm*100),'%'])
        
                            rnd_idx = randperm(ntr);
                            tfd_all_perm = tfd_all(:,rnd_idx);
    
                            for tr=1:ntr
                                Phase_allwin = angle(tfd_all_perm{ch1,tr}(ismember(ff,fph),:));
                                Amp_allwin = abs(tfd_all{ch2,tr}(ismember(ff,famp),:));                            
    
                                Phase_temp = squeeze(Phase_allwin(:,t_idx(ti,:)));
                                Amp_temp = squeeze(Amp_allwin(:,t_idx(ti,:)));
                                % Finding PAC at each window
                                PAC_temp(:,:,tr,iperm) = myPAC_MI(Phase_temp, Amp_temp, nbins, 0);
                                
                            end 
                            
                        end 
                        PAC_surr(ch1,ch2,ti,:,:,:) = mean(PAC_temp,4);
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

