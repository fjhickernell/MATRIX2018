%% Why Other Stopping Criteria Don't Work

clearvars

% Test function
f = @(x,a,b) exp(-(b*(x-a)).^2) * ...
   (2*b)/(sqrt(pi)*(erf(a*b) + erf((1-a)*b)));
intF = 1;

R = 16;
n = 64;
a = sqrt(2)/3;
b = 100;
inflate = 5;
appxIntF = zeros(R,1);
M = 1000;
fail = 0;
for m = 1:M
   for r = 1:R
      p = scramble(sobolset(1),'MatousekAffineOwen');
      appxIntF(r) = mean(f(net(p,n),a,b));
   end
   appxIntFmean = mean(appxIntF);
   appxIntFstd = std(appxIntF);
   Err = inflate*appxIntFstd/sqrt(n);
   fail = fail + double(abs(1 - appxIntFmean) > Err);
end
failpercent = fail*100/M


   