%Jonathan Levine
%BIBB 585 HW Number 2
%Running this script produces all of the figures in Part 1 of the HW

%Depends on HHModel.m on current path


%Initialize some stuff....

%define alpha and beta functions
alpha_n = @(x) (0.01*(x + 55))/(1-exp(-0.1*(x+55)));
alpha_m = @(x) (0.1*(x + 40))/(1-exp(-0.1*(x+40)));
alpha_h = @(x) 0.07 * exp(-0.05*(x + 65));

beta_n = @(x) 0.125 * exp(-0.0125*(x + 65));
beta_m = @(x) 4 * exp(-0.0556*(x + 65));
beta_h = @(x) 1/(1+exp(-0.1*(x+35)));

%initialize dependent variables
volts = -100:1:0;
alphaN = NaN(1, length(volts));
betaN = NaN(1, length(volts));
alphaM = NaN(1, length(volts));
betaM = NaN(1, length(volts));
alphaH = NaN(1, length(volts));
betaH = NaN(1, length(volts));


n_inf = NaN(1,length(volts));
m_inf = NaN(1,length(volts));
h_inf = NaN(1,length(volts));

tau_n = NaN(1, length(volts));
tau_m = NaN(1,length(volts));
tau_h = NaN(1,length(volts));


%calculate dependent variables
for i = 1:length(volts)
    if (volts(i)==-55)
        volts(i) = -55.0001;
    end
    
    if(volts(i) == -40)
        volts(i) = -40.0001;
    end
    alphaN(i) = alpha_n(volts(i));
    betaN(i) = beta_n(volts(i));
    n_inf(i) = alphaN(i)/(alphaN(i)+betaN(i));
    tau_n(i) = 1/((alphaN(i)+betaN(i)));
    
    alphaM(i) = alpha_m(volts(i));
    betaM(i) = beta_m(volts(i));
    m_inf(i) = alphaM(i)/(alphaM(i)+betaM(i));
    tau_m(i) = 1/((alphaM(i)+betaM(i)));
    
    alphaH(i) = alpha_h(volts(i));
    betaH(i) = beta_h(volts(i));
    h_inf(i) = alphaH(i)/(alphaH(i)+betaH(i));
    tau_h(i) = 1/((alphaH(i)+betaH(i)));
    
end


%plot results

%5.9
figure;
subplot(1,3,1);
plot(volts, alphaN, 'r');
hold on;
plot(volts, betaN, 'k');
xlabel('V (mV)');
ylabel('1/ms');
legend('\alpha_n(V)', '\beta_n(V)');
title('\alpha_n(V) and \beta_n(V)');
subplot(1,3,2);
plot(volts, n_inf, 'k');
xlabel('V (mV)');
ylabel('n_\infty');
title('n_\infty');
subplot(1,3,3);
plot(volts, tau_n, 'k');
xlabel('V (mV)');
ylabel('\tau_n (ms)');
title('tau_n(V)');

%5.10 Left
figure;
plot(volts, n_inf);
hold on;
plot(volts, m_inf);
plot(volts, h_inf);
title('Steady State Activation/Inactivation');
legend('n_\infty', 'm_\infty', 'h_\infty')
xlabel('V (mV)');

%5.10 Right
figure;
plot(volts, tau_n);
hold on;
plot(volts, tau_m);
plot(volts, tau_h);
legend('\tau_n', '\tau_m', '\tau_h')
xlabel('V (mV)');
ylabel('\tau (ms)');
title('Voltage-Dependent Time Constants');


%HH MODEL TIME


%define some constants
maxG_L = .003; %in mS/mm^2
maxG_K = 0.36;
maxG_Na = 1.2;

E_L = -54.387; %in mV
E_K = -77;
E_Na = 50;
Vrest = -65;
A = .1; %in mm^2
c_m = 10*10^-6; %in mF/mm^2

dt = .00001; %small time differential for diff Eq solving
tf = 1.015; %time in seconds!!!
t = 1:dt:tf;
Iext =  20e-3 * ones(size(t)); %current in mA I think...


%Question Number 5
[t,v] = HHmodel(Iext, tf, Vrest, c_m, A, maxG_L, E_L, maxG_K,...
                     E_K, maxG_Na, E_Na, 0, 'V(t)');
                 
%6: Sodium Channel Blocking                 
[t2,v2] = HHmodel(Iext, tf, Vrest, c_m, A, maxG_L, E_L, maxG_K,...
                     E_K, maxG_Na/10, E_Na, 0, 'With Sodium Channel Inihibtion');
         
%6: Pottasium Channel Blocking                 
[t3,v3] = HHmodel(Iext, tf, Vrest, c_m, A, maxG_L, E_L, maxG_K/10,...
                     E_K, maxG_Na, E_Na, 0, 'With Pottasium Channel Inihibtion');
                 
%6: non inactivating channels               
[t4,v4] = HHmodel(Iext, tf, Vrest, c_m, A, maxG_L, E_L, maxG_K,...
                     E_K, maxG_Na, E_Na, 1, 'With Non-Inactivating Sodium Channels');          
                 
