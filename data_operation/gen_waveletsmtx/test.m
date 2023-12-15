%验证函数dwtmtx的正确性
clear all;close all;clc;
% 'db1' or 'haar', 'db2', ... ,'db10', ... , 'db45'
% 'coif1', ... , 'coif5'
% 'sym2', ... , 'sym8', ... ,'sym45'
% 'bior1.1', 'bior1.3', 'bior1.5'
% 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8'
% 'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7'
% 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'
% 'rbio1.1', 'rbio1.3', 'rbio1.5'
% 'rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8'
% 'rbio3.1', 'rbio3.3', 'rbio3.5', 'rbio3.7'
% 'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'
wtype = 'sym8';

dwtmode('per');
for i = 1:6
    N = 2^(2*i);
    wlev = wmaxlev(N,wtype);
    if wlev <= 0
        waveletsmtx{i} = false;
    end
    ww = dwtmtx(N,wtype,wlev);
    waveletsmtx{i} = ww;
end
save('waveletsmtx.mat', 'waveletsmtx')
