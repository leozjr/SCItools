clear; clc;
addpath("quality_evaluation\");
output_path = 'output/quality.xlsx';
input_path = "data/chapter5/simu/";
sheet_name = "cp5simu";
% Load .mat files from the specified directory
files = dir(fullfile(input_path, "GAP-Diffusion.mat"));

filename_list = {files.name}';
foldername_list = {files.folder}';

data_to_write = []; % Initialize array for all data storage
filenames = [];
for n = 1:length(filename_list)
    load(fullfile(foldername_list{n}, filename_list{n}));
    if ndims(pred) == 3
        pred = reshape(pred, [1 size(pred)]);
        truth = reshape(truth, [1 size(truth)]);
    end
    
    if (max(max(max(max(truth))))) > 100
        truth = truth / 255.;
    end

    psnr_total=0.0;
    ssim_total=0.0;
    [scene_num, height, width, channel]=size(pred);
    quality_list = zeros(scene_num+1,3);
    for i = 1:scene_num
        Z = squeeze(pred(i,:,:,:));
        S = squeeze(truth(i,:,:,:));
        Z = min(max(double(Z), 0.0), 1.0); % Ensure Z is within [0, 1]
        
        [psnr, rmse, ergas, sam, uiqi, ssim] = quality_assessment(double(im2uint8(S)), double(im2uint8(Z)), 0, 1);
        
        quality_list(i, 1) = psnr;
        quality_list(i, 2) = ssim;
        quality_list(i, 3) = sam;
        
        psnr_total = psnr_total + psnr;
        ssim_total = ssim_total + ssim;
    end
    
    % Calculate the average values for the first 10 entries
    quality_list(end, :) = mean(quality_list(1:end-1, :), 1);
    quality_list = quality_list';
    filenames = [filenames; string(filename_list{n}); ""; ""];
    data_to_write = [data_to_write; quality_list];
end
writematrix(filenames, output_path, 'Sheet', sheet_name,'Range', 'A1');
writematrix(data_to_write, output_path, 'Sheet', sheet_name,'Range', 'B1');
