function [dw2 , dw3 , db2 , db3] = backprop (y1 , a, w2 , w3 , b2 , b3)


% a : expected outputs
% y1 : input
% w2 is weight matrix between layer 1 and 2
% w3 is weight matrix between layer 2 and 3
% bi is bias vector for layer i

[y2, y3] = forwardprop(y1, w2, w3, b2, b3);

gamma_3 = y3 - a;


db3 = (y3 .* (1-y3)) .* gamma_3;



X = repmat(db3', [size(w3,2),1]);
Y = repmat(y2', [size(w3, 1),1]);
dw3 = X'.*Y;

gamma_2 = zeros(size(w3,2),1);

for j = 1:length(gamma_2)
    total = 0;
    for i = 1:size(w3,1)
        total = total + (gamma_3(i) * y3(i) * (1-y3(i)) * w3(i,j));
    end
    gamma_2(j) = total;
end

% gamma_2 = ((gamma_3' * y3) * ((1 - y3)' * w3))';




% for i = length(b2)
%     
%     db2(i) = (y2(i) * (1-y2(i))) * gamma_2(i);
%     
% end
% 
% db2'
% 
db2 = (y2 .* (1-y2)) .* gamma_2;
% db2 = db2';


dw2 = repmat(db2', [size(w2, 2),1])' .* repmat(y1', [size(w2,1),1]);



end