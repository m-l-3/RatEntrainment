for i=1:1
    temp{i,1}=bandPower_before{6,1}{i,3};
    temp{i,2}=bandPower_before{6,1}{i,4};
end
bandPower_before{6,1} = [];
bandPower_before{6,1} = temp;

%%
st = 1;
iTrial = st:st+60;
iRat = 5;
iSess = 3;

temp = mean(Before_Data{iRat,1}{1,iSess}(iCh,:,iTrial),3,'omitnan');
% figure
plot(temp)

%%
params.lBatch = 60;
params.lBatchStep = 1;

[before_seq] = sequenceFinder(Before_Data,"target",params);
[after30_seq] = sequenceFinder(After30_Data,"target",params);

[before_seqArr] = makeArray(before_seq);
[after30_seqArr] = makeArray(after30_seq);
%%
iCh = 3;
iRat = 6;
iSess = 2;
figure
subplot(2,1,1)
plot(squeeze(mean(before_seqArr(:,:,iRat,iSess), [3 4], 'omitnan')))
subplot(2,1,2)
plot(squeeze(mean(P3amp_BeforeArr(iCh,:,iRat,iSess),[3 4],'omitnan')), 'b')
