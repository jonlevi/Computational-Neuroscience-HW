function [x_s,y_s] = weibull_fit(x_in, y)
f = ezfit(x_in, y, '1 - 0.5* exp(-1* (x/alpha)^beta)');

results = f.m;


alpha = results(1);
beta = results(2);
x_s = linspace(0, 15,1000);
y_s = 1 - 0.5* exp(-1* (x_s/alpha).^beta);
end