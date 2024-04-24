% 指定包含.mat文件的文件夹
folder = '.'; % 例如 'C:\Data'

% 获取文件夹中所有.mat文件
files = dir(fullfile(folder, '*.mat'));

% 遍历每个文件
for k = 1:length(files)
    filename = fullfile(folder, files(k).name);
    
    % 加载.mat文件
    data = load(filename);
    
    % 检查是否存在变量 'cube'
    if isfield(data, 'cube')
        % 将变量 'cube' 重命名为 'gt'
        data.gt = data.cube;
        data = rmfield(data, 'cube');
        
        % 保存更新后的文件
        save(filename, '-struct', 'data');
    else
        fprintf('变量 cube 在文件 %s 中不存在。\n', filename);
    end
end
