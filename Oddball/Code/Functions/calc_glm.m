function [Beta] = calc_glm(DataX,Datay,params,useClean)

rangIdx = params.idx;
nRat = length(DataX);
Beta = cell(size(DataX));
for iRat=1:nRat
    DataXRat = DataX{iRat,1};
    DatayRat = Datay{iRat,1};
    nSess = size(DataXRat,2);
    beta_sess = cell(1,nSess);
    for iSess=1:nSess
        DataSess = DataXRat{1,iSess};
        DataySess = DatayRat{1,iSess};
        cleanTr = logical(DataXRat{4,iSess});         
        nCh = size(DataSess,1);
        nTime = size(DataySess,1);
        beta = NaN(3,nCh,nTime);

        seq = DataXRat{8,iSess};
        x1 = seq; % target=1, std=0;
        x2 = DataXRat{9,iSess}; % cahnged=1, unChanged=0;
%         x3 = movmean(changed,3);
%         x3 = (1:240)'/240;
%         X = [x1 x2 x3];
        X = [x1 x2];

        for iCh = 1:nCh
            y_vec = squeeze(mean(DataySess(:, rangIdx, :, iCh), 2, 'omitnan'));
            if(any(isnan(y_vec)))
                continue
            end
            for iTime=1:nTime
                y = squeeze(y_vec(iTime,:));

                if(useClean)
                    [b,dev,stats] = glmfit(X(cleanTr,:), y(cleanTr), params.dist, 'Constant', params.constant);
                else
                    [b,dev,stats] = glmfit(X, y, params.dist, 'Constant', params.constant);
                end

                beta(:,iCh,iTime) = b./stats.se; 
%                 Stats = cat(1,Stats,stats);
%                 disp = cat(2,disp, stats.sfit);
            end

        end
        beta_sess{1,iSess} = beta;
    end
    Beta{iRat,1} = beta_sess;
end
