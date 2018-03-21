
load('/Users/jonathanlevine/Documents/MATLAB/PHYS585/hw05/HW5_data.mat')

numCells = size(cellArrayOfCells,1);

%part 1

figure;
index = 1;

for cell = 1:numCells
    subplot(5,3,index)
    index = index + 1;
    neuron = cellArrayOfCells{cell,1};
    [directions, rates] = getRates(neuron);
    
    %dummy used to initliazed coherences later
    [~, coherences] = getRocInfo(neuron, 180, 0);
    
    polar(directions, rates);
    title(strcat('Cell # ', num2str(cell)))
    
    subplot(5,3,index+1)
    index = index+1;


    [x_s,y_s] = mises_fit(directions, rates);
    [~,x] = max(y_s);
    preferred_dir = x_s(x);
    plot(x_s,y_s)
    xlabel('Theta (degress)')
    ylabel('Firing Rate (Hz)')
    title(strcat('\Theta Preferred \approx ', num2str(round(preferred_dir)), '°'))
    
    subplot(5,3,index-1)
    index = index+1;
    polar(deg2rad(x_s),y_s)
    
    title(strcat('Von Mises Fit (Same as to the Right but Polar'))

    
    
end %cell loop

%part 2
figure;
positive_dirs = [180, 315, 180, 180, 200];
negative_dirs = [0, 135, 0, 0, 20];

    aucs = NaN(numCells, length(coherences));

for cell = 1:numCells
    neuron = cellArrayOfCells{cell,2};
    [fr_hists, coherences] = getRocInfo(neuron, positive_dirs(cell), negative_dirs(cell));
    


    subplot_tight(3,2,cell)
    for c = 1:length(coherences)
        preferred_dist = fr_hists(c, 1, :);
        preferred_dist = preferred_dist(isfinite(preferred_dist));
        opposite_dist = fr_hists(c, 2, :);
        opposite_dist = opposite_dist(isfinite(opposite_dist));

        a = rocN(preferred_dist, opposite_dist, 100, 1);
        aucs(cell,c) = a;
        hold all;
    end
    

    plot(0:.1:1, 0:.1:1, 'k--')
    labels = cellstr(strcat(num2str(coherences), ' % Coherence'));
    title(strcat('ROC Curve for Cell # ', num2str(cell)))
    xlabel('\alpha')
    ylabel('\beta')


    if (cell==5)
        legend(labels)
    end
    
end

figure;
for cell = 1:numCells 
    subplot(3,2,cell)
    areas = aucs(cell, :);
    
    hold on;
    [x_s,y_s] = weibull_fit(coherences/100, areas);
    semilogx(x_s,y_s, 'r--')
    
    neuron = cellArrayOfCells{cell,2};
    [~, pct_correct] = getPsychometric(neuron);
    [x_s2,y_s2] = weibull_fit(coherences/100, pct_correct);
    
    semilogx(x_s2,y_s2, 'b--')
    semilogx(coherences/100, pct_correct, 'bo')
    semilogx(coherences/100, areas, 'ro')
    legend('Neuronal Data', 'Behavioral Data')

    if (cell==5 || cell==4)
        xlabel('Coherence Fraction')
    else
        set(gca,'xticklabel',[])
    end
    ylabel('Fraction Correct (AUC)')
    title(strcat('Random Dot Motion Discrimination for Cell # ', num2str(cell)))
    
end




    