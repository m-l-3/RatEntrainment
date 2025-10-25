function [f,Wpli] = calc_wpli_spec(Data,iTarStd,params,useClean,pool)


nRat = length(Data);
Wpli = cell(size(Data));

[tapers,pad,Fs,fpass,err,trialave,params]=getparams(params);


for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    wpli_sess = cell(1,nSess);
    wpli_mat = [];
    for iSess=1:1
        DataSess = DataRat{iTarStd,iSess};
        cleanTr = logical(DataRat{iTarStd+3,iSess});
%         nTrial = size(DataSess,3);
        nCh = size(DataSess,1);
        N = size(DataSess,2);
        N = 1200;
        nfft = max(2^(nextpow2(N)+pad),N);
        [f,findx] = getfgrid(Fs,nfft,fpass);
        tapers = dpsschk(tapers,N,Fs); % check tapers        

        wpli = NaN(length(f),nCh,nCh);

        for iCh = 1:nCh
            for jCh = iCh:nCh
                %% stim.
                datai = squeeze(DataSess(iCh,3401:4600,:));
                dataj = squeeze(DataSess(jCh,3401:4600,:));        

                Ji = mtfftc(datai,tapers,nfft,Fs);
                Ji = Ji(findx,:,:);
                Jj = mtfftc(dataj,tapers,nfft,Fs);
                Jj = Jj(findx,:,:);

                S = permute(mean(Ji.*conj(Jj),2),[1 3 2]);
                if(useClean)
                    S_clean = S(:,cleanTr);
                else
                    S_clean = S;
                end

                wpli_stim = abs(mean(imag(S_clean),2,'omitnan'))./mean(abs(imag(S_clean)),2,'omitnan');
                wpli(:,iCh,jCh) = wpli_stim;
                wpli(:,jCh,iCh) = wpli_stim;

%                 %% rest
%                 datai = squeeze(DataSess(iCh,1:2000,:));
%                 dataj = squeeze(DataSess(jCh,1:2000,:));                
%              
%                 Ji = mtfftc(datai,tapers,nfft,Fs);
%                 Ji = Ji(findx,:,:);
%                 Jj = mtfftc(dataj,tapers,nfft,Fs);
%                 Jj = Jj(findx,:,:);
% 
%                 S = permute(mean(Ji.*conj(Jj),2),[1 3 2]);
%                 if(useClean)
%                     S_clean = S(:,cleanTr);
%                 else
%                     S_clean = S;
%                 end
% 
%                 wpli_rest = abs(mean(imag(S_clean),2,'omitnan'))./mean(abs(imag(S_clean)),2,'omitnan');
%                 wpli(:,iCh,jCh) = wpli_stim-wpli_rest;
%                 wpli(:,jCh,iCh) = wpli_stim-wpli_rest;

            end
        end
        wpli_sess{1,iSess} = wpli;
        wpli_mat = cat(4,wpli_mat,wpli);
    end

    if(pool)
        Wpli{iRat,1} = mean(wpli_mat,4,'omitnan');
    else
        Wpli{iRat,1} = wpli_sess;
    end
end
