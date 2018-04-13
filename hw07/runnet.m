function accuracies = runnet(eta, n_epochs)
% Train the neural network on the training data for n_epochs epochs and
% return the a vector of classification accuracies on the test set after
% each epoch.

% load the training dataset
load mnist_training;

% random initialization of network parameters
b2 = randn(30, 1);
b3 = randn(10, 1);

w2 = randn(30, 28*28);
w3 = randn(10, 30);

accuracies = zeros(1, n_epochs);

t0 = tic;

for i = 1:n_epochs
    % train
    [w2, w3, b2, b3] = trainnet(images, labels, eta, w2, w3, b2, b3);
    
    % test the network
    accuracy = testnetwork(w2, w3, b2, b3);
    accuracies(i) = accuracy;

    disp(['Accuracy after ' int2str(i) ' epochs is ' num2str(accuracy, 2) '. ' ...
        '(time elapsed ' num2str(toc(t0)) ' seconds)']);
end

end