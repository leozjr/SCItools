clear; clc;
folder_path = "data\chapter3\real\";
file_extension = ".mat";
scene_idx = 2;

% 获取 folder_path 下所有 .mat 文件
files = dir(fullfile(folder_path, "*" + file_extension));

for file_idx = 1:length(files)
    file_name = files(file_idx).name;
    disp(['Processing ' file_name '...']);

    % 加载 .mat 文件
    load(fullfile(folder_path, file_name));
    
    % 处理文件名以去除扩展名，以便创建子文件夹
    [~, file_name_no_ext, ~] = fileparts(file_name);
    save_file = fullfile(folder_path, "rgb_results/", file_name_no_ext);
    mkdir(save_file);

    close all;

    scene_name = "\s" + num2str(scene_idx);
    recon = squeeze(pred(scene_idx,:,:,:));
    recon = recon / max(max(max(recon)));
    intensity = 5;
    for channel = 1:28
        img_nb = [channel];  % channel number
        lam28 = [453.5, 457.5, 462.0, 466.0, 471.5, 476.5, 481.5, 487.0, 492.5, 498.0, 504.0, 510.0, ...
            516.0, 522.5, 529.5, 536.5, 544.0, 551.5, 558.5, 567.5, 575.5, 584.5, 594.5, 604.0, ...
            614.5, 625.0, 636.5, 648.0];
        
        recon(recon>1) = 1;

        channel_str = string(['channel' num2str(channel)]);
        save_name = save_file + scene_name + channel_str + ".png";
        
        % 根据您的需求调用显示或保存函数，这里假设 dispCubeAshwin 函数用于处理和保存图像
        dispCubeAshwin(recon(:,:,img_nb), intensity, lam28(img_nb), [], 1, 1, 0, 1, save_name);
    end
end
close all;
