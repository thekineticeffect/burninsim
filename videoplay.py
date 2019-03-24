# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import cv2
import numpy as np
from numba import jit
 
class Display:
    def __init__(self, resolution, decayRate):
        height, width = resolution
        self.pixelHealth = np.ones((height, width, 3))
        self.decayRate = decayRate
                
    @jit
    def step(self, image, dt):
        self.pixelHealth = step(self.pixelHealth, image, dt*self.decayRate)
        
    def normalize(self):
        self.pixelHealth = self.pixelHealth/self.health
        
    @property
    def health(self):
        return np.max(self.pixelHealth)
        
    def present(self, image):
        height, width, depth = np.shape(self.pixelHealth)
        image = cv2.resize(image, (width, height))
        return self.pixelHealth*image/self.health

@jit(nopython=True)
def step(pixels, image, decay):
    return pixels - pixels*image*decay

@jit
def runVideoExperiment(display: Display, videoProducer: iter, dt: float, maxT = None, renormFreq = 30, transformer = lambda frame, t: frame):
    i = 0
    for frame in videoProducer:
        display.step(transformer(frame, i*dt), dt)
        print(i*dt)
        i = i + 1
        if i % renormFreq == 0:
            display.normalize()
        if maxT and i*dt >= maxT:
            break


def generateFramesFromVideo(videoPath: str, resize = None):
    cap = cv2.VideoCapture(videoPath)
    if resize:
        height, width = resize
    if (cap.isOpened()== False): 
      print("Error opening video stream or file")
    while(cap.isOpened()):
      # Capture frame-by-frame
      ret, frame = cap.read()
      if ret == True:
        if resize:
            frame = cv2.resize(frame, (width, height))
        yield frame / 255
      else: 
        break
    cap.release()
