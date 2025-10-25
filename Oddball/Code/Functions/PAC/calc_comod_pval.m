function [pval_mat, h_mat] = calc_comod_pval(in_data,time,fphase,famplitude,params)

type = params.type;
is_corr = params.is_corr;
is_baseline_norm = params.is_baseline_norm;

n_ch = size(in_data{1,1},1);
n = length(time);
if(is_corr)
    alpha = 0.05/n;
else
    alpha = 0.05;
end

if(is_baseline_norm)
    t_idx = time<=0;
    in_data_Tar_basenorm = in_data{3,1}(:,:,:,:,:,2:end) - mean(in_data{3,1}(:,:,t_idx,:,:,2:end),3);
    in_data_Std_basenorm = in_data{2,1}(:,:,:,:,:,2:end) - mean(in_data{2,1}(:,:,t_idx,:,:,2:end),3);
else
    in_data_Tar_basenorm = in_data{3,1}(:,:,:,:,:,2:end);
    in_data_Std_basenorm = in_data{2,1}(:,:,:,:,:,2:end);
end
disp('Rat 5 is excluded (2:end)')

pval_mat = NaN(size(n_ch,n_ch,length(time),length(fphase),length(famplitude)));
h_mat = NaN(size(n_ch,n_ch,length(time),length(fphase),length(famplitude)));
for ch1 = 1:n_ch
    for ch2 = 1:n_ch
        for t_idx = 1:length(time)
            for fph = 1:length(fphase)
                parfor famp = 1:length(famplitude)
                    x = squeeze(in_data_Tar_basenorm(ch1,ch2,t_idx,fph,famp,:));
                    y = squeeze(in_data_Std_basenorm(ch1,ch2,t_idx,fph,famp,:));

                    switch type
                        case 'ttest'
                            [h,p] = ttest(x,y,'Alpha',alpha); %'paired'
                        case 'ttest2'
                            [h,p] = ttest2(x,y,'Alpha',alpha);
                        case 'signrank'
                            [p,h] = signrank(x,y,'Alpha',alpha); %'paired'
                        case 'ranksum'
                            [p,h] = ranksum(x,y,'Alpha',alpha);
                        case 'signtest'
                            [p,h] = signtest(x,y,'Alpha',alpha); % median
                    end

                    pval_mat(ch1,ch2,t_idx,fph,famp) = p;
                    h_mat(ch1,ch2,t_idx,fph,famp) = h;
                end
            end
        end
    end
end
h_mat = logical(h_mat);