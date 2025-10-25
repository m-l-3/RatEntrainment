% % MATLAB code to simulate full ERPs with P100, N100, P200, N200, P300, and N300 components, and added noise
% % Also indicating stimulus onset and offset
% 
% % Parameters
% fs = 1000;          % Sampling frequency in Hz
% t = -0.5:1/fs:1;    % Time vector from -500ms to 1000ms
% stim_duration = 0.2; % Stimulus duration in seconds (200ms)
% n_trials = 100;     % Number of trials
% 
% % ERP Components for Stimulus Onset
% onset_p100_amp = 2; % Amplitude of P100 for onset
% onset_n100_amp = -3; % Amplitude of N100 for onset
% onset_p200_amp = 3;  % Amplitude of P200 for onset
% onset_n200_amp = -2; % Amplitude of N200 for onset
% onset_p300_amp = 5;  % Amplitude of P300 for onset
% onset_n300_amp = -4; % Amplitude of N300 for onset
% 
% onset_p100_latency = 0.1; % Latency of P100 (100ms) for onset
% onset_n100_latency = 0.1; % Latency of N100 (200ms) for onset
% onset_p200_latency = 0.2; % Latency of P200 (300ms) for onset
% onset_n200_latency = 0.2; % Latency of N200 (400ms) for onset
% onset_p300_latency = 0.3; % Latency of P300 (500ms) for onset
% onset_n300_latency = 0.3; % Latency of N300 (600ms) for onset
% 
% % ERP Components for Stimulus Offset
% offset_p100_amp = 2; % Amplitude of P100 for offset
% offset_n100_amp = -3; % Amplitude of N100 for offset
% offset_p200_amp = 3;  % Amplitude of P200 for offset
% offset_n200_amp = -2; % Amplitude of N200 for offset
% offset_p300_amp = 5;  % Amplitude of P300 for offset
% offset_n300_amp = -4; % Amplitude of N300 for offset
% 
% offset_p100_latency = stim_duration + 0.1; % Latency of P100 (100ms) for offset
% offset_n100_latency = stim_duration + 0.1; % Latency of N100 (200ms) for offset
% offset_p200_latency = stim_duration + 0.2; % Latency of P200 (300ms) for offset
% offset_n200_latency = stim_duration + 0.2; % Latency of N200 (400ms) for offset
% offset_p300_latency = stim_duration + 0.3; % Latency of P300 (500ms) for offset
% offset_n300_latency = stim_duration + 0.3; % Latency of N300 (600ms) for offset
% 
% % Generate ERP components
% onset_p100 = onset_p100_amp * exp(-((t-onset_p100_latency).^2)/(2*(0.02)^2));
% onset_n100 = onset_n100_amp * exp(-((t-onset_n100_latency).^2)/(2*(0.02)^2));
% onset_p200 = onset_p200_amp * exp(-((t-onset_p200_latency).^2)/(2*(0.03)^2));
% onset_n200 = onset_n200_amp * exp(-((t-onset_n200_latency).^2)/(2*(0.03)^2));
% onset_p300 = onset_p300_amp * exp(-((t-onset_p300_latency).^2)/(2*(0.04)^2));
% onset_n300 = onset_n300_amp * exp(-((t-onset_n300_latency).^2)/(2*(0.04)^2));
% 
% offset_p100 = offset_p100_amp * exp(-((t-offset_p100_latency).^2)/(2*(0.02)^2));
% offset_n100 = offset_n100_amp * exp(-((t-offset_n100_latency).^2)/(2*(0.02)^2));
% offset_p200 = offset_p200_amp * exp(-((t-offset_p200_latency).^2)/(2*(0.03)^2));
% offset_n200 = offset_n200_amp * exp(-((t-offset_n200_latency).^2)/(2*(0.03)^2));
% offset_p300 = offset_p300_amp * exp(-((t-offset_p300_latency).^2)/(2*(0.04)^2));
% offset_n300 = offset_n300_amp * exp(-((t-offset_n300_latency).^2)/(2*(0.04)^2));
% 
% % Combined ERP for stimulus onset and offset
% erp_onset = onset_p100 + onset_n100 + onset_p200 + onset_n200 + onset_p300 + onset_n300;
% erp_offset = offset_p100 + offset_n100 + offset_p200 + offset_n200 + offset_p300 + offset_n300;
% erp_combined = erp_onset + erp_offset;
% 
% % Add noise to simulate multiple trials
% noise_level = 0.5; % Adjust noise level if needed
% erp_trials = repmat(erp_combined, n_trials, 1) + noise_level * randn(n_trials, length(t));
% 
% % Average ERP across trials
% avg_erp = mean(erp_trials, 1);
% 
% % Plot the ERP components and the average ERP
% figure;
% subplot(4, 1, 1);
% plot(t, erp_onset, 'r');
% title('ERP for Stimulus Onset');
% xlabel('Time (s)');
% ylabel('Amplitude');
% hold on;
% xline(0, '--k', 'Stimulus Onset');
% legend('ERP Onset', 'Stimulus Onset');
% hold off;
% 
% subplot(4, 1, 2);
% plot(t, erp_offset, 'b');
% title('ERP for Stimulus Offset');
% xlabel('Time (s)');
% ylabel('Amplitude');
% hold on;
% xline(stim_duration, '--k', 'Stimulus Offset');
% legend('ERP Offset', 'Stimulus Offset');
% hold off;
% 
% subplot(4, 1, 3);
% plot(t, erp_combined, 'k');
% title('Combined ERP for Stimulus Onset and Offset');
% xlabel('Time (s)');
% ylabel('Amplitude');
% hold on;
% xline(0, '--k', 'Stimulus Onset');
% xline(stim_duration, '--k', 'Stimulus Offset');
% legend('Combined ERP', 'Stimulus Onset', 'Stimulus Offset');
% hold off;
% 
% subplot(4, 1, 4);
% plot(t, avg_erp, 'k');
% title('Average ERP across Trials with Noise');
% xlabel('Time (s)');
% ylabel('Amplitude');
% hold on;
% xline(0, '--k', 'Stimulus Onset');
% xline(stim_duration, '--k', 'Stimulus Offset');
% legend('Average ERP', 'Stimulus Onset', 'Stimulus Offset');
% grid on;
% hold off;
% 
% % Highlight the overlap region
% hold on;
% area(t(t >= onset_p300_latency & t <= offset_n100_latency), avg_erp(t >= onset_p300_latency & t <= offset_n100_latency), 'FaceColor', [0.9 0.9 0.9]);


