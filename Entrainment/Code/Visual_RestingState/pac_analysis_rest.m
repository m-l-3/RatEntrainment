clear
% close all
clc

cfgRef_Rest
%% load

fileName = fullfile(path_results,'PAC_general2/','pyPACcomo_allCh_meanWin_perRatSess.mat');
load(fileName)

%%
[PACArr] = makeArray(PAC, cfg);

%% 2d comodulogram

iRat = 1:9;
ch1 = 3;
ch2 = 3;
fph_range = [4 12];
famp_range = [16 90];
c_max = 2.5e-2;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));

PAC2plot = PACArr;
figure
for iBlock=1:nBlock
    for iSess=1:nSession
        subplot(nBlock,nSession,(iBlock-1)*nSession+iSess)
        img = squeeze(mean(PAC2plot(ch1,ch2,famp_idx,fph_idx,iRat,iSess,iBlock),[5], 'omitnan'));
        pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
        clim([0 c_max])
%         colorbar
        title("Day"+string(days(iSess)));
        if(iSess==1)
            ylabel(blocks(iBlock))
        end
    end
end

sgtitle(sprintf('%s {phase} - %s {amp}', T.Channel{iRat(end),1}(ch1), T.Channel{iRat(end),1}(ch2)))
