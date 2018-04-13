function [w2, w3, b2, b3] = trainnet(images, labels, eta, w2, w3, b2, b3)
% Make one training step for the network by running backpropagation on all
% the images in the training dataset.

% loop through the images
n = size(images, 2);
for i = 1:n
    [dw2, dw3, db2, db3] = backprop(images(:, i), labels(:, i), ...
        w2, w3, b2, b3);
    w2 = w2 - eta*dw2;
    w3 = w3 - eta*dw3;
    
    b2 = b2 - eta*db2;
    b3 = b3 - eta*db3;
end

end