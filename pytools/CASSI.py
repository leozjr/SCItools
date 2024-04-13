import numpy as np
from utils.pnp_utils import shift,shift_back,A
class CASSI():
    def __init__(self, cube, mask, step=1, mode = "SD"):
        self.cube = cube
        self.mask = mask
        self.step = step
        self.mode = mode

        self.height, self.width, self.spectral = cube.shape
        
    def forward(self):
        mask_repeated = np.tile(self.mask[:, :, np.newaxis], (1, 1, self.spectral))
        self.cube_shifted = shift(self.cube, self.step)
        if self.mode == "SD":
            self.mask_3d_shifted = shift(mask_repeated, self.step)
            meas = A(self.cube_shifted, self.mask_3d_shifted) # 测量值
        elif self.mode == "DD": # TODO：不知道对不对
            self.mask_3d_shifted = np.concatenate((mask_repeated, np.zeros((self.height, (self.spectral-1)*self.step, self.spectral))), axis=1)
            meas = np.sum(shift_back(self.cube_shifted*self.mask_3d_shifted, self.step), axis=2)
        return meas, self.mask_3d_shifted
