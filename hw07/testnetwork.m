function accuracy = testnetwork(w2, w3, b2, b3)
% TESTNETWORK Test the accuracy of your network's predictions on a test
% dataset.
%
% Usage:
%   accuracy = TESTNETWORK(w2, w3, b2, b3) runs the function forwardprop
%   that you wrote with the parameters given by the matrices w2, w3, b2,
%   and b3 on each of the images in the test dataset, and compares your
%   network's output to the expected labels. The function returns the
%   fraction of images for which your network returns the correct result.

% load the test dataset
load mnist_test;

% loop through all test images
n = size(images, 2); %#ok<NODEF>
n_correct = 0;
for i = 1:n
    % get the output; not interested in activities of middle layer
    [~, y3] = forwardprop(images(:, i), w2, w3, b2, b3);
    
    % prediction = output with largest response
    [~, prediction] = max(y3);
    expected = find(labels(:, i)); %#ok<NODEF>
    
    n_correct = n_correct + (prediction == expected);
end

accuracy = n_correct / n;

end