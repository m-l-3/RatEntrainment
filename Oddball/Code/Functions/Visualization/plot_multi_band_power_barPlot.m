function plot_multi_band_power_barPlot (input,time,freq,freq_ranges,titles,leg)


n_range = size(freq_ranges,1);
n_data = size(input,2);
n_holdOn = size(input,1);

is_connectLine = 1;
colors = cbrewer('seq', 'Blues', 4);
n = 7;
lineColors = 0.7*ones(n, 4); % Initialize an array to hold the colors
for i = 1:n
    hue = (i - 1) / n; % Evenly spaced hues
    rgb = hsv2rgb([hue, 1, 1]); % Convert HSV to RGB
    lineColors(i, 1:3) = rgb; % Convert to 0-255 range
end

xticks_label = {'Before', 'After 10', 'After 20', 'After 30'};

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
        
        
        input_data = input{1,i_data};
        bp_bef = squeeze(mean(input_data(:,:,f_sel),[2 3]));

        input_data = input{2,i_data};
        bp_a10 = squeeze(mean(input_data(:,:,f_sel),[2 3]));

        input_data = input{3,i_data};
        bp_a20 = squeeze(mean(input_data(:,:,f_sel),[2 3]));

        input_data = input{4,i_data};
        bp_a30 = squeeze(mean(input_data(:,:,f_sel),[2 3]));
   

        [legendHandles, legendLabels] = plotDataWithErrorBars(is_connectLine, colors, lineColors, xticks_label, ...
                                                                bp_bef, bp_a10, bp_a20, bp_a30);

        if i_data==n_data && i_range==2
            legend(legendHandles, legendLabels, 'Position', [position(1)+position(3) position(2) 0.1 0.1], 'Units', 'normalized');
        end 

        if i_range~=n_range 
            set(gca, 'XTickLabel', []); 
        end 

        if i_data==1
            ylabel(string(freq_ranges(i_range,1))+'-'+string(freq_ranges(i_range,2))) 
        end 

        if i_data==n_data && i_range==1
            legend(leg, 'Position', [position(1)+position(3) position(2) 0.1 0.1]);
        end 

        

              
    end
    
    
end
% ylabel
annotation('textbox', [0.06, 0.4, 0.1, 0.1], 'String', 'Frequency (Hz)', 'EdgeColor', 'none', 'Rotation', 90);

