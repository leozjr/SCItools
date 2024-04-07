classdef CurvePloter < handle
    properties
        cubes % 所有需要绘制的立方体
        data_num % 数据的数量

        namelist % 绘制曲线名称列表
        spec_lines % 从cubes中得到的曲线，一行是一条曲线，行数等于data_num

        lam % 波长列表
        save_path
        RGB
    end

    methods
        function obj = CurvePloter(origin, predict, namelist, save_path)
            % truth输入尺寸必须是：[width, height, bands] 或者 [1, width, height, bands]
            % predict输入尺寸必须是：[width, height, bands] 或者 [num, width, height, bands] 需要绘制很多条曲线,
            
            if ndims(predict) == 3
                predict = reshape(predict, [1, size(predict)]);
            end

            % 拼接后，第一个是truth
            cubes = cat(1, reshape(origin, [1, size(origin)]), predict);
            cubes(cubes>0.7) = 0.7;

            obj.cubes = cubes;
            obj.namelist = namelist;
            obj.data_num = size(cubes, 1);
            obj.save_path = save_path;

            % 设置波长
            band_num = size(cubes, ndims(cubes));
            if band_num == 28
                obj.lam = [453.5 457.5 462.0 466.0 471.5 476.5 481.5 487.0 492.5 498.0 504.0 510.0...
                        516.0 522.5 529.5 536.5 544.0 551.5 558.5 567.5 575.5 584.5 594.5 604.0...
                        614.5 625.0 636.5 648.0];
            elseif band_num == 31
                obj.lam = [400, 410, 420, 430, 440, 450, 460, 470, 480, 490, ...
                        500, 510, 520, 530, 540, 550, 560, 570, 580, 590, ...
                        600, 610, 620, 630, 640, 650, 660, 670, 680, 690, 700];
            else
                error("通道数异常")
            end

            % 使用matlab的Hyperspectral Image Processing工具箱生成RGB图像
            spec_img = hypercube(origin, obj.lam);
            obj.RGB = colorize(spec_img);
        end

        function plot_curves(obj)
            % 数据预处理，变为光谱曲线
            obj.gen_lines();

            % 创建 figure
            f = figure();
            plot(obj.lam, obj.spec_lines,'MarkerSize',16,'Marker','.','LineWidth',2.5);

            ylabel('Density');
            xlabel('Wavelength (nm)');
            
            legend(obj.namelist, 'Location','best');
            
            % 保存
            exportgraphics(f, fullfile(obj.save_path, "spec_lines.png"), "Resolution",600);
 
        end
        

        function gen_lines(obj)
            % 框选区域，需要双击确认选择结果
            figure();
            [yx, rect2crop]=imcrop(squeeze(obj.cubes(1,:,:,20)));
            rect2crop=round(rect2crop);
            close(gcf);
            
            % 保存框选位置
            figure();
            imshow(obj.RGB);
            rectangle('Position', rect2crop, 'EdgeColor', 'g', 'LineWidth', 2);
            exportgraphics(gcf, fullfile(obj.save_path, "lines_position.png"));
            close(gcf);

            % 剪裁绘制区域
            obj.cubes = obj.cubes(:,rect2crop(2):rect2crop(2)+rect2crop(4) , rect2crop(1):rect2crop(1)+rect2crop(3),:);
            
            % 求均值
            mean_cubes = mean(mean(obj.cubes, 2), 3);
            mean_cubes = mean_cubes ./ max(mean_cubes, [], 4); % 除以自己通道的最大值
            
            % 相关系数, 不用算自己和自己的
            mean_truth = mean_cubes(1,:,:,:);
            for i = 2:obj.data_num
                mean_cube = mean_cubes(i, :,:,:);
                corrs(i) = roundn(corr(mean_truth(:), mean_cube(:)),-4);
                obj.namelist(i) = obj.namelist(i) + ", corr " + num2str(corrs(i));
            end
            % 应该会变为[num, bands]形状，每一行是一个曲线，num是曲线数量
            obj.spec_lines = squeeze(mean_cubes);
        end

    end
end


