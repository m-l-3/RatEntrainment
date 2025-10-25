function [Accuracy,tout] = calc_lda(Data,useClean,pool,balance,useERP,params,cfg)


nRat = length(Data);
Accuracy = cell(size(Data));

if (useERP)
    twin_len = params.twin_len;
    win_len = twin_len*params.fs;
    twin_slip = params.twin_slip;
    win_slip = twin_slip*params.fs;
    n_win = round((cfg.epoch_time(1)+cfg.epoch_time(2)-twin_len)/twin_slip + 1);
    t_seg = [-cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2];

    tout = t_seg;
else
    smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * params.fs;
    time = ((1:smple_num)/params.fs - 1/params.fs - cfg.epoch_t_start) * 1000;
    tout = time;
end

for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    Acc_sess = cell(1,nSess);
    Acc_mat = [];
    for iSess=1:nSess
        DataSess = DataRat{1,iSess};
        cleanTr = logical(DataRat{4,iSess});
        stdLabel = logical(DataRat{7,iSess});
        targetLabel = logical(DataRat{8,iSess});

        if(useClean)
            stdLabel = stdLabel & cleanTr;
            targetLabel = targetLabel & cleanTr;
        end

        nCh = size(DataSess,1);
        if(useERP)
            N = n_win;
        else
            N = size(DataSess,2);
        end


        Acc = NaN(nCh,N);
        for iCh=1:nCh
            if(all(isnan(DataSess(iCh, :, :))))
                continue
            end

            if(useERP)
                stdErp = squeeze(mean(DataSess(:, :, stdLabel),3,'omitnan'));
                targetErp = squeeze(mean(DataSess(:, :, targetLabel),3,'omitnan'));
                nStd = sum(stdLabel,1);
                nTarget = sum(targetLabel,1);
                if(balance)     
                    stdSig = squeeze(DataSess(:, :, stdLabel));
                    idx = randsample(nStd,nTarget);
                    stdErp = squeeze(mean(stdSig(:, :, idx),3,'omitnan'));
                end
 
                for iWin=1:n_win                 
                    x_std = stdErp(iCh,(iWin-1)*win_slip+1:(iWin-1)*win_slip+win_len)';
                    x_target = targetErp(iCh,(iWin-1)*win_slip+1:(iWin-1)*win_slip+win_len)';

                    n_std = size(x_std,1);
                    n_target = size(x_target,1);
                   
                    X = [x_std; x_target]; % Feature vector
                    Y = [zeros(size(x_std)); ones(size(x_target))];  % Class labels
                    % Fitting the LDA model
                    ldaModel = fitcdiscr(X, Y);
                    Y_pred = predict(ldaModel,X);
                    acc = sum(Y==Y_pred)/(n_std+n_target);
                    Acc(iCh, iWin) = acc;

                end                

            else
                for iTime=1:N
                    x_std = squeeze(DataSess(iCh, iTime, stdLabel));
                    x_target = squeeze(DataSess(iCh, iTime, targetLabel));
                    n_std = size(x_std,1);
                    n_target = size(x_target,1);
                    if(balance)
                        idx = randsample(n_std,n_target);
                        x_std = x_std(idx);
                        n_std = size(x_std,1);
                    end
                    
    
                    X = [x_std; x_target]; % Feature vector
                    Y = [zeros(size(x_std)); ones(size(x_target))];  % Class labels
                    % Fitting the LDA model
                    ldaModel = fitcdiscr(X, Y);
                    Y_pred = predict(ldaModel,X);
                    acc = sum(Y==Y_pred)/(n_std+n_target);
                    Acc(iCh, iTime) = acc;
                end
            end
        end

        
        Acc_sess{1,iSess} = Acc;
        Acc_mat = cat(3,Acc_mat,Acc);
    end

    if(pool)
        Accuracy{iRat,1} = mean(Acc_mat,3,'omitnan');
    else
        Accuracy{iRat,1} = Acc_sess;
    end
end
