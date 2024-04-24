% 加载左侧的.mat文件
file_left = "data\chapter4\birds\GAP-SSCT-1.mat";
file_right = "data\chapter4\birds\GAP-SSCT-2.mat";

load(file_left);  
left_pred = pred;
left_truth = truth;
load(file_right);
right_pred = pred;
right_truth = truth;

pred = [left_pred, right_pred];
truth = [left_truth, right_truth];
figure;
imshow(squeeze(pred(:,:,19)));
figure;
imshow(squeeze(truth(:,:,19)))
% 保存拼接后的结果
save("data\chapter4\birds\GAP-SSCT.mat", 'pred', 'truth');
