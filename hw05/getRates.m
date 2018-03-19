 function [directions, dir_rates] =getRates(neuron)
    trial_spiking = neuron.spikes;
    trial_data = neuron.ecodes.data;



    nTrials = size(trial_data,1);


    rates = NaN(nTrials,1);

    for i = 1:nTrials
        data = trial_data(i, :);
        spikes = trial_spiking{i};
        on = data(1);
        off = data(2);
        duration = (off-on)/1000;
        rate =  length(find(spikes<off & spikes>on))/(duration);
        rates(i) = rate;
    end

    data_directions = trial_data(:,3);

    directions = unique(data_directions);
    dir_rates = NaN(size(directions));

    for d = 1:length(directions)

        dir_rates(d) = mean(rates(data_directions==directions(d)));

    end 

    

end