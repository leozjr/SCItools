clear; clc;
disp('请选择裁剪区域模式：1-单独模式 2-内部模式');
mode = input('请输入模式编号：');
corner = "Right bottom"; % Left top Right bottom

firstImagePath = '.\data\chapter4\birds\rgb_results\GAP-SSCT\s1channel19.png'; % 更改为你的第一张图片路径
rootFolderPath = ".\data\chapter4\birds\rgb_results";
output_rootFolderPath = 'C:\Users\Leo\Pictures\论文图表资源\第4章附件\birds拼图\';
if ~exist(output_rootFolderPath, "dir")
    mkdir(output_rootFolderPath);
end

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
        
        % 裁剪并保存图片
        croppedImage = imcrop(image, position);
        [filePath, fileName, fileExt] = fileparts(images(j).name);

        % 标记并保存原图
        figure('Visible','off');
        imshow(image);
        rectangle('Position', position, 'EdgeColor', 'green', 'LineWidth', 2);
        
        if mode == 1
            croppedImagePath = fullfile(outputFolder, strcat(fileName, '_crop', fileExt));
            imwrite(croppedImage, croppedImagePath);
            markedImagePath = fullfile(outputFolder, strcat(fileName, '_marked', fileExt));
            exportgraphics(gca, markedImagePath, "Resolution", 600);
        elseif mode == 2
            % 内部模式：将裁剪区域放大2倍后覆盖在原图的一个角上
            switch corner
                case "Left top"
                    startY = 20;
                    startX = 20;
                case "Right top"
                    startY = 20;
                    startX = size(image, 2) - 2 * size(croppedImage, 2) - 20; % 放大后调整位置
                case "Left bottom"
                    startY = size(image, 1) - 2 * size(croppedImage, 1) - 20; % 放大后调整位置
                    startX = 20;
                case "Right bottom"
                    startY = size(image, 1) - 2 * size(croppedImage, 1) - 20; % 放大后调整位置
                    startX = size(image, 2) - 2 * size(croppedImage, 2) - 20; % 放大后调整位置
            end
            
            % 放大裁剪图像
            enlargedCroppedImage = imresize(croppedImage, 2.0, 'bicubic'); % 使用双三次插值法放大2倍
            
            % 覆盖放大的裁剪图像并绘制边框
            image(startY:startY + size(enlargedCroppedImage, 1) - 1, startX:startX + size(enlargedCroppedImage, 2) - 1, :) = enlargedCroppedImage;
            imshow(image);
            rectangle('Position', position, 'EdgeColor', 'green', 'LineWidth', 2);
            rectangle('Position', [startX, startY, size(enlargedCroppedImage, 2) - 1, size(enlargedCroppedImage, 1) - 1], 'EdgeColor', 'green', 'LineWidth', 2);
            
            zoomedImagePath = fullfile(outputFolder, strcat(fileName, '_zoomed', fileExt));
            exportgraphics(gca, zoomedImagePath, "Resolution", 600);
        end
        
        close(gcf); % 处理完每张图像后关闭图形窗口
    end
end

disp('图像处理完成。');
