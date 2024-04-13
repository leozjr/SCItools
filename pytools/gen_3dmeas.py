#%%
from CASSI import CASSI
import scipy.io as sio
import numpy as np
import matplotlib.pyplot as plt

def shift_back(inputs, step=2):  # input [1,256,310]  output [1, 28, 256, 256]
    [bs, row, col] = inputs.shape
    nC = 28
    output = np.zeros((bs, nC, row, col - (nC - 1) * step))
    for i in range(nC):
        output[:, i, :, :] = inputs[:, :, step * i:step * i + col - (nC - 1) * step]
    return output

file_path = './cassi_data/Truth/scene01.mat'
mask_path = './cassi_data/mask.mat'
step = 2

cube = sio.loadmat(file_path)['img']
mask = sio.loadmat(mask_path)['mask']
meas, mask_3d_shifted = CASSI(cube, mask, step).forward()

plt.imshow(meas, cmap='gray')
#%%
meas = np.expand_dims(meas, axis=0)
meas = shift_back(meas, step)
plt.imshow(meas[0, 0, :,:], cmap='gray')

#%%
# 调整 [1,28,256,256] -> [1,256,256,28]
meas = np.transpose(meas, (0, 2, 3, 1))
plt.imshow(meas[0, :, :, 0], cmap='gray')
meas.shape
# %%
sio.savemat('./output/init_3d.mat', {'pred': meas})

# %%
