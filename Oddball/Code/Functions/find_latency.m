function out = find_latency(data, cfg, sgn)

    out = cell(1,4);
    for ch_i=1:size(data,1)
       
        new_data = permute(data, [3, 1, 2]);
        subjectNaN = all(isnan(new_data(:,ch_i,:)), [2, 3]);
        cleaned_data = new_data(~subjectNaN, :, :);

        [res,lat_cfgNew] = latency(cfg,cleaned_data(:,ch_i,:),sgn);
        
        max_Peaks = NaN(1, length(res.peakLat));
        for row = 1:length(res.peakLat)
            max_Peaks(row) = new_data(row, ch_i, res.peakLat(row));
        end
        
        res.maxPeaks = max_Peaks;
        out{ch_i} = res;
        
    end

end