from CASSI import CASSI
import scipy.io as sio
import numpy as np
import matplotlib.pyplot as plt
import os
script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

folder_path = '../data/test_data/Truth'  # 输入文件夹
mask_path = '../data/test_data/mask.mat'  # mask文件路径
output_folder = '../output'  # 输出文件夹
step = 2  # 步长参数

if not os.path.exists(output_folder):
    os.makedirs(output_folder)
mask = sio.loadmat(mask_path)['mask']

for file in os.listdir(folder_path):
    if file.endswith(".mat"):
        file_path = os.path.join(folder_path, file)
        cube = sio.loadmat(file_path)['img']
        meas, mask_3d_shifted = CASSI(cube, mask, step).forward()
        file_name = os.path.splitext(os.path.basename(file_path))[0]
        output_file_path = os.path.join(output_folder, f"meas_{file_name}.png")
        plt.imsave(output_file_path, meas, cmap='gray')
