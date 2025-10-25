function [PAC, time_pac, famp_out, fph_out] = pacLoader(input,path,folderName,useSingle)


nRat = length(input);
PAC = cell(size(input));

for iRat=1:nRat
    disp('Rat: '+string(iRat))
    DataRat = input{iRat,1};
    nSess = size(DataRat,1);
    pac_sess = cell(1,nSess);

    for iSess=1:nSess

        fileName = "pyPACcomo_allCh_allWin_allTrial_"+folderName+"_Rat"+string(iRat-1)+"_Sess"+string(iSess-1)+".mat";
        pacLoad = load(fullfile(path, folderName, fileName));
        
        if useSingle
            pac_sess{1,iSess} = single(pacLoad.pac);
        else
            pac_sess{1,iSess} = pacLoad.pac;
        end
        
    end

    PAC{iRat,1} = pac_sess;
     
end

time_pac = pacLoad.paramsOut.tout;
famp_out = mean(pacLoad.paramsOut.famp_out, 2);
fph_out = mean(pacLoad.paramsOut.fph_out, 2);