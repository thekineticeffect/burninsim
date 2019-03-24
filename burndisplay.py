#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 23 17:44:06 2019

@author: avinashvakil
"""

import pickle
from videoplay import *
from PIL import Image
    
if __name__ == '__main__':
    width = 512
    height = 288
    size = (height, width)
    frameGen = generateFramesFromVideo("oblivion.mp4", size)
    display = Display(size, 0.0015)
    runVideoExperiment(display, frameGen, 1/30)
    with open("burnedDisplay.pkl", 'wb') as fh:
        pickle.dump(display, fh)
    Image.fromarray((255*display.pixelHealth).astype(np.uint8)).show()