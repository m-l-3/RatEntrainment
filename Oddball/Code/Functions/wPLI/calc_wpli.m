function [wpli] = calc_wpli(ch1_data, ch2_data)
% trials should be on first dimension.

    cross = ch1_data.*conj(ch2_data);
    wpli = abs(mean(imag(cross),1,'omitnan'))./mean(abs(imag(cross)),1,'omitnan');
    wpli = squeeze(wpli);
end
