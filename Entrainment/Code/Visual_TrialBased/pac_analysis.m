clear
% close all
clc

cfgRef
%% load

fileName = fullfile(path_results,'PAC_trialSwap/','pyPACcomo_allCh_allWin_meanTrial_perRatSess.mat');
load(fileName)

%%
[PACArr] = makeArray(PAC, cfg);

%% 2d comodulogram

baselineNormalize = false;
iRat = 1:9;
ch1 = 4;
ch2 = 4;
fph_range = [4 12];
famp_range = [16 90];


fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;
tbase = tout>=-0.3 & tout<=0;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));

if(baselineNormalize)
    PAC2plot = PACArr - mean(PACArr(:,:,tbase,:,:,:,:,:),3,'omitnan');
    c_max = 5e-4;
else
    PAC2plot = PACArr;
    c_max = 2e-3;
end

figure
% for ti=1:length(tout)
%     ti=1:length(tout);
    ti = tout>0;
    for iBlock=1:nBlock
        for iSess=1:nSession
            subplot(nBlock,nSession,(iBlock-1)*nSession+iSess)
            img = squeeze(mean(PAC2plot(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess,iBlock),[3 6], 'omitnan'));
            pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
            clim([0 c_max])
            title("Day"+string(days(iSess)));
            if(iSess==1)
                ylabel(blocks(iBlock))
            end
        end
    end

%     sgtitle(sprintf('%s {phase} - %s {amp}\n t=%.2f', T.Channel{iRat(end),1}(ch1), T.Channel{iRat(end),1}(ch2),tout(ti)))
    sgtitle(sprintf('%s {phase} - %s {amp}', T.Channel{iRat(end),1}(ch1), T.Channel{iRat(end),1}(ch2)))

    drawnow                             
    pause(0.1)
% end


%% 2d in time

iSess = 5;
iBlock = 1;
iRat = 1:9;
ch1 = 3;
ch2 = 3;
fph_range = [6 10];
famp_range = [16 90];
c_max = 2e-3;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[t_mesh,famp_mesh] = meshgrid(tout, famp_out(famp_idx));
% [t_mesh,fph_mesh] = meshgrid(tout, fph_out(fph_idx));

figure
img = squeeze(mean(PACArr(ch1,ch2,:,famp_idx,fph_idx,iRat,iSess,iBlock),[5 6], 'omitnan'));
pcolor(t_mesh,famp_mesh,img'); shading interp; colormap jet
% img = squeeze(mean(PACArr(ch1,ch2,:,famp_idx,fph_idx,iRat,iSess,iBlock),[4 6], 'omitnan'));
% pcolor(t_mesh,fph_mesh,img'); shading interp; colormap jet
clim([0 c_max])


%% 1d in time
iBlock = 2;

baselineNormalize = false;  
iRat = 1:9;
ch1 = 3;
ch2 = 3;
fph_range = [6 10];
famp_range = [30 50];
smooth = 3;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;
tbase = tout>=-0.3 & tout<=0;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));

if(baselineNormalize)
    PAC2plot = PACArr - mean(PACArr(:,:,tbase,:,:,:,:,:),3,'omitnan');
else
    PAC2plot = PACArr;
end

figure
iSess = 1;
stdshade(squeeze(mean(PAC2plot(ch1,ch2,:,famp_idx,fph_idx,iRat,iSess,iBlock),[4 5], 'omitnan'))', 0.4, 'b', tout, smooth)
hold on
% iSess = 3;
% stdshade(squeeze(mean(PAC2plot(ch1,ch2,:,famp_idx,fph_idx,iRat,iSess,iBlock),[4 5], 'omitnan'))', 0.4, 'r', tout, smooth)
% iSess = 4;
% stdshade(squeeze(mean(PAC2plot(ch1,ch2,:,famp_idx,fph_idx,iRat,iSess,iBlock),[4 5], 'omitnan'))', 0.4, 'g', tout, smooth)
iSess = 5;
stdshade(squeeze(mean(PAC2plot(ch1,ch2,:,famp_idx,fph_idx,iRat,iSess,iBlock),[4 5], 'omitnan'))', 0.4, 'm', tout, smooth)
xline(0)
legend('Day1', 'Day30')