%%

% MATLAB code to simulate full ERPs with P100, N100, P200, N200, P300, and N300 components, added noise, and randomized latencies

% Parameters
fs = 250;          % Sampling frequency in Hz
t = -0.5:1/fs:1;    % Time vector from -500ms to 1000ms
stim_duration = 0.2; % Stimulus duration in seconds (200ms)
n_trials = 100;     % Number of trials
latency_jitter = 0.01; % Jitter range for latencies (10ms)

% Function to add jitter to latency
add_jitter = @(latency) latency + (rand - 0.2) * 2 * latency_jitter;

% ERP Components for Stimulus Onset
onset_p100_amp = 0; % Amplitude of P100 for onset
onset_n100_amp = -2; % Amplitude of N100 for onset
onset_p200_amp = 0;  % Amplitude of P200 for onset
onset_n200_amp = -0; % Amplitude of N200 for onset
onset_p300_amp = 8;  % Amplitude of P300 for onset
onset_n300_amp = -4; % Amplitude of N300 for onset

onset_p100_latency = add_jitter(0.1); % Latency of P100 (100ms) for onset
onset_n100_latency = add_jitter(0.1); % Latency of N100 (200ms) for onset
onset_p200_latency = add_jitter(0.2); % Latency of P200 (300ms) for onset
onset_n200_latency = add_jitter(0.2); % Latency of N200 (400ms) for onset
onset_p300_latency = add_jitter(0.3); % Latency of P300 (500ms) for onset
onset_n300_latency = add_jitter(0.3); % Latency of N300 (600ms) for onset

