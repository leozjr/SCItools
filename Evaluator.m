classdef Evaluator < handle
    % CASSI重构结果的评估模块
    properties
        psnr_list
        ssim_list
        sam_list

        psnr_avg
        ssim_avg
        sam_avg

        % 数据
        data_num
        band_num
        origin
        predict
        
        % 模式
        mode
        save_path
    end
    
    methods

        function obj = Evaluator(orig, pred, save_path)
            addpath("quality_evaluation\", "visualization\");
            % 输入尺寸必须是：[num, width, height, bands]
            if ndims(pred) == 3 && ndims(orig) == 3
                orig = reshape(orig, [1, size(orig)]);
                pred = reshape(pred, [1, size(pred)]);
            end
            
            if ~isfolder(save_path)
                mkdir(save_path);
            end

            obj.origin = orig;
            obj.predict = pred;
            obj.data_num = size(obj.origin,1);
            obj.band_num = size(obj.origin,4);
            obj.save_path = save_path;
 
        end
        
        function eval(obj)
            obj.cal_quality_indexs();
            % obj.gen_imgs();
            obj.save_quality_indexs();
        end


        function cal_quality_indexs(obj)
            truth = double(obj.origin);
            pred = double(obj.predict);
            
            obj.psnr_list = zeros(obj.data_num, 1);
            obj.ssim_list = zeros(obj.data_num, 1);
            obj.sam_list = zeros(obj.data_num, 1);

            for i=1:obj.data_num
                Z = squeeze(pred(i,:,:,:));
                S = squeeze(truth(i,:,:,:));
                Z(Z>1.0) = 1.0;
                Z(Z<0.0) = 0.0;
                
                [psnr, rmse, ergas, sam, uiqi, ssim] = quality_assessment(double(im2uint8(S)), double(im2uint8(Z)), 0, 1);
                obj.psnr_list(i, 1) = psnr;
                obj.ssim_list(i, 1) = ssim;
                obj.sam_list(i, 1) = sam;
            end
            obj.psnr_avg = mean(obj.psnr_list);
            obj.ssim_avg = mean(obj.ssim_avg);
            obj.sam_avg = mean(obj.sam_list);
        end


        function save_quality_indexs(obj)
            % 打开文件以进行写入
            fid = fopen(fullfile(obj.save_path, "quality_indexs.txt"), 'w');
        
            % 保存 psnr_list
            fprintf(fid, 'PSNR:\n');
            fprintf(fid, '%f\n', obj.psnr_list);
        
            % 保存 ssim_list
            fprintf(fid, '\nSSIM:\n');
            fprintf(fid, '%f\n', obj.ssim_list);
        
            % 保存 sam_list
            fprintf(fid, '\nSAM:\n');
            fprintf(fid, '%f\n', obj.sam_list);
        
            % 保存平均值
            fprintf(fid, '\nAverage Values:\n');
            fprintf(fid, 'PSNR: %f\n', obj.psnr_avg);
            fprintf(fid, 'SSIM: %f\n', obj.ssim_avg);
            fprintf(fid, 'SAM: %f\n', obj.sam_avg);
        
            % 关闭文件
            fclose(fid);
        end



        function gen_imgs(obj)
            if obj.band_num == 28
                lam = [453.5 457.5 462.0 466.0 471.5 476.5 481.5 487.0 492.5 498.0 504.0 510.0...
                        516.0 522.5 529.5 536.5 544.0 551.5 558.5 567.5 575.5 584.5 594.5 604.0...
                        614.5 625.0 636.5 648.0];
            elseif obj.band_num == 31
                lam = [400, 410, 420, 430, 440, 450, 460, 470, 480, 490, ...
                        500, 510, 520, 530, 540, 550, 560, 570, 580, 590, ...
                        600, 610, 620, 630, 640, 650, 660, 670, 680, 690, 700];
            else
                error("通道数异常")
            end
           
            % Integrated
            scene_num = 0;
            for i = 1:obj.data_num
                recon = squeeze(obj.predict(i,:,:,:)); 
                recon(recon>1)=1;
                intensity = 5;

                file_name = sprintf('scene%.2d.png', scene_num);
                dispCubeAll(recon,intensity,lam, [] , 0, 1, fullfile(obj.save_path, file_name));
                scene_num = scene_num+1;
            end

            % Independent 这个代码只是很简单的修改了行数和列数，比较简陋，需要重构
            for i = 1:obj.data_num
                separate_save_path = fullfile(obj.save_path, sprintf("scene%.2d_separate", i-1));
                if ~isfolder(separate_save_path)
                    mkdir(separate_save_path);
                end

                recon = squeeze(obj.predict(i,:,:,:));
                recon(recon>1)=1;
                intensity = 5;
                for channel=1:obj.band_num
                    row_num = 1; col_num = 1;
                    file_name = sprintf('band%.2d.png', channel);
                    dispCubeSingle(recon(:,:,channel),intensity,lam(channel), [] ,col_num,row_num,0,1,fullfile(separate_save_path,file_name));
                end
            end
            
        end

        function gen_spectral_curve(obj)

        end
    end

    % 静态方法
    methods (Static)
        
    end
end
