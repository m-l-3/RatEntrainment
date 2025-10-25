function [peak, latency] = proc_ERP(data, ERP_feature)

    if ERP_feature == "P300"
        search_window = 189:226;  
        sign = 1;
    elseif ERP_feature == "N100"
%         search_window = 170:200;
        search_window = 212:250;
        sign = -1;
    end
    
    peak = [];
    latency = [];
    for i=1:size(data,2)
%         [a, b] = findpeaks(After10days_all_ERPs(2,:,i), 'MinPeakProminence',0.98 * max(After10days_all_ERPs(2,:,i)));
        [a, b] = max(sign * data(search_window,i));
        peak = [peak, sign*a];
        latency = [latency, b+search_window(1)];
    end

end