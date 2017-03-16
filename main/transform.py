#!/usr/bin/env python
# -*- coding: utf-8 -*-

from math import pi, sqrt, sin, cos, asin, atan
from numpy import dot, transpose


first_eccentricity = 6.69437999014 * 0.001
second_eccentricity = 6.73949674228 * 0.001
earth_radius = 6378137


def ecef2enu(point):
    return [[-sin(point[1]), cos(point[1]), 0], [-sin(point[0]) * \
            cos(point[1]), -sin(point[0]) * sin(point[1]), cos(point[0])],
            [cos(point[0]) * cos(point[1]), cos(point[0]) * sin(point[1]),
             sin(point[0])]]


def transform_point(point):
    latitude_normal = earth_radius / sqrt(1 - first_eccentricity \
                                                   * sin(point[0])**2)

    point_x = (latitude_normal + point[2]) * cos(point[0]) * cos(point[1])
    point_y = (latitude_normal + point[2]) * cos(point[0]) * sin(point[1])
    point_z = (latitude_normal * (1 - first_eccentricity) + point[2]) \
               * sin(point[0])

    return (point_x, point_y, point_z)


def geo2ned(target, origin):
    target = tuple(coord * pi / 180 for coord in target)
    origin = tuple(coord * pi / 180 for coord in origin)

    initial_coord = transform_point(origin)
    dest_coord = transform_point(target)

    enu_matrix = ecef2enu(origin)
    multiplication_matrix = [[dest_coord[0] - initial_coord[0]],
                             [dest_coord[1] - initial_coord[1]],
                             [dest_coord[2] - initial_coord[2]]]

    coordinates = dot(enu_matrix, multiplication_matrix)
    ned = coordinates[0][0], coordinates[1][0], 0

    return ned


def ned2geo(target, origin):
    origin = tuple(coord * pi / 180 for coord in origin)

    initial_coord = transform_point(origin)

    enu_matrix = transpose(ecef2enu(origin))
    ned_matrix = [target[0], target[1], target[2]]
    coordinates = dot(enu_matrix, ned_matrix)

    dest_coord = tuple(initial_coord[i] + coordinates[i] for i in range(3))

    temp = dest_coord[2] ** 2 / (earth_radius ** 2 \
                              * (1 - first_eccentricity) **2)
    temp = temp / (1 + first_eccentricity * temp)

    dest = asin(sqrt(temp)), atan(dest_coord[1] / dest_coord[0]), 0
    dest = tuple(coord * 180 / pi for coord in dest)

    return dest
