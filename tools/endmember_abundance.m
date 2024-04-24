% 假设 hyperspectral_image 是一个 H x W x C 的高光谱图像
% R 是端元数量
load("data\testsets_multibands\WashingtonDCMall.mat");
R = 5;
H = 256;
W = 256;

% 使用 N-FINDR 算法提取端元
endmembers = nfindr(img, R);
% 估计丰度矩阵
abundance = estimateAbundanceLS(img, endmembers);
% 可视化丰度矩阵
for i = 1:R
    figure;
    ax = axes('Position', [0 0 1 1], 'Unit', 'normalized'); % 设置坐标轴填满整个图形窗口
    imagesc(squeeze(abundance(:,:,i)));
    axis off; % 关闭坐标轴显示
    axis image; % 设置轴以保持数据的纵横比
    exportgraphics(ax, sprintf('./output/abundance_%d.png', i), 'Resolution', 300);
end
% 可视化端元光谱曲线
%% 
for i = 1:R
    figure;
    plot(endmembers(:, i), 'LineWidth', 2, 'Color', [0, 0, 0]); % 使用循环的颜色数组
    set(gca, 'Visible', 'off'); % 隐藏坐标轴
    axis tight; % 紧凑显示，不留空白区域
    set(gcf, 'Color', 'none'); % 设置图形背景透明
    set(gca, 'Color', 'none'); % 设置坐标轴背景透明

    % 保存为 PNG
    filename = sprintf('./output/endmember_spectrum_%d.png', i);
    print(filename, '-dpng', '-r300');
end

