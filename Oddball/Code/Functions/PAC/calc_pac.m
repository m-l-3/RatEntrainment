function [PAC,tout,fph_out,famp_out] = calc_pac(Data,params,useClean,cfg)

% Matin EEGLAB structure
iTarStd = 1;
nRat = length(Data);
PAC = cell(size(Data));
Fs = params.fs;
fph = params.fph;
famp = params.famp;
twin = params.twin;
tovp = params.tovp;
method = params.method;
fres_param = params.fres_param;
nperm = params.nperm;
nbins = params.nbins;
time = params.time;
ttype = params.ttype;

for iRat=7:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    pac_sess = cell(3,nSess);

    for iSess=1:nSess
        DataSess = DataRat{iTarStd,iSess};
        cleanTr = logical(DataRat{iTarStd+3,iSess});


        if(useClean)
            EEG.data = DataSess(:,:,cleanTr);
            std_labels = DataRat{end-1,iSess}(cleanTr);
            target_labels = DataRat{end,iSess}(cleanTr);
        else
            EEG.data = DataSess;
            std_labels = DataRat{end-1,iSess};
            target_labels = DataRat{end,iSess};
        end
        EEG.times = time;
        EEG.srate = Fs;

        [pac,tout,fph_out,famp_out,~,~] = myPAC_varTime_2Dstr_allChan(EEG,fph,famp,twin,tovp,ttype,method,fres_param,nbins,nperm);
        
        pac_sess{1,iSess} = mean(pac,6,'omitnan'); % all trials
        pac_sess{2,iSess} = mean(pac(:,:,:,:,:,std_labels),6,'omitnan'); % std trial
        pac_sess{3,iSess} = mean(pac(:,:,:,:,:,target_labels),6,'omitnan'); % target trial

    end

    PAC{iRat,1} = pac_sess;
    paramsOut.tout = tout;
    paramsOut.fph_out = fph_out;
    paramsOut.famp_out = famp_out;
    save_dir = 'D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\PAC_general\';
    save(strcat(save_dir, sprintf('PACcomo_allCh_allWin_meanTrial_Rat%d',iRat), '.mat'), 'PAC', 'params', 'paramsOut', 'cfg');
    

end