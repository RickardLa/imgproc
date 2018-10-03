%% Project - Waveform based compression
clc, clear, close

% set(groot,'defaultFigureVisible','off')
set(groot,'defaultFigureVisible','on')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              TRANSMITTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% img_O = double(imread('RRY025/cameraman.tif'));
img_O = double(imread('RRY025/gisela_boat.tif'));


%% DPCM predict the prediction of the reciever
clc

initialCondition = 'rowpixel';               % firstpixel or rowpixel
mode = 'DPCM';                            % intuitive or DPCM
level = '1bit';


[row, col] = size(img_O);
st = row*col;                           % Number of pixels
img = (reshape(img_O', st, 1));         % Reshape image to vector


switch initialCondition
    case 'firstpixel'
        prediction = img(1);  
        errorQuantized = [prediction; zeros(st-1,1)];   % Quantized error
        if strcmp(mode,'DPCM') == 1
            for n=2:st  
                predictionError = img(n) - prediction;            % Difference between actual pixel value and prediction
                errorQuantized(n) = quantize(predictionError, level);    % Quantize the prediction error
                prediction = prediction + errorQuantized(n);      % Update prediction
            end
        elseif strcmp(mode,'intuitive') == 1                      % Intuitive way - Transmitting the difference image
            diff = difim(img); 
            
            errorQuantized = [diff(1); quantize(diff(2:end), level)]; 
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
                    errorQuantized(i,j) = quantize(predictionError, level);
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
            errorQuantized = [img_O(:,1) quantize(errorQuantized(:,2:end), level)];
  
        end
        img_R = cumsum(errorQuantized, 2); 
        
end









% errorReceiver = (img_O-img_R);
% meanError = mean(abs(errorReceiver(:)))


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
imshow(errorQuantized, [0 1])
title('Quantized error')







