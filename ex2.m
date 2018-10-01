%% Image Compression I
clf, clc, clear

img1 = imread('RRY025/pout.tif');
img2 = imread('RRY025/cameraman.tif');


calcent(img1)
figure(2)
calcent(img2)