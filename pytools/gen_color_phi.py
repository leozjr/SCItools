
#%%
import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import dct
N = 16
M = 8
#%%
# 创建DCT变换矩阵
Phi = np.zeros((N, N))

for k in range(N):
    for n in range(N):
        if k == 0:
            Phi[k, n] = 1 / np.sqrt(N)
        else:
            Phi[k, n] = np.sqrt(2 / N) * np.cos(np.pi * k * (2 * n + 1) / (2 * N))

# 保存Phi矩阵图像，无白边
plt.imshow(Phi, cmap='rainbow')
plt.axis('off')  # 不显示坐标轴
plt.savefig('Phi_image.png', dpi=600, bbox_inches='tight', pad_inches=0)
plt.close()
#%%
# 创建随机矩阵A并保存
A = np.random.uniform(-1, 1, size=(M, N))
plt.imshow(A, cmap='rainbow')
plt.axis('off')  # 不显示坐标轴
plt.savefig('A_image.png', dpi=600, bbox_inches='tight', pad_inches=0)
plt.close()

# %%
