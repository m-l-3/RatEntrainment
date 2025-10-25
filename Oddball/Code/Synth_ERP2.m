% Sampling parameters
fs = 500; % sampling rate in Hz
t = 0:1/fs:1; % time vector from 0 to 1 second

% Define ERP components for the first signal: [latency(ms) amplitude width]
components1 = [
    100, 3, 20;   % P1 component at 100 ms
    150, -5, 30;  % N1 component at 150 ms
    200, 4, 20;   % P2 component at 200 ms
    300, 7, 50;   % P3 (P300) component at 300 ms
];

% Define ERP components for the second signal with 200 ms delay but same sign
components2 = [
    300, 3, 20;   % Same P1 component but delayed at 300 ms
    350, -5, 30;  % Same N1 component but delayed at 350 ms
    400, 4, 20;   % Same P2 component but delayed at 400 ms
    500, 7, 50;   % Same P3 component but delayed at 500 ms
];

% Initialize ERP signals
erp_signal1 = zeros(size(t));
erp_signal2 = zeros(size(t));

% Generate the first ERP signal
for i = 1:size(components1, 1)
    latency = components1(i, 1) / 1000;   % latency in seconds
    amplitude = components1(i, 2);
    width = components1(i, 3) / 1000;     % width in seconds
    
    % Generate Gaussian component and add it to the ERP signal
    component = amplitude * exp(-((t - latency).^2) / (2 * width^2));
    erp_signal1 = erp_signal1 + component;
end

% Generate the second ERP signal with the same sign as the first
for i = 1:size(components2, 1)
    latency = components2(i, 1) / 1000;   % latency in seconds
    amplitude = components2(i, 2);
    width = components2(i, 3) / 1000;     % width in seconds
    
    % Generate Gaussian component and add it to the ERP signal
    component = amplitude * exp(-((t - latency).^2) / (2 * width^2));
    erp_signal2 = erp_signal2 + component;
end

% Add random noise to simulate EEG background noise
noise_level = 0.5;
erp_signal1 = erp_signal1 + noise_level * randn(size(t));
erp_signal2 = erp_signal2 + noise_level * randn(size(t));

% Calculate the average ERP signal
erp_avg = (erp_signal1 + erp_signal2) / 2;

% Plot both ERP signals and their average
figure;
plot(t * 1000, erp_signal1, 'b', 'LineWidth', 1.5); hold on; % ERP1 in blue
plot(t * 1000, erp_signal2, 'r', 'LineWidth', 1.5); % ERP2 in red
plot(t * 1000, erp_avg, 'k', 'LineWidth', 2); % Average in black

xlabel('Time (ms)');
ylabel('Amplitude (uV)');
title('Simulated ERP Signals and Their Average (Same Sign)');
legend({'ERP 1', 'ERP 2', 'Average ERP'}, 'Location', 'Best');
grid on;
