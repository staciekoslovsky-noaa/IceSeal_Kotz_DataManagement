# Debayer images in a specific folder
# S. Hardy (modified code originally provided by Kitware...do not distribute)
# 9MAY2019

# Import packages
from __future__ import division, print_function
import numpy as np
from numpy import pi
#import matplotlib.pyplot as plt
import cv2
import time
import os
import glob

# Set variables before running!!!!!!
project_dir = '//nmfs/akc-nmml/Polar_Imagery/Techniques_Test/KAMERA_InFlightSystem_2019/polar_bear_2019/10/RGHT'

# Bayer pattern dictionary
bayer_patterns = {}
bayer_patterns['bayer_rggb8'] = cv2.COLOR_BayerBG2RGB
bayer_patterns['bayer_grbg8'] = cv2.COLOR_BayerGB2RGB
bayer_patterns['bayer_bggr8'] = cv2.COLOR_BayerRG2RGB
bayer_patterns['bayer_gbrg8'] = cv2.COLOR_BayerGR2RGB
bayer_patterns['bayer_rggb16'] = cv2.COLOR_BayerBG2RGB
bayer_patterns['bayer_grbg16'] = cv2.COLOR_BayerGB2RGB
bayer_patterns['bayer_bggr16'] = cv2.COLOR_BayerRG2RGB
bayer_patterns['bayer_gbrg16'] = cv2.COLOR_BayerGR2RGB

# Create debayered folder
save_dir = '//nmfs/akc-nmml/Polar_Imagery_2/TempDebayered/Right'

if not os.path.exists(save_dir):
    os.makedirs(save_dir)

# List images in project_dir
images = glob.glob('%s/*rgb.tif' % project_dir)
for i in images:
    image = os.path.basename(i)
    print('Reading', image)
    img = cv2.imread(i)[:,:,0]
    img2 = cv2.cvtColor(img, bayer_patterns['bayer_gbrg8'])
    print('Saving', image)
    db = '%s/%s' % (save_dir,image)
    cv2.imwrite(db, img2)
