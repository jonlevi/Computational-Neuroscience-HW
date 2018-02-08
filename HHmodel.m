%Jonathan Levine
% BBB 585 HW 2
%function for HH model of Action Potential
%input args: external current (constant or vectorized), t_final (starts at
%t=1), Resting Potential in mV, Capcacitance in mF/mm^2, gbarLeak, E_Leak, 
% gbarK, E_K, gbarNa, boolean for inactivation of Na chans, label for plot

%NOTE: external current only starts after 5 ms have passed. Used to establish
%baseline for comparison

function [t,V] = HHmodel(Iext, tf, Vrest, c_m, A, maxG_L, E_L, maxG_K,...
                    E_K, maxG_Na, E_Na, nonInactivating, label)
                
                
    %alpha and beta functions            
    alpha_n = @(x) 1000*(0.01*(x + 55))/(1-exp(-0.1*(x+55)));
    alpha_m = @(x) 1000*(0.1*(x + 40))/(1-exp(-0.1*(x+40)));
    alpha_h = @(x) 1000*(0.07 * exp(-0.05*(x + 65)));
    
    beta_n = @(x) 1000*(0.125 * exp(-0.0125*(x + 65)));
    beta_m = @(x) 1000*(4 * exp(-0.0556*(x + 65)));
    beta_h = @(x) 1000*(1/(1+exp(-0.1*(x+35))));
    
    dt = .00001; %small time differential for Euler's Approximation
    t = 1:dt:tf;
    
    %Take care of constant current, vectorize
    if (length(Iext)==1)
        Iext = Iext*ones(size(t));
    end
    
     %initialize vectors
    V = NaN(1, length(t));
    n = zeros(1, length(t));
    h = zeros(1, length(t));
    m = zeros(1, length(t));
    i_m = zeros(1, length(t));
    
    %initial conditions
    V(1) = Vrest;
    %use steady state conditions for initials
    n(1) = alpha_n(Vrest)/(alpha_n(Vrest)+beta_n(Vrest));
    m(1) = alpha_m(Vrest)/(alpha_m(Vrest)+beta_m(Vrest));
    h(1) = alpha_h(Vrest)/(alpha_h(Vrest)+beta_h(Vrest));
    i_m(1) = (maxG_L*(V(1)-E_L) + (maxG_K*(n(1)^4) * (V(1)-E_K)) ...
                    + (maxG_Na * (m(1)^3) * h(1) * (V(1)-E_Na)));
                
 
    %time loop 
    for i = 2:length(t)
        
        %only turn current on after 5 ms
        if (t(i)<1.005)
            I_e = 0;
        else 
            I_e = Iext(i-1);
        end
        
        %voltage differential
        dv = dt*(1/c_m * ((I_e/A) - i_m(i-1)));
        V(i) = V(i-1) + dv;
        i_leak = maxG_L*(V(i)-E_L);
        
        
        %n differential
        dn = (alpha_n(V(i))*(1-n(i-1)) - (beta_n(V(i))*n(i-1)))*dt;
        n(i) = n(i-1) + dn;
        
        %full K current based on n^4 and V
        i_K = maxG_K*(n(i)^4) * (V(i)-E_K);
        
        %m differential
        dm = (alpha_m(V(i))*(1-m(i-1)) - (beta_m(V(i))*m(i-1)))*dt;
        m(i) = m(i-1) + dm;
       
        %h differential
        dh = (alpha_h(V(i))*(1-h(i-1)) - (beta_h(V(i))*h(i-1)))*dt;
        h(i) = h(i-1) + dh;
        
        %special case for persistent sodium channels m^4
        if (nonInactivating)
            
            i_Na = maxG_Na * (m(i)^4) * (V(i)-E_Na);
            
        else
            %normal case for m^3h
            i_Na = maxG_Na * (m(i)^3) * h(i) * (V(i)-E_Na);
        end

        %sodium current based
        i_m(i) = i_leak + i_K + i_Na;

    end %time loop end
    
    
    %plotting....
    
    figure;
    
    
    subplot(5,1,1);
    hold on;
    plot([1.005,1.005], [-100, 50], 'k--');
    ylim([-80,50])
    plot(t,V)
    
    legend('I_{ext} On')
    ylabel('Voltage (mV)');
    title(label);
    
    subplot(5,1,2);
    plot(t,i_m);
    ylabel('Current (\muA/ mm^2)');
    ylim([-5 5])
    title('I_m (t)');
    
    subplot(5,1,3);
    plot(t, n)
    title('n(t)');
    ylim([0,1])

    
    subplot(5,1,4);
    plot(t, m);
    title('m(t)');
    ylim([0,1])

    
    subplot(5,1,5);
    plot(t, h);
    title('h(t)');
    xlabel('Time (s)')
    ylim([0,1])
    

end
    
    
                
                
                