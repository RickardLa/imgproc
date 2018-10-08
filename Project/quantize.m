function q = quantize(d, partition, codebook, level)
q = zeros(size(d)); 



switch level
    case 1
        partition = 0;
        codebook = [-10 0]; 
        [~,q] = quantiz(d, partition, codebook); 
    case 2
        [~,q] = quantiz(d, partition, codebook); 
        
    case 3


        partition = [-45,-18,-4,6,21,49,96]; 
        codebook = [-63,-28,-8,1,11,31,67,126];
        
        
        [~, q] = quantiz(d, partition, codebook); 
        
       
        
    case '4bit'






end

