function plot_multi_band_specgram (input,time,freq,freq_ranges,time_ranges,sizes,lw,titles,balance_cb)

if(nargin<9)
    balance_cb = false;
end
n_range = size(freq_ranges,1);
n_data = size(input,3);
total_size = sum(sizes);

sizes = cumsum(sizes(:));
sizes = [0; sizes];

time = time(time_ranges);
input = input(time_ranges,:,:);
figure('WindowState', 'maximized'); 
for i_data=1:n_data
    input_data = input(:,:,i_data);
    [m,~] = size(input_data);
    if m==numel(time)
        input_data = input_data';
    end
    
    
    for i_range=1:n_range

        h = subplot(total_size,n_data,((sizes(i_range):sizes(i_range+1)-1)*n_data+1)+i_data-1);
        position = get(h, 'Position');  
        if(i_range==1)
            annotation('textbox', [position(1)+0.2*position(3), 0.85, 0.1, 0.1], 'String', titles(i_data), 'EdgeColor', 'none', 'HorizontalAlignment', 'center');  
        end

        ff = [freq_ranges(i_range,1) freq_ranges(i_range,2)];
        f_sel = freq>=ff(1) & freq<=ff(2);
        
        surface(time,freq(f_sel),input_data(f_sel,:)); 
        hold on; xline(0,'--k','LineWidth',lw)
        if i_data~=n_data 
%             colorbar('Ticks', []);
%             colorbar();
        else
            cb = colorbar(h); 
            cb.Position = [position(1)+1.05*position(3) position(2) .01 position(4)*.95];
        end 
        colormap jet ;shading interp; 
        if i_range~=n_range 
            set(gca, 'XTickLabel', []); 
        end 
        xlim([min(time) max(time)]);
        ylim([min(freq(f_sel)) max(freq(f_sel))]);
%         clim(color_limits(i_range,:))
        cmax = max(input(:,f_sel,:),[],'all')*.95;
        cmin = min(input(:,f_sel,:),[],'all')*1.05;
        if(balance_cb)
            clim(max(abs([cmin cmax]))*[-1 1]); %symmetric colorbar for signed values
        else
            clim([cmin cmax])
        end
    end
    xlabel('Time (sec)')
    
    
end

annotation('textbox', [0.1, 0.4, 0.1, 0.1], 'String', 'Frequency (Hz)', 'EdgeColor', 'none', 'Rotation', 90);

