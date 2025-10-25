

useClean = true;
params.Fs = fs;
params.freq_range = [1 50];
params.nCycles = 6;


iTarStd = 3; % 1:All, 2:Std, 3:Target
[~,~,Before_ITPC] = calc_itpc(Before_Data,params,iTarStd,useClean);
[~,~,After30_ITPC] = calc_itpc(After30_Data,params,iTarStd,useClean);
[BeforeTar_ItpcArr] = makeArray(Before_ITPC);
[After30Tar_ItpcArr] = makeArray(After30_ITPC);
After30Tar_ItpcArr(:,:,:,4:8,:) = After30Tar_ItpcArr;
After30Tar_ItpcArr(:,:,:,1:3,:) = nan;

iTarStd = 2; % 1:All, 2:Std, 3:Target
[~,~,Before_ITPC] = calc_itpc(Before_Data,params,iTarStd,useClean);
[t,f,After30_ITPC] = calc_itpc(After30_Data,params,iTarStd,useClean);
[BeforeStd_ItpcArr] = makeArray(Before_ITPC);
[After30Std_ItpcArr] = makeArray(After30_ITPC);
After30Std_ItpcArr(:,:,:,4:8,:) = After30Std_ItpcArr;
After30Std_ItpcArr(:,:,:,1:3,:) = nan;

%%
iCh = 3;
iRat = 1:8;
iSess = 1;

figure
[tt,ff] = meshgrid(t,f);
pcolor(tt,ff, squeeze(mean(BeforeStd_ItpcArr(:,:,iCh,iRat,iSess), [4 5], 'omitnan')))
shading flat
clim([0 0.24]);

figure
pcolor(tt,ff, squeeze(mean(BeforeTar_ItpcArr(:,:,iCh,iRat,iSess), [4 5], 'omitnan')))
shading flat
clim([0 0.24]);
