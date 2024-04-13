% 绘制高光谱图像的RGB合成图
clear;
folder_path = "./data/test_data/simu/Truth/";
img_name = "scene10";
save_path = "./output";
img_path = fullfile(folder_path, img_name + ".mat");


var_name = 'img';
data_struct = load(img_path);
data = data_struct.(var_name);
[~, ~, channels] = size(data);

if channels == 28
    lam = [453.5 457.5 462.0 466.0 471.5 476.5 481.5 487.0 492.5 498.0 504.0 510.0...
        516.0 522.5 529.5 536.5 544.0 551.5 558.5 567.5 575.5 584.5 594.5 604.0...
        614.5 625.0 636.5 648.0];
elseif channels == 31
    lam = [400, 410, 420, 430, 440, 450, 460, 470, 480, 490, ...
            500, 510, 520, 530, 540, 550, 560, 570, 580, 590, ...
            600, 610, 620, 630, 640, 650, 660, 670, 680, 690, 700];
else
    error("wrong bands number");
end

hcube = hypercube(data, lam);
colored = colorize(hcube, Method="rgb");
save_path = fullfile(save_path, sprintf("%s.png", img_name));
imwrite(colored, save_path);
