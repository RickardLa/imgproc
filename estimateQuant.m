function optimalQuantized = estimateQuant(img, level)


error = @(x) sum(sum(img - x).^2);


codePart = sort(randi(10,1,2^level+3))
q = quantiz(img, sort(codePart(1:2^level)), sort(codePart(2^level+1:end)));





optimalQuantized = fminsearch(error, q)  


end

