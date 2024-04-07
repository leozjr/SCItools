clear;clc;

lines_save_path = "output\";
scene_num_for_lines = 2; % 哪张图用来绘制光谱曲线

load_list = ["data\kaist_crop256_01_result.mat"];
load(load_list(1));

% TODO: 这里需要选哪张图，然后将所有的图放在一个 predict 中，[num, width, height,bands]
% 其中num是不同的方法，而图是同一张图

namelist = ["Ground Truth", "PnPHSI"];
curvePloter =  CurvePloter(origin, predict, namelist, lines_save_path);
curvePloter.plot_curves();
