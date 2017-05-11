#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
import cv2


cap = cv2.VideoCapture('test.mp4')


while(cap.isOpened()):
    ret, frame = cap.read()

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Setup SimpleBlobDetector parameters.
    params = cv2.SimpleBlobDetector_Params()

    # Change thresholds
    params.minThreshold = 30
    params.maxThreshold = 50

    # Filter by Area.
    params.filterByArea = True
    params.minArea = 80

    # Filter by Circularity
    params.filterByCircularity = False
    # params.minCircularity = 0.1

    # Filter by Convexity
    params.filterByConvexity = False
    # params.minConvexity = 0.87

    # Filter by Inertia
    params.filterByInertia = False
    # params.minInertiaRatio = 0.01

    detector = cv2.SimpleBlobDetector(params)

    # Detect blobs.
    keypoints = detector.detect(gray)

    im_with_keypoints = cv2.drawKeypoints(gray, keypoints, np.array([]),
        (0, 0, 255), cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
    # Show keypoints
    cv2.imshow("Keypoints", im_with_keypoints)

    i = 0
    x = []
    y = []

    #for keypoint in keypoints:
        #x[i] = keypoint.pt[0]
        #y[i] = keypoint.pt[1]



    # cv2.imshow('frame', gray)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
