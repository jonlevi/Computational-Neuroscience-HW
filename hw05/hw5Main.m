
load('/Users/jonathanlevine/Documents/MATLAB/PHYS585/hw05/HW5_data.mat')

numCells = size(cellArrayOfCells,1);

%part 1

figure;

for cell = 1:numCells
    subplot(5,2,2*(cell-1)+1)
    neuron = cellArrayOfCells{cell,1};
    [directions, rates] = getRates(neuron);
    polar(directions, rates);
    title(strcat('Cell # ', num2str(cell)))
    
    subplot(5,2,2*(cell-1)+2)


    [x_s,y_s] = mises_fit(directions, rates);
    [~,x] = max(y_s);
    preferred_dir = x_s(x);
    plot(x_s,y_s)
    xlabel('Theta (degress)')
    ylabel('Firing Rate (Hz)')
    title(strcat('\Theta Preferred \approx ', num2str(round(preferred_dir)), '°'))

    
    
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
    semilogx(coherences/100, areas)
    hold on;
    [x_s,y_s] = weibull_fit(coherences/100, areas);
    semilogx(x_s,y_s, 'r--')
    
    if(cell==5)
        legend('data', 'Weibull Function')
    end

    if (cell==5 || cell==4)
        xlabel('Coherence Fraction')
    else
        set(gca,'xticklabel',[])
    end
    ylabel('Fraction Correct (AUC)')
    title(strcat('Neurometric Function for Cell # ', num2str(cell)))
    
end




    