% ERP Components for Stimulus Offset
offset_p100_amp = 0; % Amplitude of P100 for offset
offset_n100_amp = -3; % Amplitude of N100 for offset
offset_p200_amp = 0;  % Amplitude of P200 for offset
offset_n200_amp = -0; % Amplitude of N200 for offset
offset_p300_amp = 8;  % Amplitude of P300 for offset
offset_n300_amp = -4; % Amplitude of N300 for offset

offset_p100_latency = add_jitter(stim_duration + 0.1); % Latency of P100 (100ms) for offset
offset_n100_latency = add_jitter(stim_duration + 0.1); % Latency of N100 (200ms) for offset
offset_p200_latency = add_jitter(stim_duration + 0.2); % Latency of P200 (300ms) for offset
offset_n200_latency = add_jitter(stim_duration + 0.2); % Latency of N200 (400ms) for offset
offset_p300_latency = add_jitter(stim_duration + 0.3); % Latency of P300 (500ms) for offset
offset_n300_latency = add_jitter(stim_duration + 0.3); % Latency of N300 (600ms) for offset

% Generate ERP components
onset_p100 = onset_p100_amp * exp(-((t-onset_p100_latency).^2)/(2*(0.02)^2));
onset_n100 = onset_n100_amp * exp(-((t-onset_n100_latency).^2)/(2*(0.02)^2));
onset_p200 = onset_p200_amp * exp(-((t-onset_p200_latency).^2)/(2*(0.03)^2));
onset_n200 = onset_n200_amp * exp(-((t-onset_n200_latency).^2)/(2*(0.03)^2));
onset_p300 = onset_p300_amp * exp(-((t-onset_p300_latency).^2)/(2*(0.04)^2));
onset_n300 = onset_n300_amp * exp(-((t-onset_n300_latency).^2)/(2*(0.04)^2));

offset_p100 = offset_p100_amp * exp(-((t-offset_p100_latency).^2)/(2*(0.02)^2));
offset_n100 = offset_n100_amp * exp(-((t-offset_n100_latency).^2)/(2*(0.02)^2));
offset_p200 = offset_p200_amp * exp(-((t-offset_p200_latency).^2)/(2*(0.03)^2));
offset_n200 = offset_n200_amp * exp(-((t-offset_n200_latency).^2)/(2*(0.03)^2));
offset_p300 = offset_p300_amp * exp(-((t-offset_p300_latency).^2)/(2*(0.04)^2));
offset_n300 = offset_n300_amp * exp(-((t-offset_n300_latency).^2)/(2*(0.04)^2));

% Combined ERP for stimulus onset and offset
Sigma = 0.25;
erp_onset = onset_p100 + onset_n100 + onset_p200 + onset_n200 + onset_p300 + onset_n300;
erp_onset = erp_onset + Sigma * randn(size(erp_onset));
erp_offset = offset_p100 + offset_n100 + offset_p200 + offset_n200 + offset_p300 + offset_n300;
erp_offset = erp_offset + Sigma * randn(size(erp_offset));
erp_combined = erp_onset + erp_offset;

lineColors =cbrewer('qual', 'Dark2', 8);

% Plot the ERP components and the average ERP
figure;
subplot(3, 1, 1);
plot(t, erp_onset, 'color', lineColors(1,:),'LineWidth',2); hold on;
title('ERP for Stimulus Onset');
xlabel('Time (s)');
ylabel('Amplitude');
xline(stim_duration, '--k', 'Stimulus Offset');

x_fill = [0 0.2 0.2 0];
y_fill = [2*min(erp_onset) 2*min(erp_onset) 4*max(erp_onset) 4*max(erp_onset)]; % Adjust y limits as needed
ylim([1.2*min(erp_onset) max(erp_onset)])
% Fill the area with a color
fill(x_fill, y_fill, lineColors(8,:), 'FaceAlpha', 0.3); % 'r' is red, 'FaceAlpha' sets transparency

