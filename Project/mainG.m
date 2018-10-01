%% Project - Waveform based compression
clc, clear, close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              TRANSMITTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img_O = imread('RRY025/saturn.tif');

%% DPCM predict the prediction of the reciever

s = size(img_O);
st = s(1)*s(2);                         % Number of pixels
img = double(reshape(img_O', st, 1));   % Reshape image to vector

errq = zeros(st,1);                     % Quantized error
rec = img(1);                           % Reciever simulation

for n=2:st
  err = img(n) - rec;                   % Error between img and reciever (n-1)
  errq(n) = quantize(err);
  rec = rec + errq(n);
end
  
diff = reshape(errq,s)';


%% noloop version of reciever
s = size(diff);
sinv = s(1:1:2);       % no difference for 256x256
difft = diff';          % cumsum traverses cols
cs = cumsum(difft(:));
img_R = reshape(cs,sinv)';

calcent(img_R)
%

subplot(1,3,1)
imshow(img_O, [])
title('Original image')
subplot(1,3,2)
imshow(img_R,[])
title('Reconstructed image')
subplot(1,3,3)
imshow(img_R-double(img_O), [])
title('Difference')





