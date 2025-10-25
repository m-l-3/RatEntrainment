% clear
clc

addpath('D:\Documents\SUT Ph.D\Research\NBIC\Codes\RabieiCodeSnippet')
addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")
addpath(genpath("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Entrainment\Code\Functions"))

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

blocks = ["Visual_120tr(1)", "Visual_120tr(2)"];
nBlock = numel(blocks);
Blocks = {{blocks; blocks; blocks; []; []};...
         {blocks; blocks; blocks; []; []};...
         {"Visual_120tr(1)"; blocks; blocks; blocks; []};...
         {blocks; blocks; blocks; blocks; {}};...
         {blocks; blocks; blocks; blocks; "Visual_120tr(1)"};...
         {blocks; blocks; blocks; blocks; blocks};...
         {blocks; blocks; blocks; blocks; blocks};...
         {blocks; blocks; blocks; blocks; blocks};...
         {blocks; blocks; blocks; blocks; blocks}};


T = table(Name,Session,Dates,Blocks,Channel);
path_record = 'D:\Documents\SUT Ph.D\Research\NBIC\Data\';
path_dataset = 'D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Entrainment\Data\Visual_TrialBased\';
path_results = 'D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Entrainment\Results\Visual_TrialBased\';

%%
cfg.T = T;

cfg.Fs_main = 2000;
cfg.Fs_down = 250;

cfg.is_downSamlpe = true;
cfg.is_baseLine = true;
cfg.is_trZscore = true;
cfg.is_sigZscore = false;
cfg.epoch = [-1 3];
cfg.filBand = [1 100];
cfg.asr = 20;
cfg.nTrial = 120;
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

