path = 'D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Entrainment\Data\Visual_TrialBased\';

list = dir(path);

for i=3:length(list)
    rat = list(i);
    list_day = dir([path rat.name]);
    for j=3:length(list_day)
        day = list_day(j);
        add = [path  rat.name '\' day.name '\'];
%         dir(string(add)+"*MonitorOn.mat")
        delete(string(add)+"*MonitorON.mat");
    end
end
