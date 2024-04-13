clear;clc;
data_folder = 'data\chapter3\simu';
scene_idx = 2; % 哪张图用来绘制光谱曲线
lines_save_path = "output\";

fileNames = ["SC-DUT_9stg.mat","SC-DUT_7stg.mat","SC-DUT_5stg.mat",...
             "DAUHST-9stg.mat", "MST-L.mat", "GAP-Net.mat","TSA-Net.mat",...
             "DeSCI.mat", "GAP-TV.mat", "TwIST.mat"];  % 文件名数组，绘制将按该顺序进行

files = fullfile(data_folder,fileNames);

num_files = length(files);

predicts = [];
namelist = ["Ground Truth"];

for i = 1:num_files

    file_path = files(i);
    data = load(file_path); % 加载文件
    
    if i == 1
        [num, width, height, bands] = size(data.pred); % 获取数据维度
        origin = data.truth(scene_idx, :, :, :); % 提取Ground Truth
    end
    
    % 提取当前文件的第scene_idx个场景图像
    pred_scene = data.pred(scene_idx, :, :, :);
    
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

highlight = ["Ground Truth", "SC-DUT_9stg", "SC-DUT_7stg", "SC-DUT_5stg"];
highlight_idx = []; % 初始化空数组用于存储高亮显示的曲线的索引
for i = 1:length(highlight)
    idx = find(namelist == highlight(i));
    if ~isempty(idx)
        highlight_idx = [highlight_idx, idx];
    end
end

curvePloter.plot_curves(highlight_idx);
