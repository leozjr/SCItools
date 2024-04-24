clear;
scene_idx = 1;
rgb_path = "C:\Users\Leo\Pictures\论文图表资源\CASSI数据\simu\rgb_imgs";
save_path = "C:\Users\Leo\Pictures\论文图表资源\第4章附件\RGB拼图";
truth_name = sprintf('scene%02d.png', scene_idx);
copyfile(fullfile(rgb_path, truth_name),fullfile(save_path, truth_name));
%% 

folder_path = "./data/chapter4/simu/";
img_name = "";  % 设置为空，表示处理所有.mat文件

if img_name == ""
    file_list = dir(fullfile(folder_path, '*.mat'));
else
    file_list = dir(fullfile(folder_path, img_name + ".mat"));
end

for k = 1:length(file_list)
    current_file = file_list(k).name;
    img_path = fullfile(folder_path, current_file);

    var_name = 'pred';
    data_struct = load(img_path);
    data = data_struct.(var_name);
    data = squeeze(data(scene_idx, :,:,:));
    [~, ~, channels] = size(data);

    if channels == 28
        lam = [453.5 457.5 462.0 466.0 471.5 476.5 481.5 487.0 492.5 498.0 504.0 510.0...
            516.0 522.5 529.5 536.5 544.0 551.5 558.5 567.5 575.5 584.5 594.5 604.0...
            614.5 625.0 636.5 648.0];
    elseif channels == 24
        lam = [398.617939958977, 404.402632317658, 410.574115854899, 417.159372325304,...
            424.187266572559, 431.688677953166, 439.696640932459, 448.246495493025, ...
            457.376048040370, 467.125743538450, 477.538849658800, 488.661653781728, ...
            500.543673746535, 513.237883310311, 526.800953341869, 541.293509848978, ...
            556.780410013717, 573.331037492779, 591.019618327240, 609.925558900174, ...
            630.133807480854, 651.735241001701, 674.827078828993, 699.513325411290];
    elseif channels == 31
        lam = [400, 410, 420, 430, 440, 450, 460, 470, 480, 490, ...
                500, 510, 520, 530, 540, 550, 560, 570, 580, 590, ...
                600, 610, 620, 630, 640, 650, 660, 670, 680, 690, 700];
    else
        error("wrong bands number");
    end

    hcube = hypercube(data, lam);
    colored = colorize(hcube, Method="rgb");
    result_name = replace(current_file, '.mat', sprintf('_S%02d.png', scene_idx));
    save_path_full = fullfile(save_path, result_name);
    
    % h = figure();
    % imshow(colored);
    % axis tight;
    % set(gca, 'LooseInset', get(gca, 'TightInset'));
    % exportgraphics(h, save_path_full, "Resolution",600);
    % close(h);

    imwrite(colored, save_path_full);
end
