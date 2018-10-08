function q = quant(diff, s, t) 
  % should be length(s) = length(t)-1
  s = sort(s);
  t = sort(t);
  
  
  s = [flip(-s) 0 s];
  t = [flip(-t) t];
  q = t(1)*ones(size(diff));

  for i=1:length(s)
    q(diff>s(i)) = t(i+1);
  end

end

