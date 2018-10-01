function q = quantize(d)
% Quantizer function. 
  % f(x<=low) = -e1
  % f(low<x<0) = -e2
  % f(0<=x<high) = e2
  % f(high<x) = e1
  
  high = 30;
  low = -high;
  e1 = 50;
  e2 = 2;
  
  q = -e1*ones(size(d));
  q(d>low) = -e2;
  q(d>=0) = e2;
  q(d>=high) = e1;

end

