import matplotlib.pyplot as plt
import numpy as np
from PIL import Image

# Load the grayscale image
image_name = 'scene01.png'
image = Image.open('data/chapter3/sparse/' + image_name).convert('L')
image_array = np.array(image)

# Load the RGB image from another directory
rgb_image = Image.open(f'C:\\Users\\Leo\\Pictures\\论文用图\\CASSI数据\\simu\\rgb_imgs\\{image_name}')
rgb_image_array = np.array(rgb_image)

# Define the window size
window_size = 8

# Function to compute Gaussian mask
def compute_gaussian_mask(image, window_size):
    gaussian_values = np.random.normal(loc=0.5, scale=0.15, size=(image.shape[0] // window_size, image.shape[1] // window_size))
    means = np.clip(gaussian_values, 0, 1)
    threshold = np.mean(means)
    gaussian_mask = np.where(means > threshold, 1, 0)
    return np.repeat(np.repeat(gaussian_mask, window_size, axis=0), window_size, axis=1)

# Function to compute checkerboard mask
def compute_checkerboard_mask(image, window_size):
    checkerboard_mask = np.zeros((image.shape[0] // window_size, image.shape[1] // window_size))
    for i in range(checkerboard_mask.shape[0]):
        for j in range(checkerboard_mask.shape[1]):
            checkerboard_mask[i, j] = (i + j) % 2
    return np.repeat(np.repeat(checkerboard_mask, window_size, axis=0), window_size, axis=1)

# Function to compute sparse mask
def compute_sparse_mask(image, window_size):
    means = np.zeros((image.shape[0] // window_size, image.shape[1] // window_size))
    for i in range(0, image.shape[0], window_size):
        for j in range(0, image.shape[1], window_size):
            window = image[i:i+window_size, j:j+window_size]
            means[i // window_size, j // window_size] = np.mean(window)
    threshold = np.median(means)
    sparse_mask = np.where(means > threshold, 1, 0)
    return np.repeat(np.repeat(sparse_mask, window_size, axis=0), window_size, axis=1)

# Compute masks
gaussian_mask = compute_gaussian_mask(image_array, window_size).astype(float)
checkerboard_mask = compute_checkerboard_mask(image_array, window_size)
sparse_mask = compute_sparse_mask(image_array, window_size).astype(float)

# Apply color map to masks
colored_gaussian_mask = plt.get_cmap('viridis')(gaussian_mask)[:, :, :3]  # Remove alpha channel if present
colored_checkerboard_mask = plt.get_cmap('viridis')(checkerboard_mask)[:, :, :3]  # Remove alpha channel if present
colored_sparse_mask = plt.get_cmap('viridis')(sparse_mask)[:, :, :3]  # Remove alpha channel if present

# Normalize RGB image
norm_rgb_image_array = rgb_image_array / 255.0

# Create overlays
def create_overlay(image, mask):
    overlay = 0.5 * image + 0.5 * mask
    return np.clip(overlay, 0, 1)  # Ensure values are within valid range

overlay_gaussian = create_overlay(norm_rgb_image_array, colored_gaussian_mask)
overlay_checkerboard = create_overlay(norm_rgb_image_array, colored_checkerboard_mask)
overlay_sparse = create_overlay(norm_rgb_image_array, colored_sparse_mask)

# Save the overlays
plt.imsave(f'data/chapter3/sparse/{image_name[:-4]}_gaussian.png', overlay_gaussian)
plt.imsave(f'data/chapter3/sparse/{image_name[:-4]}_checkerboard.png', overlay_checkerboard)
plt.imsave(f'data/chapter3/sparse/{image_name[:-4]}_sparse.png', overlay_sparse)
