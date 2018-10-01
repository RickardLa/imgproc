%% Project - Waveform based compression
clc, clear, close

quanta = 2^8; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              TRANSMITTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img_O = imread('RRY025/cameraman.tif');
diff = difim(img_O);
diff_vector = reshape(diff',1,[]);       % Reshape to vector





H_orignial = iment(img_O)
H_diff = iment(diff_vector)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              RECEIVER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[row, col] = size(diff); 
img_R = zeros(1,row*col);                % Reconstructed image
img_R(1) = diff_vector(1);               % First pixel not changed

for i=2:size(img_R,2)           
    img_R(i) = img_R(i-1) + diff_vector(i); 
end

img_R = reshape(img_R, col, row)';


subplot(1,2,1)
imshow(img_O, [])
title('Original image')
subplot(1,2,2)
imshow(img_R, [])
title('Reconstructed image')

% sum(sum(imsubtract(double(img_O), img_R)))          % Lossless compression-->Pictures identical

