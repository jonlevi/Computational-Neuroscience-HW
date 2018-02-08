%Jonathan Levine - PHYS 585 HW #1

%Code to input and plot most of the problems for the hw
%relies on integrateAndFiremodelNeuron.m


%This code (if integrateAndFiremodelNeuron.m is on the MATLAB path) will produce
%all of the figures submitted on the PDF for hw1



%initliaze some constants
Vrest = -.065;
threshold = -.050;
tau = .010;
Rm = 10^7;
Iext = 1.60*(10^(-9));
tf = 2;

%Problem #2: first plot with constant current input
integrateAndFiremodelNeuron(Vrest, threshold, tau, Rm, Iext, tf, ...
            true, 'Iext = 1.6 nA', false);


%Problem # 3: plotting firing rate as function of current
currents = 10^(-9)*(1:.25:4); %current ranges
firing_rates = NaN(1, length(currents));
for i = 1:length(currents)
    firing_rates(i) = integrateAndFiremodelNeuron(Vrest, threshold, tau, ...
                Rm, currents(i), tf, false, '', false);
end
%plotting...
figure;
plot([1.5*(10^-9), 1.5*(10^-9)], [0, 200], 'k--');
legend('Approximate Threshold for Iext to produce AP');
hold on;
plot(currents, firing_rates);
xlabel('Iext (A)');
ylabel('Sp/s (Hz)');
title('Firing Rate as a Function of constant Input Current');

%Problem #4: simulation with different Iext(t) functions

%Periodic Fuction: sin(6pit)
X = 1:.001:tf;
currentFunc1 = (2 * 10^-9)*sin(6*pi*X);
integrateAndFiremodelNeuron(Vrest, threshold, tau, Rm, ...
        currentFunc1, tf, true, 'Iext = 2 nA * sin(6 \pi t)', false);

%Gaussian Function: Normal Random Distribution
currentFunc2 = normrnd(1.25*(10^-9), 1*(10^-9), size(X));
integrateAndFiremodelNeuron(Vrest, threshold, tau, Rm, ...
        currentFunc2, tf, true, ...
        'Iext = Normal Distribution (\mu = 1.25 nA, \sigma = 1 nA)', false);

%Downward Facing Parabola
currentFunc3 = 2*10^-9 + (-(3*(10^(-9))) * power(X-1.5,2));
integrateAndFiremodelNeuron(Vrest, threshold, tau, Rm, currentFunc3, ...
            tf, true, 'I(t) = 2nA - 3nA*(t-1.5)^2', false);
        


%Bonus: constant current but with random gaussian noise
integrateAndFiremodelNeuron(Vrest, threshold, tau, Rm, Iext, tf, ...
            true, 'Constant Iext; with V(t) +/- Guassian noise', true);

% integrateAndFiremodelNeuron(Vrest, threshold, 2*tau, Rm, 0, 1.2, ...
%             true, 'trying it out 2', false);