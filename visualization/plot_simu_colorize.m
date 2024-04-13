%% plot color pics
clear; clc;
folder_path = "data\chapter3\simu\";
file_name = "SC-DUT_7stg";

load(fullfile(folder_path, file_name + ".mat"));
save_file = fullfile(folder_path, "rgb_results/", file_name);
mkdir(save_file);

close all;
for i = 1:10
    recon = squeeze(pred(i,:,:,:));
    recon = recon / max(max(max(recon)));
    intensity = 5;
    for channel=1:28
        img_nb = [channel];  % channel number
        row_num = 1; col_num = 1;
        lam28 = [453.5 457.5 462.0 466.0 471.5 476.5 481.5 487.0 492.5 498.0 504.0 510.0...
            516.0 522.5 529.5 536.5 544.0 551.5 558.5 567.5 575.5 584.5 594.5 604.0...
            614.5 625.0 636.5 648.0];

        recon(recon>1)=1;

        frame_str = string(['\s' num2str(i)]);
        channel_str = string(['channel' num2str(channel)]);
        save_name = save_file + frame_str + channel_str + ".png";

        dispCubeAshwin(recon(:,:,img_nb),intensity,lam28(img_nb), [] ,col_num,row_num,0,1,save_name);
    end
end
close all;


