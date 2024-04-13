clear;clc;
disp('请选择裁剪区域');
firstImagePath = '.\data\chapter3\real\rgb_results\DAUHST-9stg\s3channel19.png'; % 更改为你的第一张图片路径
rootFolderPath = ".\data\chapter3\real\rgb_results";
output_rootFolderPath = '.\output\crop_zoomin_real';

firstImage = imread(firstImagePath);
imshow(firstImage);
h = drawrectangle;
wait(h); 
position = h.Position;
close(gcf); 

disp('开始处理图像...');
subFolders = dir(rootFolderPath);
subFolders = subFolders([subFolders.isdir]); 
subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'}));

for i = 1:length(subFolders)
    subFolderPath = fullfile(rootFolderPath, subFolders(i).name);
    images = dir(fullfile(subFolderPath, '*.png')); 
    
    % 为每个子目录创建一个输出目录
    outputFolder = fullfile(output_rootFolderPath, subFolders(i).name);
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    
    for j = 1:length(images)
        imagePath = fullfile(images(j).folder, images(j).name);
        image = imread(imagePath);
        
        % 裁剪并保存图片，使用后缀'_crop'区分
        croppedImage = imcrop(image, position);
        [filePath, fileName, fileExt] = fileparts(images(j).name);
        croppedImagePath = fullfile(outputFolder, strcat(fileName, '_crop', fileExt));
        imwrite(croppedImage, croppedImagePath);
        
        % 标记并保存原图，使用后缀'_marked'区分
        figure('Visible', 'off');
        imshow(image);
        rectangle('Position', position, 'EdgeColor', 'green', 'LineWidth', 10);
        markedImagePath = fullfile(outputFolder, strcat(fileName, '_marked', fileExt));
        exportgraphics(gca, markedImagePath, "Resolution", 600);
        close(gcf); % 处理完每张图像后关闭图形窗口
    end
end

disp('图像处理完成。');
