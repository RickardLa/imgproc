%% Project - Waveform based compression
clc, clear, close

% set(groot,'defaultFigureVisible','off')
set(groot,'defaultFigureVisible','on')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              TRANSMITTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img_O = double(imread('RRY025/cameraman.tif'));


%% DPCM predict the prediction of the reciever


initialCondition = 'firstpixel';               % firstpixel or rowpixel
mode = 'intuitive';                            % intuitive or smart



[row, col] = size(img_O);
st = row*col;                           % Number of pixels
img = (reshape(img_O', st, 1));         % Reshape image to vector


switch initialCondition
    case 'firstpixel'
        prediction = img(1);  
        errorQuantized = [prediction; zeros(st-1,1)];   % Quantized error
        if strcmp(mode,'smart') == 1
            
            for n=2:st  
            predictionError = img(n) - prediction;            % Difference between actual pixel value and prediction
            errorQuantized(n) = quantize(predictionError);    % Quantize the prediction error
            prediction = prediction + errorQuantized(n);      % Update prediction
            end
            
        else 
            diff = difim(img); 
            errorQuantized = [diff(1); quantize(diff(2:end))]; 
        end
        
        
        
        diff = reshape(errorQuantized, [row, col])';
        difft = diff';                          % Cumsum traverses column-wise
        predict = cumsum(difft(:));
        img_R = reshape(predict, [col, row])';


        
        
    case 'rowpixel'
        errorQuantized = [img_O(:,1) zeros(row,col-1)];
        
        for n=1:row
            prediction = img_O(n,1); 
            for i=2:col
            predictionError = img_O(n,i) - prediction; 
            errorQuantized(n,i) = quantize(predictionError);
            prediction = prediction + errorQuantized(n,i);
            end
        end
        
        img_R = cumsum(errorQuantized, 2); 
        
end







% 




% % noloop version of reciever
% 

% 
% errorReceiver = (img-predict);
% meanError = mean(abs(errorReceiver))
% 

imshow(img_R,[])
subplot(1,3,1)
imshow(img_O, [])
title('Original image')
subplot(1,3,2)
imshow(img_R,[])
title('Reconstructed image')
subplot(1,3,3)
imshow(img_R-double(img_O), [])
title('Difference')







