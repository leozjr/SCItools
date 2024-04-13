import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import dct
N = 16
Phi = np.zeros((N, N))

for k in range(N):
    for n in range(N):
        if k == 0:
            Phi[k, n] = 1 / np.sqrt(N)
        else:
            Phi[k, n] = np.sqrt(2 / N) * np.cos(np.pi * k * (2 * n + 1) / (2 * N))

plt.imshow(Phi, cmap='nipy_spectral')
plt.show()

# 生成一个[5 x N] 的随机测量矩阵, 同样用cmap的形式展示
M = 5
A = np.random.randn(M, N)
plt.imshow(A, cmap='nipy_spectral')
plt.show()