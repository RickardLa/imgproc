%% Image Enhancement IV

% 1. LP/HP
clc, clear all
img = imread('RRY025/cameraman.tif'); 

img_F = (fftshift(fft2(img)));       % FFT of image
f0 = 1/8;                            % Cut-off freq = one eighth of max freq in img
filter = raduv(img); 

% Creating filters
LP = zeros(256); 
idx = find(filter<f0); 
LP(idx) = 1; 

HP = 1 - LP; 


Y_lp = real(ifft2(fftshift(LP.*img_F)));
Y_hp = real(ifft2(fftshift(HP.*img_F)));



% 2. Butterworth 


D0 = f0; 
n = 1; 
BW_LP = 1./(1 + (raduv(img)./D0).^(2*n));
BW_HP = 1 - BW_LP; 

Y_BWHP = real(ifft2(fftshift(BW_HP.*img_F)));
Y_BWLP = real(ifft2(fftshift(BW_LP.*img_F)));



% 3. Gaussian 

%% Padding
p = 256; 
padded_img = [img zeros(length(img),p)]; 
padded_img = [padded_img; zeros(p, length(padded_img))];

padded_imgF = (fftshift(fft2(padded_img)));


G_LP = exp(-(raduv(padded_img).^2)/(2*D0^2)); 
G_HP = 1 - G_LP; 

Y_GLP = real(ifft2(fftshift(G_LP.*padded_imgF)));
Y_GHP = real(ifft2(fftshift(G_HP.*padded_imgF)));

% subplot(1,2,1)
% imshow(Y_GLP(1:256,1:256), [])
% subplot(1,2,2)
% imshow(Y_GHP(1:256,1:256), [])


subplot(3,2,1)
imshow(Y_lp, [])
title('Ideal LP')
subplot(3,2,2)
imshow(Y_hp, [])
title('Ideal HP')

subplot(3,2,3)
imshow(Y_BWLP, [])
title('BW-LP')
subplot(3,2,4)
imshow(Y_BWHP, [])
title('BW-HP')

subplot(3,2,5)
imshow(Y_GLP(1:256,1:256), [])
title('Gaussian LP')
subplot(3,2,6)
imshow(Y_GHP(1:256,1:256), [])
title('Gaussian HP')

























