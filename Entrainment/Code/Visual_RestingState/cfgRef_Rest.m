clear
% close all
clc

addpath('D:\Documents\SUT Ph.D\Research\NBIC\Codes\RabieiCodeSnippet')
addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")
addpath(genpath("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Entrainment\Code\Functions"))
% eeglab
%%

Name = "Rat" + string([5:9 11 12 13 14])';
nRat = numel(Name);
Channel = {["mPFC"; "CA1"; "NACC"; "LGN"];...
           ["LGN"; "CA1"; "NACC"; "mPFC"];...
           ["CA1"; "LP"; "CPu"; "mPFC"];...
           ["CA1"; "LP"; "CPu"; "mPFC"];...
           ["CA1"; "LP"; "CPu"; "mPFC"];...
           ["CA1"; "LP"; "CPu"; "mPFC"];...
           ["CA1"; "LP"; "CPu"; "mPFC"];...
           ["CA1"; "LP"; "CPu"; "mPFC"];...
           ["CA1"; "LP"; "CPu"; "mPFC"]};
days = [1 5 10 20 30];
Session = repmat({"Day" + string(days)'}, nRat,1);
nSession = numel(days);
Dates = {["020911"; "020915"; "020920"; ""; ""];...
         ["021118"; "021122"; "021127"; ""; ""];...
         ["021205"; "021209"; "021214"; "021227"; ""];...
         ["030130"; "030203"; "030208"; "030222"; ""];...
         ["030226"; "030230"; "030304"; "030411"; "030427"];...
         ["030318"; "030322"; "030327"; "030411"; "030427"];...
         ["030318"; "030322"; "030327"; "030411"; "030428"];...
         ["030419"; "030423"; "030428"; "030513"; "030525"];...
         ["030419"; "030424"; "030428"; "030513"; "030525"]};

blocks = ["First_Rest_MonitorON", "Last_Rest_MonitorON"];
nBlock = numel(blocks);
Blocks = {{blocks; blocks; blocks; []; []};...
         {blocks; blocks; blocks; []; []};...
         {blocks; blocks; blocks; blocks; []};...
         {blocks; blocks; blocks; blocks; {}};...
         {blocks; blocks; blocks; blocks; "First_Rest_MonitorON"};...
         {blocks; blocks; blocks; blocks; blocks};...
         {blocks; blocks; blocks; blocks; blocks};...
         {blocks; blocks; blocks; blocks; blocks};...
         {blocks; blocks; blocks; blocks; blocks}};


T = table(Name,Session,Dates,Blocks,Channel);
path_record = 'D:\Documents\SUT Ph.D\Research\NBIC\Data\';
path_dataset = 'D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Entrainment\Data\Visual_RestingState\';
path_results = 'D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Entrainment\Results\Visual_RestingState\';

%%
cfg.T = T;

cfg.Fs_main = 2000;
cfg.Fs_down = 250;

cfg.is_downSamlpe = true;
% cfg.is_baseLine = true;
cfg.is_sigZscore = false;
cfg.is_windowed = true;
cfg.is_winZscore = true;
cfg.winLen = 1; %1 for pac
cfg.winSlip = 0.5; %0.5 for pac
cfg.Duration = 300;
cfg.nWin = round((cfg.Duration-cfg.winLen)/cfg.winSlip)+1;
cfg.filBand = [1 100];
cfg.cleanTh = 4; % zscored
cfg.asr = 20;
cfg.nCh = 4;
cfg.nRat = nRat;
cfg.nSession = nSession;
cfg.nBlock = nBlock;


ratExcluded = ["Rat5", "Rat6"];
cfg.ratExcluded = ratExcluded;

if(cfg.is_downSamlpe)
    cfg.Fs = cfg.Fs_down;
else
    cfg.Fs = cfg.Fs_main;
end

