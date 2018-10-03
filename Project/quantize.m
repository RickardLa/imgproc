function q = quantize(d, levels)
q = zeros(size(d)); 

switch levels
    case '1bit'
        input = 0;
        output = 10; 
        q(d <= input) = -output; 
        q(d > input) = output; 
    case '2bit'
        
    case '3bit'
        
    case '4bit'

% L1 = 1; 
% L2 = 5; 
% 
% q(d < -2) = -L2; 
% q(d >= -2 & d < 0) = -L1; 
% 
% q(d >= 0 & d < 2) = L1; 
% q(d >= 2) = L2; 




end

