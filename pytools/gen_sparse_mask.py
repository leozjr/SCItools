
#%% 
import numpy as np
from PIL import Image

# Load the image and convert to grayscale
image_name = 'scene01.png'
image = Image.open('..\data\chapter3\sparse\\' + image_name).convert('L')
image_array = np.array(image)

# Define the window size
window_size = 32

# Function to compute the window means and create a full-size mask
def compute_mask(image, window_size):
    means = np.zeros((image.shape[0] // window_size, image.shape[1] // window_size))
    for i in range(0, image.shape[0], window_size):
        for j in range(0, image.shape[1], window_size):
            window = image[i:i+window_size, j:j+window_size]
            means[i // window_size, j // window_size] = np.mean(window)
    threshold = np.median(means)
    mask = np.where(means > threshold, 1, 0)
    return np.repeat(np.repeat(mask, window_size, axis=0), window_size, axis=1)

# Compute the mask
mask_full_size = compute_mask(image_array, window_size)

#%%
import matplotlib.pyplot as plt
# Color map and overlay grid on the full-size mask
norm_mask_full_size = mask_full_size / np.max(mask_full_size)
for i in range(0, norm_mask_full_size.shape[0], window_size):
    norm_mask_full_size[i:i+1, :] = 0  # Black grid horizontal
for j in range(0, norm_mask_full_size.shape[1], window_size):
    norm_mask_full_size[:, j:j+1] = 0  # Black grid vertical

norm_image_array = (image_array - np.min(image_array)) / (np.max(image_array) - np.min(image_array))
# Save the image
plt.imsave(f'../output/colormapped_{image_name}.png', norm_image_array, cmap='viridis')
plt.imsave(f'../output/mask_{image_name}.png', norm_mask_full_size, format='png')

# %%
