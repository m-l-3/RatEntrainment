function plot_fmulti_band_power (input,time,freq,freq_ranges,smth,lw,titles,leg,colors)


n_range = size(freq_ranges,1);
n_data = size(input,2);
n_holdOn = size(input,1);

figure
% figure('WindowState', 'maximized'); 
for i_data=1:n_data

    for i_range=1:n_range

        h = subplot(n_range,n_data,(i_range-1)*n_data + i_data);
        position = get(h, 'Position');  
        if(i_range==1)
            annotation('textbox', [position(1)+0.2*position(3), 0.85, 0.1, 0.1], 'String', titles(i_data), 'EdgeColor', 'none', 'HorizontalAlignment', 'center');  
        end

        ff = [freq_ranges(i_range,1) freq_ranges(i_range,2)];
        f_sel = freq>=ff(1) & freq<=ff(2);
        
        for i_holdOn=1:n_holdOn
            input_data = input{i_holdOn,i_data};
            stdshade(squeeze(mean(input_data(:,:,f_sel),2)),0.4,colors(i_holdOn),freq(f_sel),smth)
            hold on; 
        end
        hold off

        if i_range~=n_range 
            set(gca, 'XTickLabel', []); 
        end 


        if i_data==n_data && i_range==1
            legend(leg, 'Position', [position(1)+position(3) position(2)+position(4)*.45 0.1 0.1]);
        end 
              
    end
    xlabel('Frequency (Hz)')
    
    
end


