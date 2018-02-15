%Jonathan Levine
%Code for HW 3 in PHYS 585

data = load('orientation_tuning_data.mat');

Vm = data.Vm;

%part a
figure;
plot(linspace(1,10,10000), Vm(1:10000));
title('First 10 Seconds of Vm Trace');
xlabel('Time (s)');
ylabel('Vm (mV)')


%part b

%voltages above -40 mV
spikeTimes = find(Vm>-40);

%only need 1 count per spike
spikeTimes = spikeTimes(diff(spikeTimes)~=1);




%part c
stimuli = data.Stimuli;
allOrients = stimuli(:,1);
allTimes = stimuli(:,2);


%initialize spikeCounts per orientation
%note that orientation 0 is mapped to 1, and 15 to 16 etc..
spikeCounts = NaN(1,16);


for orient = 0:15
    count = 0;
    trials = find(allOrients==orient);
    
    
    for j = 1:length(trials)
        startTime = allTimes(trials(j));
        numSpikes = length(find(spikeTimes>=startTime & spikeTimes <= startTime + 16666));
        rate = numSpikes/1.6666;
        count = count + rate;
        
        
    end
    
    spikeCounts(orient+1) = count./ length(trials);
    
    
end

figure;

theta = 0:22.5:337.5;



subplot(2,1,1);
plot(theta, spikeCounts, 'r');
xlim([0, 350])

ylabel('Firing Rate (sp/s)');
title('Orientation Tuning Curve');

subplot(2,1,2);

plot(theta, spikeCounts, 'r.');
xlim([0, 350])
hold on;
%Extra credit curve fitting

x = theta;
y = spikeCounts;
gaussEqn = 'a*exp(-((x-b)/c)^2)+d';
% guesstimated values for function
startPoints = [4, 180, 25, 0];
%only fit the unimodal part in the center (cuz it wraps around)
myFit = fit(x',y',gaussEqn,'Start', startPoints, 'Exclude', (x < 100 | x>300));
plot(myFit, 'k');
title({gaussEqn, ...
    strcat(' a: ', num2str(myFit.a)), ...
 strcat('b: ', num2str(myFit.b)), ...
strcat('c: ', num2str(myFit.c)),...
strcat('d: ', num2str(myFit.d))})

legend('Data', 'Gaussian Fit')
xlabel('Orientation (\theta degrees)');
ylabel('Firing Rate (sp/s)');




