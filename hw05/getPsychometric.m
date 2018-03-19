function [coherences, pct_correct] = getPsychometric(neuron)


    trial_data = neuron.ecodes.data;
    data_coherences = trial_data(:,4);
    coherences = unique(data_coherences);


    data_choices = trial_data(:,6);
    pct_correct = NaN(length(coherences), 1);
    
    for c = 1:length(coherences)
        distribution = data_choices(data_coherences==coherences(c));
        pct_correct(c) = nanmean(distribution);
    end
    
end