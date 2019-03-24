#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 23 17:45:13 2019

@author: avinashvakil
"""

import pickle
from videoplay import *
import matplotlib.pyplot as plt
from PIL import Image

if __name__ == '__main__':
    with open("burnedDisplay.pkl", 'rb') as fh:
        display = pickle.load(fh)
    image = Image.open("descargar-images-full-hd-1080p.jpg")
    image.show()
    image = np.array(image)
    displayedimage = Image.fromarray((display.present(image)).astype(np.uint8))
    displayedimage.show()
