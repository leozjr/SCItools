clear;clc;
%% 第三章
% data_folder = 'data\chapter3\simu';
% scene_idx = 4; % 哪张图用来绘制光谱曲线
% lines_save_path = "C:\Users\Leo\Pictures\论文图表资源\第3章附件\RGB拼图";
% fileNames = ["SC-DUT-9stg.mat",...
%              "DAUHST-9stg.mat", "MST-L.mat", "GAP-Net.mat","TSA-Net.mat",...
%              "DeSCI.mat", "GAP-TV.mat", "TwIST.mat"];  % 文件名数组，绘制将按该顺序进行
% highlight = ["Ground Truth", "SC-DUT-9stg", "DAUHST-9stg","MST-L", "GAP-Net","TSA-Net"];

%% 第四章
data_folder = 'data\chapter4\birds';
scene_idx = 3; % 哪张图用来绘制光谱曲线
lines_save_path = "C:\Users\Leo\Pictures\论文图表资源\第4章附件\birds拼图";
fileNames = ["ADMM-SSCT.mat","GAP-SSCT.mat",...
             "PnP-DIP.mat", "PnP-HSI.mat", "PnP-FFDNet-TV.mat",...
             "DeSCI.mat", "GAP-TV.mat", "TwIST.mat"];  % 文件名数组，绘制将按该顺序进行
highlight = ["Ground Truth", "ADMM-SSCT","GAP-SSCT", "PnP-DIP", "PnP-HSI", "PnP-FFDNet-TV"];
%% 第五章
% data_folder = 'data\chapter5\simu';
% scene_idx = 1; % 哪张图用来绘制光谱曲线
% lines_save_path = "C:\Users\Leo\Pictures\论文图表资源\第5章附件\simu拼图";
% fileNames = ["GAP-SSCT.mat","PnP-S4DM.mat","GAP-Net.mat",...
%              "PnP-DIP.mat","DeSCI.mat", "GAP-TV.mat", "TwIST.mat"];   % 文件名数组，绘制将按该顺序进行
% highlight = ["Ground Truth", "GAP-SSCT","GAP-Net",...
%             "PnP-S4DM", "PnP-DIP"];

%% 

files = fullfile(data_folder,fileNames);

num_files = length(files);

predicts = [];
namelist = ["Ground Truth"];

for i = 1:num_files

    file_path = files(i);
    data = load(file_path); % 加载文件
    if ndims(data.pred) == 4
        if i == 1
            origin = data.truth(scene_idx, :, :, :); % 提取Ground Truth
        end
        pred_scene = data.pred(scene_idx, :, :, :);
    elseif ndims(data.pred) == 3
        if i == 1
            data.truth = reshape(data.truth, [1 size(data.truth)]);
            origin = data.truth; % 提取Ground Truth
        end
        data.pred = reshape(data.pred, [1 size(data.pred)]);
        pred_scene = data.pred;
    end
    % 将提取的图像添加到predicts数组中
    if isempty(predicts)
        predicts = pred_scene; % 如果predicts为空，直接赋值
    else
        predicts = cat(1, predicts, pred_scene); % 否则，沿第一维度（num维度）堆叠
    end
    
    % 将文件名添加到namelist中
    namelist = [namelist, string(erase(fileNames(i), '.mat'))];
end

% 送入ploter开始绘制
curvePloter =  CurvePloter(origin, predicts, namelist, lines_save_path);

highlight_idx = []; % 初始化空数组用于存储高亮显示的曲线的索引
for i = 1:length(highlight)
    idx = find(namelist == highlight(i));
    if ~isempty(idx)
        highlight_idx = [highlight_idx, idx];
    end
end

curvePloter.plot_curves(highlight_idx);
