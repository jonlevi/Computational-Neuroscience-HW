function [fr_hists, coherences] = getRocInfo(neuron, preferred, opposite)

    trial_spiking = neuron.spikes;
    trial_data = neuron.ecodes.data;



    nTrials = size(trial_data,1);

    data_directions = trial_data(:,3);
    directions = [preferred; opposite];
    data_coherences = trial_data(:,4);
    coherences = unique(data_coherences);

    % coherence x direction x trial
    fr_hists = nan(length(coherences), length(directions), 500);




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



    for c = 1:length(coherences)
        for d = 1:length(directions)
        distribution = rates(data_coherences==coherences(c) & (data_directions==directions(d)));
        padded_dist = padarray(distribution,500-length(distribution), NaN, 'post');
        fr_hists(c,d,:) = padded_dist;

        end

    end 
end