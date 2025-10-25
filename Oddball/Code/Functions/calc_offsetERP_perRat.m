function [ERP, time] = calc_offsetERP_perRat(Data,cfg,useClean, bootStrap, offset, winLen)

nBootStrap = 200;
nRat = length(Data);
nCh = cfg.n_ch;
if(cfg.is_downsample)
    fs = cfg.fs_down;
else
    fs = cfg.fs;
end
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;
winSample = winLen/1000*fs;
smple_num = 2*winSample+1;

allErp_rat = NaN(nCh,smple_num,nRat);
stdErp_rat = NaN(nCh,smple_num,nRat);
targetErp_rat = NaN(nCh,smple_num,nRat);
changedErp_rat = NaN(nCh,smple_num,nRat);
unChangedErp_rat = NaN(nCh,smple_num,nRat);

for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    t_cnt = find(time>=offset(iRat),1)-1;
    if(isempty(t_cnt))
        continue
    end
    t_idx = t_cnt-winSample:t_cnt+winSample;

    allErp_sess = [];
    stdErp_sess = [];
    targetErp_sess = [];
    changedErp_sess = [];
    unChangedErp_sess = [];

    %     if(iRat==5 || iRat==6)
    %         nSess=3;
    %     end
    for iSess=1:nSess
        DataSess = DataRat{1,iSess};
        cleanTr = logical(DataRat{4,iSess});

        allTr = true(size(DataRat{4,iSess}));
        stdTr = logical(DataRat{7, iSess});
        targetTr = logical(DataRat{8, iSess});
        changedTr = logical(DataRat{9, iSess});
        unChangedTr = logical(DataRat{10, iSess});

        if(useClean)
            allTr = allTr & cleanTr;
            stdTr = stdTr & cleanTr;
            targetTr = targetTr & cleanTr;
            changedTr = changedTr & cleanTr;
            unChangedTr = unChangedTr & cleanTr;
        end

        if(~bootStrap)
            allErp = mean(DataSess(:,t_idx,allTr),3,'omitnan');
            stdErp = mean(DataSess(:,t_idx,stdTr),3,'omitnan');
            targetErp = mean(DataSess(:,t_idx,targetTr),3,'omitnan');
            changedErp = mean(DataSess(:,t_idx,changedTr),3,'omitnan');
            unChangedErp = mean(DataSess(:,t_idx,unChangedTr),3,'omitnan');
        else

    
            allErp = zeros(nCh,smple_num,nBootStrap);
            stdErp = zeros(nCh,smple_num,nBootStrap);
            targetErp = zeros(nCh,smple_num,nBootStrap);
            changedErp = zeros(nCh,smple_num,nBootStrap);
            unChangedErp = zeros(nCh,smple_num,nBootStrap);

            for iBootStrap = 1:nBootStrap
                allSample = datasample(DataSess(:,:,allTr), sum(allTr==1), 3); 
                stdSample = datasample(DataSess(:,:,stdTr), sum(stdTr==1), 3);
                targetSample = datasample(DataSess(:,:,targetTr), sum(targetTr==1), 3);
                changedSample = datasample(DataSess(:,:,changedTr), sum(changedTr==1), 3);
                unChangedSample = datasample(DataSess(:,:,unChangedTr), sum(unChangedTr==1), 3);

                allErp(:,:,iBootStrap) = mean(allSample,3,'omitnan'); 
                stdErp(:,:,iBootStrap) = mean(stdSample,3,'omitnan'); 
                targetErp(:,:,iBootStrap) = mean(targetSample,3,'omitnan'); 
                changedErp(:,:,iBootStrap) = mean(changedSample,3,'omitnan'); 
                unChangedErp(:,:,iBootStrap) = mean(unChangedSample,3,'omitnan');       

            end
       
        end


        allErp_sess = cat(3, allErp_sess, allErp);
        stdErp_sess = cat(3, stdErp_sess, stdErp);
        targetErp_sess = cat(3, targetErp_sess, targetErp);
        changedErp_sess = cat(3, changedErp_sess, changedErp);
        unChangedErp_sess = cat(3, unChangedErp_sess, unChangedErp);

%         allErp_rat(:,:,iRat,iSess) = mean(allErp,3,'omitnan');
%         stdErp_rat(:,:,iRat,iSess) = mean(stdErp,3,'omitnan');
%         targetErp_rat(:,:,iRat,iSess) = mean(targetErp,3,'omitnan');
%         changedErp_rat(:,:,iRat,iSess) = mean(changedErp,3,'omitnan');
%         unChangedErp_rat(:,:,iRat,iSess) = mean(unChangedErp,3,'omitnan');

    end

    allErp_rat(:,:,iRat) = mean(allErp_sess,3,'omitnan');
    stdErp_rat(:,:,iRat) = mean(stdErp_sess,3,'omitnan');
    targetErp_rat(:,:,iRat) = mean(targetErp_sess,3,'omitnan');
    changedErp_rat(:,:,iRat) = mean(changedErp_sess,3,'omitnan');
    unChangedErp_rat(:,:,iRat) = mean(unChangedErp_sess,3,'omitnan');

    
end

ERP.all = allErp_rat;
ERP.std = stdErp_rat;
ERP.target = targetErp_rat;
ERP.changed = changedErp_rat;
ERP.unChanged = unChangedErp_rat;
time = nanmean(offset)-winLen:1000/fs:nanmean(offset)+winLen;

