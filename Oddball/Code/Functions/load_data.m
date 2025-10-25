function [data, fs, rmv_trials, norm_factor, sequence] = load_data(rat_no, block_no, date, is_novelty, file_dir)
    path = 'D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Dataset\';
    if nargin < 5
        file_dir = strcat(path,'Data-Rat', ...
                           rat_no, '-Block', block_no, ...
                          '-', date, '-novelty', is_novelty);
        
        baseline_file_dir = strcat(path,'Data-Rat', ...
                               rat_no, '-Baseline-', date);
    end
    
    rejected_trials_fname = strcat(file_dir, '\rejected_trials.txt');
    if isfile(rejected_trials_fname)
        rmv_trials = importdata(strcat(file_dir, '\rejected_trials.txt'));
        rmv_trials = convertStringToNumbersArray(cell2mat(rmv_trials));
    else
        rmv_trials = [];
    end
    
    data = load(strcat(file_dir, '\MatData\sessionData.mat'));
    fs = data.SampleRate;
    
    if isfile(strcat(baseline_file_dir, '\MatData\sessionData.mat'))
        baseline_data = load(strcat(baseline_file_dir, '\MatData\sessionData.mat'));
        b_signal = baseline_data.channelData';

        norm_factor = [];
        for i=1:size(b_signal, 1)
            norm_factor = [norm_factor; sqrt(bandpower(b_signal(i,:), fs, [150, 200]));];
        end
    else
        norm_factor = zeros(1, 4);
    end

    %% load LOG of stimulus sequence
    files = dir(strcat(file_dir,'/*.mat')); % Adjust the path and file type as needed
    if length(files)>1
        error('more than one sequence exist')
    end
    if ~isempty(files)
        sequence = load(fullfile(files(1).folder, files(1).name)); % Read the first file found
        sequence = sequence.LOG';
    else
        sequence = [];
    end
    
    
end