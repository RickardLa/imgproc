%% Project - Waveform based compression
clc, clear, close

% set(groot,'defaultFigureVisible','off')
set(groot,'defaultFigureVisible','on')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              TRANSMITTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img_O = imread('RRY025/cameraman.tif');


%% DPCM predict the prediction of the reciever
clc

[row, col] = size(img_O);
st = row*col;                           % Number of pixels
img = double(reshape(img_O', st, 1));   % Reshape image to vector

errq = zeros(st,1);                     % Quantized error
rec = img(1);                           % Reciever simulation

for n=2:st
  err = img(n) - rec;                 % Error between img and reciever (n-1)
  errq(n) = quantize(err);
  rec = rec + errq(n);
end
  
diff = reshape(errq, [row, col])';
% imshow(diff,[])



% noloop version of reciever

difft = diff';                          % Cumsum traverses column-wise
cs = cumsum(difft(:));
img_R = reshape(cs,     [col, row])';


subplot(1,3,1)
imshow(img_O, [])
title('Original image')
subplot(1,3,2)
imshow(img_R,[])
title('Reconstructed image')
subplot(1,3,3)
imshow(img_R-double(img_O), [])
title('Difference')

H_reconstructed = iment(img_R);
compression_rate = 8/H_reconstructed





