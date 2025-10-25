function [pval_vec,h_vec] = plot_timeStar(t,x,y,type,is_corr)

n = length(t);
pval_vec = NaN(n,1);
h_vec = NaN(n,1);

if(is_corr)
    alpha = 0.05/n;
else
    alpha = 0.05;
end

for i=1:length(t)
    xx = x(:,i);
    yy = y(:,i);

    switch type
        case 'ttest'
            [h,p] = ttest(xx,yy,'Alpha',alpha); %'paired'
        case 'ttest2'
            [h,p] = ttest2(xx,yy,'Alpha',alpha);
        case 'signrank'
            [p,h] = signrank(xx,yy,'Alpha',alpha); %'paired'
        case 'ranksum'
            [p,h] = ranksum(xx,yy,'Alpha',alpha);
        case 'signtest'
            [p,h] = signtest(xx,yy,'Alpha',alpha); % median
    end
        
    pval_vec(i) = p;
    h_vec(i) = h;
end
h_vec = logical(h_vec);

pos = max([mean(x,'omitnan');mean(y,'omitnan')],[],'all')*1.1;

if(sum(h_vec)>=1)
    plot(t(h_vec), pos, '*k','MarkerSize',2)
end