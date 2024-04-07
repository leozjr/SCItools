clear;clc;
addpath("quality_evaluation\");
output_path = 'output/quality_origin.xlsx';

% files = dir("D:/Leo_files/MST/simulation/test_code/exp/**/*.mat"); %全体计算
% files = dir("D:/Leo_files/MST/simulation/test_code/exp/想要计算的单个文件夹/*.mat"); % 单个数据计算
files = dir("data/PnP-HSDT/*.mat"); %全体计算

filename_list = {files.name}';
foldername_list = {files.folder}';

for n = 1:length(filename_list)
    load(fullfile(foldername_list{n},filename_list{n}));
    psnr_total=0.0;
    ssim_total=0.0;
    quality_list = zeros(11,3);
    for i=1:10
        Z = squeeze(pred(i,:,:,:));
        Z = double(Z);
        S = squeeze(truth(i,:,:,:));
        S = double(S);
        
        Z(Z>1.0) = 1.0;
        Z(Z<0.0) = 0.0;
        
        [psnr, rmse, ergas, sam, uiqi, ssim] = quality_assessment(double(im2uint8(S)), double(im2uint8(Z)), 0, 1);

        quality_list(i,1) = psnr;
        quality_list(i,2) = ssim;
        quality_list(i,3) = sam;
        
        psnr_total = psnr_total+psnr;
        ssim_total = ssim_total+ssim;
    end
    
    %插入前10个的平均值
    quality_list(11,:) = mean(quality_list(1:10,:));
    quality_list = quality_list';
    
    % 写入文件
    writematrix(quality_list,output_path,WriteMode="append");
    writematrix(filename_list{n},output_path,WriteMode="append");
end

