function [t,f,Specgram] = calc_specgram(Data,movingwin,params,iTarStd,useClean,useERP,correctPow)
if(nargin<6)
    useERP = 1; % calculate for ERP signal
end

if(nargin<7)
    correctPow = 0; % calculate for ERP signal
end

userTrialAvg = params.trialave;
params.trialave = false;

nRat = length(Data);
Specgram = cell(size(Data));
for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    specgram_sess = cell(1,nSess);
    for iSess=1:nSess
        DataSess = DataRat{iTarStd,iSess};
        cleanTr = logical(DataRat{iTarStd+3,iSess});
%         nTrial = size(DataSess,3);
        nCh = size(DataSess,1);
        spec = [];

        for iCh = 1:nCh
            if(useClean)
                sig =  squeeze(DataSess(iCh,:,cleanTr));
            else
                sig =  squeeze(DataSess(iCh,:,:));
            end

            nBootStrap = 240;
            rng(1200);
            sigBoot = NaN(size(sig,1),nBootStrap);
            for iBootStrap = 1:nBootStrap
                sigSample = datasample(sig, 10, 2);
                sigBoot(:,iBootStrap) = mean(sigSample,2,'omitnan');
            end
            sig = sigBoot; 

            if(useERP)
                sig = mean(sig,2,'omitnan');
%                 nt = size(sig,2);
%                 randIdx = randperm(nt, floor(min(48,.25*nt)));
%                 sig = mean(sig(:,randIdx),2,'omitnan');
            end
%             [S,t,f]=mtspecgramc(sig,movingwin,params);
            STrial = NaN(69,875,size(sig,2));
            Fs = params.Fs;
            if(~any(isnan(sig)))
                for iTrial=1:size(sig,2)
                    [STrial(:,:,iTrial),f] = cwt(sig(:,iTrial),'amor',Fs);
                end
%                 [S,f] = cwt(sig,'amor',Fs);
            end     
            S = mean(abs(STrial).^2,3)';
            f = f';
            t = -1.5+1/Fs:1/Fs:2;
%             [S,t,f]=mypmtm(sig,movingwin,params);

            if(correctPow)
                if(size(S,1)~=length(t))
                    S = reshape(S, [1, size(S,1), size(S,2)]);
                end
                [S_corr, ~, ~] = correct_1overf(S, f, params.freqRangeCorrectin);
                S = 10.^S_corr;
            end

            if(userTrialAvg)
                S = mean(S,3);
                spec = cat(3,spec,(S));
            else
                spec = cat(4,spec,(S));
            end
        end
        specgram_sess{1,iSess} = spec;
    end
    Specgram{iRat,1} = specgram_sess;
end
