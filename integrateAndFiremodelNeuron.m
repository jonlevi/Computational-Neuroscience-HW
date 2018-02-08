%function for integrate and fire model
%input args: resting potential, threshold voltgage, time constant, 
% membrane resistance, external current (either a constant or a function of
% the same sampling frequency as 1:.001:tf), true/false for plotting, and
% label for plotting, true/false for adding noise (bonus)
% returns the firing rate of model in Hz for given params
function [firing_rate] = integrateAndFiremodelNeuron(Vrest, threshold, ...
                    tau, Rm, Iext, tf, p, label, noise)

    count = 0; %spike count
    dt = .001; %small time differential for diff Eq solving
    t = 1:dt:tf;
    
    V = NaN(1, length(t)); %initialize V(t)
    V(1) = Vrest; %V(start) = Vrest
    
    %Take care of constant current, vectorize
    if (length(Iext)==1)
        Iext = Iext*ones(size(t));
    end
    
    %plotting option open figure
    if (p==1)
        figure;
        hold on;
    end
    
    %Diff Eq simulation loop
    for i = 2:length(t)
        %Equation #1
        dv = (((Vrest-V(i-1))+(Rm*Iext(i)))/tau)*dt;
        
        if (noise==1)
            V(i-1) = V(i-1) + (4*10^(-3) * randn());
        end
        %check for threshold
        if (V(i-1)+ dv >= threshold)
            V(i) = Vrest; %reset voltage
            count = count+1; %Spike
            
            %Plot spike
            if (p==1)
                plot([t(i),t(i)],[threshold, .055], 'k-');
            end
            
        else
            V(i) = V(i-1)+dv;
        end
    end

    %plot V(t)
    if (p==1)
        plot(t,V, 'k');
        ylabel('Volts (V)');
        xlabel('Time (s)');
        title({'Integrate and Fire Model Neuron:' ,label})
    end
    
    %calculate firing rate
    count = count*1.0;
    firing_rate = count/(tf-1); %in sp/s or Hz
    
end