function [y2 , y3] = forwardprop (y1 , w2 , w3 , b2 , b3)

% y1 is activation layer
% w2 is weight matrix between layer 1 and 2
% w3 is weight matrix between layer 2 and 3
% bi is bias vector for layer i

    sigma = @(x) 1 ./ (1 + exp(-x));
    
    y2 = sigma((w2 * y1) + b2);
    
    y3 = sigma((w3 * y2) + b3);
    
end
