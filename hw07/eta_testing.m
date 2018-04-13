etas = linspace(.7, 1.5, 20);
scores = zeros(size(etas));

for i = 1:length(etas)
    
    accuracy = runnet(etas(i), 10);
    scores(i) = accuracy(10);
    
end


% Manually see that eta = 1 is the best

accuracies = runnet(1, 30);

figure; 
plot(100*accuracies); 
xlabel('Number of Training Epochs'); 
ylabel('Accuracy on Test Data (%)');
