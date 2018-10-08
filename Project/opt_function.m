function D = opt_function(d, s, t) 
  dq = quant(d, s, t);
  D = sum(sum((d-dq).^2));
end
