function [fsel,t, Wpli] = calc_wpli_wavelet(Data,params,useClean,pool)

iTarStd = 1;
nRat = length(Data);
Wpli = cell(size(Data));

Fs = params.fs;
frange = params.frange;
fres_param = params.fres_param;
times = params.times;


for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    wpli_sess = cell(1,nSess);
    wpli_mat = [];
    for iSess=1:1
        
        DataSess = DataRat{iTarStd,iSess};
        cleanTr = logical(DataRat{iTarStd+3,iSess});

        if(useClean)
            data = DataSess(:,:,cleanTr);
            std_labels = DataRat{7,iSess}(cleanTr);
            target_labels = DataRat{8,iSess}(cleanTr);
        else
            data = DataSess;
            std_labels = DataRat{7,iSess};
            target_labels = DataRat{8,iSess};
        end

        nTrial = size(data,3);
        nCh = size(data,1);

        fb = cwtfilterbank('Wavelet','amor','SignalLength',length(times),'FrequencyLimits',[0,max(frange)],'SamplingFrequency',Fs,'VoicesPerOctave',fres_param);
        
        [~,ff,cod] = cwt(data(1,:,1),FilterBank=fb);

        % Trimming the start and end of the window
        idx_start = find(cod < frange(1),1,'first');
        idx_end = length(times) - idx_start + 1;
        t = times(idx_start:idx_end);
        L = length(t);
      
        fsel = ff(ff>=frange(1) & ff<=frange(end));
        Lfsel = length(fsel);

        tfd_all = NaN(nCh, nTrial, length(ff), length(t));


        for iTtrial = 1:nTrial
            for iCh = 1:nCh
                
                % Getting t-f distribution
                if(all(isnan(data(iCh,:,iTtrial))))
                    tfd_all(iCh,iTtrial,:,:) = NaN(length(ff),length(t));
                else
                    temp = cwt(data(iCh,:,iTtrial),FilterBank=fb);
                    tfd_all(iCh,iTtrial,:,:) = temp(:,idx_start:idx_end);
                end

            end
        end

        wpli = NaN(nCh,nCh,Lfsel,L,3);

        for ch1 = 1:nCh
            for ch2 = ch1+1:nCh
                if(all(isnan(tfd_all(ch1,iTtrial,:,:)),'all') || all(isnan(tfd_all(ch2,iTtrial,:,:)),'all'))
                    continue;
                end

                ch1_allwin = squeeze(tfd_all(ch1,:, ismember(ff,fsel),:));
                ch2_allwin = squeeze(tfd_all(ch2,:, ismember(ff,fsel),:));
                wpli(ch1,ch2,:,:,1) = calc_wpli(ch1_allwin, ch2_allwin);

                ch1_allwin = squeeze(tfd_all(ch1,std_labels, ismember(ff,fsel),:));
                ch2_allwin = squeeze(tfd_all(ch2,std_labels, ismember(ff,fsel),:));
                wpli(ch1,ch2,:,:,2) = calc_wpli(ch1_allwin, ch2_allwin);

                ch1_allwin = squeeze(tfd_all(ch1,target_labels, ismember(ff,fsel),:));
                ch2_allwin = squeeze(tfd_all(ch2,target_labels, ismember(ff,fsel),:));
                wpli(ch1,ch2,:,:,3) = calc_wpli(ch1_allwin, ch2_allwin);

                
            end
        end

        disp(['iRat: ',num2str(iRat),'/',num2str(nRat),' | iSession: ',num2str(iSess),' | ',num2str(iRat/nRat*100),'%'])
        wpli_sess{1,iSess} = wpli;
        wpli_mat = cat(6,wpli_mat,wpli);
    end

    if(pool)
        Wpli{iRat,1} = mean(wpli_mat,6,'omitnan');
    else
        Wpli{iRat,1} = wpli_sess;
    end
end
