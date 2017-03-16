#!/usr/bin/env python
# -*- coding: utf-8 -*-

from operator import itemgetter
import transform


polygon_list = [(41.086452, 29.123782),
                (41.056758, 29.0743822),
                (41.082045, 28.982312)]

max_latitude = max(polygon_list, key=itemgetter(0))[0]
min_latitude = min(polygon_list, key=itemgetter(0))[0]

max_longitude = max(polygon_list, key=itemgetter(1))[1]
min_longitude = min(polygon_list, key=itemgetter(1))[1]

new_target = max_latitude, max_longitude, 0
new_origin = min_latitude, min_longitude, 0

ned = transform.geo2ned(new_target, new_origin)
max_x, max_y = abs(ned[1]), abs(ned[0])

for polygon in polygon_list:
    new_target = polygon[0], polygon[1], 0
    ned = transform.geo2ned(new_target, new_origin)
    coord = transform.ned2geo(ned, new_origin)

    print(ned[0], ned[1], ned[2])




