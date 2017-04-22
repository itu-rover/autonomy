#!/usr/bin/env python
# -*- coding: utf-8 -*-


import numpy as np
from math import sin, cos, pi

earth_radius = 6378137
# turn these to cartesian
north = [earth_radius, 90, 0]
current_location = [earth_radius, 41.104444, 29.026997]
target_location = [earth_radius, 41.103465, 29.027909]

carteasian_vector = [0,0,0]


def polar2cartesian(polarvector):
    carteasian_vector[0] = polarvector[0] * cos(polarvector[1]*pi/180)*cos(
        polarvector[2]*pi/180)
    carteasian_vector[1] = polarvector[0] * cos(polarvector[1]*pi/180)*sin(
        polarvector[2]*pi/180)
    carteasian_vector[2] = polarvector[0] * sin(polarvector[1]*pi/180)
    return polarvector


def unit_vector(vector):
    """ Returns the unit vector of the vector.  """
    return vector / np.linalg.norm(vector)


def angle(v1, v2):
    v1_u = unit_vector(v1)
    v2_u = unit_vector(v2)
    return np.arccos(np.clip(np.dot(v1_u, v2_u), -1.0, 1.0))

earth_radius = 6378137

north_ned = polar2cartesian(north)
current_location_ned = polar2cartesian(current_location)
target_location_ned = polar2cartesian(target_location)

current_cross = np.cross(current_location_ned, north_ned)
target_cross = np.cross(current_location_ned, target_location_ned)

angle_in_between = angle(current_cross, target_cross) * np.sign(
    np.dot(np.cross(current_cross, target_cross), current_location_ned))

print(angle_in_between*180/pi)
