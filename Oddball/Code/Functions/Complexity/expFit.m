function [fitResult, goodnessOfFit] = expFit(x,y) 

y = boxFilter(y, 10);
y = y(1:20);
x = x(1:20);
% Define the custom equation  
% customEq = 'a*exp(-b*x)+c';  
% 
% % Create fittype object  
% ft = fittype(customEq, 'independent', 'x', 'dependent', 'y');  
% 
% % Fit the model to the data  
% opts = fitoptions('Method', 'NonlinearLeastSquares');  
% opts.StartPoint = [.1, .1, .1]; % Initial guesses for d, b, a, c  
% [fitResult, goodnessOfFit] = fit(x', y', ft, opts);  

p = nlinfit(x,y,@f,[1 1 1]);
plot(x,y,'bo',x,f(p,x),'r-')
fitResult.a=p(1);
fitResult.b=p(2);
fitResult.c=p(3);
goodnessOfFit = fitResult;
% Plot the fit  
% plot(fitResult, x, y);  
end

function dataOut = boxFilter(dataIn, fWidth)
% apply 1-D boxcar filter for smoothing
fWidth = fWidth - 1 + mod(fWidth,2); %make sure filter length is odd
dataStart = cumsum(dataIn(1:fWidth-2),2);
dataStart = dataStart(1:2:end) ./ (1:2:(fWidth-2));
dataEnd = cumsum(dataIn(length(dataIn):-1:length(dataIn)-fWidth+3),2);
dataEnd = dataEnd(end:-2:1) ./ (fWidth-2:-2:1);
dataOut = conv(dataIn,ones(fWidth,1)/fWidth,'full');
dataOut = [dataStart,dataOut(fWidth:end-fWidth+1),dataEnd];
end

function y = f(abc,x)
a = abc(1); b = abc(2); c = abc(3);
y = c * x.^(a-1) .* exp(-x/b) / (b^a * gamma(a));
end