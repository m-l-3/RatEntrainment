function plot_3d_powDyn(trials, fband, cfg, figTitle)

    power_dynmic = [];
    for j=1:size(trials, 2)
        power = calc_power_dyn(trials(:,j), cfg, fband, 1);
        power_dynmic = [power_dynmic; power];
    end
    
    figure('WindowState', 'maximized');
    [X,Y] = meshgrid(1:size(power_dynmic, 1), 1:size(power_dynmic, 2));
    surf(X,Y,power_dynmic')
    xlabel('trials')
    ylabel('window idx')
    zlabel('\mu')
    title(figTitle)
    view(120, 40);

end