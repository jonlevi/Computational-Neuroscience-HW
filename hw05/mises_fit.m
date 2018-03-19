function [x_s,y_s] = mises_fit(directions, rates)
f = ezfit(directions, rates, 'a*exp(k*(cosd(x-b)-1))');

results = f.m;


a = results(1);
b = results(2);
k = results(3);
x_s = linspace(0,360,100);
y_s = a*exp(k*(cosd(x_s-b)-1));
end