hold on;
xline(0, '--k', 'Stimulus Onset');
% legend('ERP Onset', 'Stimulus Onset');
hold off;
xticks([0, 0.1, 0.3, 0.5]);
xticklabels({'0', 'N100', 'P300'});

subplot(3, 1, 2);
plot(t, erp_offset, 'color', lineColors(2,:),'LineWidth',2);
title('ERP for Stimulus Offset');
xlabel('Time (s)');
ylabel('Amplitude');
hold on;
xline(0, '--k', 'Stimulus Onset');
x_fill = [0 0.2 0.2 0];
y_fill = [2*min(erp_offset) 2*min(erp_offset) 4*max(erp_offset) 4*max(erp_offset)]; % Adjust y limits as needed
ylim([1.2*min(erp_offset) max(erp_offset)])
% Fill the area with a color
fill(x_fill, y_fill, lineColors(8,:), 'FaceAlpha', 0.3); % 'r' is red, 'FaceAlpha' sets transparency

xline(stim_duration, '--k', 'Stimulus Offset');
% legend('ERP Offset', 'Stimulus Offset');
hold off;
xticks([stim_duration, stim_duration+0.1, stim_duration+0.3]);
xticklabels({sprintf('%.1f', stim_duration), 'N100', 'P300'});

subplot(3, 1, 3);
plot(t, erp_combined, 'color', lineColors(3,:),'LineWidth',2);
title('Combined ERP for Stimulus Onset and Offset');
xlabel('Time (s)');
ylabel('Amplitude');
hold on;
xline(0, '--k', 'Stimulus Onset');
x_fill = [0 0.2 0.2 0];
y_fill = [2*min(erp_combined) 2*min(erp_combined) 4*max(erp_combined) 4*max(erp_combined)]; % Adjust y limits as needed
ylim([1.2*min(erp_combined) max(erp_combined)])
% Fill the area with a color
fill(x_fill, y_fill, lineColors(8,:), 'FaceAlpha', 0.3); % 'r' is red, 'FaceAlpha' sets transparency

xline(stim_duration, '--k', 'Stimulus Offset');
% legend('Combined ERP', 'Stimulus Onset', 'Stimulus Offset');
hold off;


set(gcf,'Units','Inches');
set(gcf,'PaperPosition',[0 0 4 7],'PaperUnits','Inches','PaperSize',[4, 7])
% fname = sprintf('bandPowBar_%sWinLen500WinSlip20_beforeAfter_TarStdClnTrial',  ch_labels{1}(iCh));% print(gcf, '-vector', '-dpng', '-r300', 'Synth_ERP.png');
print(gcf,'Synth_ERP.png','-dpng','-r300');clc
% saveas(gcf, 'Synth_ERP.fig')

% xticks([0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, stim_duration, stim_duration+0.1, stim_duration+0.2, stim_duration+0.3, stim_duration+0.4, stim_duration+0.5, stim_duration+0.6]);
% xticklabels({'0', 'P100', 'N100', 'P200', 'N200', 'P300', 'N300', sprintf('%.1f', stim_duration), 'P100', 'N100', 'P200', 'N200', 'P300', 'N300'});

% subplot(4, 1, 4);
% plot(t, avg_erp, 'k');
% title('Average ERP across Trials with Noise');
% xlabel('Time (s)');
% ylabel('Amplitude');
% hold on;
% xline(0, '--k', 'Stimulus Onset');
% xline(stim_duration, '--k', 'Stimulus Offset');
% legend('Average ERP', 'Stimulus Onset', 'Stimulus Offset');
% grid on;
% hold off;
% % xticks([0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, stim_duration, stim_duration+0.1, stim_duration+0.2, stim_duration+0.3, stim_duration+0.4, stim_duration+0.5, stim_duration+0.6]);
% % xticklabels({'0', 'P100', 'N100', 'P200', 'N200', 'P300', 'N300', sprintf('%.1f', stim_duration),



% Highlight the overlap region
% hold on;
% area(t(t >= onset_p300_latency & t <= offset_n100_latency), avg_erp(t >= onset_p300_latency & t <= offset_n100_latency), 'FaceColor', [0.9 0.9 0.9]);
