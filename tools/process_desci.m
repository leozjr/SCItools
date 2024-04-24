clear;
file_path = "data\chapter4\birds\desci_cassi_bird.mat";
load(file_path);
truth = orig;
truth = truth(1:688, 1:1008, :);

pred = vgaptv;
pred = pred(1:688, 1:1008, :);
save("data\chapter4\birds\GAP-TV.mat", 'pred', 'truth');

pred = vdesci;
pred = pred(1:688, 1:1008, :);
save("data\chapter4\birds\DeSCI.mat", 'pred', 'truth');

%% 
clear;
file_path = "data\chapter4\birds\GAP-TV.mat";
load(file_path);
file_path = "data\chapter4\birds\TwIST_birds.mat";
load(file_path);
save("data\chapter4\birds\TwIST.mat", 'pred', 'truth');
%%
clear;
file_path = "data\chapter4\birds\PnP-3dTV_birds.mat";
load(file_path);
truth = truth(1:688, 1:1008, :);
pred = pred(1:688, 1:1008, :);
save("data\chapter4\birds\PnP-3dTV.mat", 'pred', 'truth');