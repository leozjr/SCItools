% 结果评估
% 输入尺寸必须是：[num, width, height, bands]
clear;clc;

load("data\kaist_crop256_01_result.mat");
save_path = "output\PnPHSI";
gen_imgs = true;

evaluator = Evaluator(origin, predict, save_path);
evaluator.eval();