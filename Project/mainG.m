%% Project - Waveform based compression
clc, clear, close

% set(groot,'defaultFigureVisible','off')
set(groot,'defaultFigureVisible','on')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              TRANSMITTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img_1 = mean(double(imread('RRY025/jas.jpg')),3);
img_2 = double(imread('RRY025/cameraman.tif'));
img_3 = double(imread('RRY025/gisela_boat.TIF'));




subplot(2,3,1) 
imshow(img_1, [])

subplot(2,3,2)
imshow(img_2, [])

subplot(2,3,3) 
imshow(img_3, [])

subplot(2,3,4)
histogram(difim(img_1),100)
axis([-75 75 0 4e5])

subplot(2,3,5)
histogram(difim(img_2),100)
axis([-75 75 0 3.5e4])

subplot(2,3,6)
histogram(difim(img_3),100)
axis([-75 75 0 6e4])






img_O = img_1; 
diffimg = difim(img_O); 


%% DPCM predict the prediction of the reciever
clc

initialCondition = 'rowpixel';               % firstpixel or rowpixel
mode = 'DPCM';                            % intuitive or DPCM
level = 2;                                % Bits in quantizer


[row, col] = size(img_O);
st = row*col;                           % Number of pixels
img = (reshape(img_O', st, 1));         % Reshape image to vector

% calculate optimal quantizer



s0 = 1:2^(level-1)-1;
t0 = 1:2^(level-1);


x0 = 5*[s0.^2 t0.^2]; % just some initial values

f = @(x) opt_function(diffimg, x(1:2^(level-1)-1), x(2^(level-1):end));
x = fminsearch(f,x0);

slevels = x(1:2^(level-1)-1);
tlevels = x(2^(level-1):end);



switch initialCondition
    case 'firstpixel'
        
        prediction = img(1);  
        errorQuantized = [prediction; zeros(st-1,1)];   % Quantized error
        if strcmp(mode,'DPCM') == 1
            for n=2:st  
                predictionError = img(n) - prediction;            % Difference between actual pixel value and prediction
                errorQuantized(n) = quant(predictionError, slevels, tlevels);    % Quantize the prediction error
                prediction = prediction + errorQuantized(n);      % Update prediction
            end
            
        elseif strcmp(mode,'intuitive') == 1                      % Intuitive way - Transmitting the difference image
            diff = difim(img); 
            errorQuantized = [diff(1); quant(diff(2:end), slevels, tlevels)]; 
            
        end
        
        errorQuantized = reshape(errorQuantized, [row, col])';
        difft = errorQuantized';                          
        predict = cumsum(difft(:));
        img_R = reshape(predict, [col, row])';

case 'rowpixel' % Transmitting first pixel of every row
        errorQuantized = [img_O(:,1) zeros(row,col-1)];
        
        if strcmp(mode,'DPCM') == 1
            for i=1:row
                prediction = img_O(i,1); 
                for j=2:col
                    predictionError = img_O(i,j) - prediction; 
                    errorQuantized(i,j) = quant(predictionError, slevels, tlevels);
                    prediction = prediction + errorQuantized(i,j);
                end
            end
            
            
            
        elseif strcmp(mode,'intuitive') == 1                % Intuitive way - Transmitting the difference image
            errorQuantized = zeros(row,col); 
            for i=1:row
                previousPixel = img_O(i,1); 
                for j=2:col
                    errorQuantized(i,j) = img_O(i,j) - previousPixel;  
                    previousPixel = img_O(i,j); 
                end
            end
            errorQuantized = [img_O(:,1) quant(errorQuantized(:,2:end), slevels, tlevels)];
            
  
        end
        img_R = cumsum(errorQuantized, 2); 
        
end









% errorReceiver = (img_O-img_R);
% meanError = mean(abs(errorReceiver(:)))

% 
subplot(2,2,1)
imshow(img_O, [])
title('Original image')
subplot(2,2,2)
imshow(img_R,[])
title('Reconstructed image')
subplot(2,2,3)
imshow(img_R-double(img_O), [])
title('Difference')
subplot(2,2,4)
imshow(errorQuantized, [0 2^level])
title('Quantized error')







