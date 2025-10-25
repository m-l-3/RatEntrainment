function [out,P]=lempel_ziv(signal,num_levels)
med=median(signal);
if num_levels==2
    P=(sign(signal-med)+1)/2;
end
if num_levels==3
    P=signal;
    P(signal>=med+abs(max(signal))/16)=2;
    P(signal<=med-abs(max(signal))/16)=0;
    P(signal>med-abs(max(signal))/16 & signal<med+abs(max(signal))/16)=1;
end
c=2;
terminate=false;
r=1;
i=1;
while terminate==false
    S=P(1:r);
    Q=P(r+1:r+i);
    concat=[S,Q];
    if isempty(strfind(concat(1:(size([S,Q],2)-1)),Q))
        c=c+1;
        r=r+i;
        i=1;
    else
        i=i+1;
    end
    if r+i==size(P,2)
        terminate=true;
    end
end

 out=c*log2(size(P,2))/size(P,2);
end
        