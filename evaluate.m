% 结果评估
% 输入尺寸必须是：[num, width, height, bands]

load("data\kaist_crop256_01_result.mat");
save_path = "output\PnPHSI";

evaluator = Evaluator(origin, predict, save_path);
evaluator.eval();

