function [S,t,f]=mypmtm(data,movingwin,params)

Fs = params.Fs;
TW = params.tapers(1);
ntp = params.tapers(2);

twin = movingwin(1);
tslip = movingwin(2);
[N,dim2]=size(data);
Nwin = round(twin*Fs);
Nslip = round(tslip*Fs);

winstart=1:Nslip:N-Nwin+1;
nWin=length(winstart);
f=getfgrid(Fs,Nwin,[0 Fs/2]);

winmid=winstart+round(Nwin/2);
t=winmid/Fs;

S = NaN(nWin, length(f), dim2);
if(~any(isnan(data)))

    for iWin=1:nWin
        indx=winstart(iWin):winstart(iWin)+Nwin-1;
        datawin = data(indx,:);
        [S(iWin,:,:), f] = pmtm(datawin, {TW,ntp}, Nwin, Fs);  
        
    end
end

