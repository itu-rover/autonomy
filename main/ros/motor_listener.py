#!/usr/bin/env python
# -*- coding: utf-8 -*-

import rospy
from std_msgs.msg import String

rospy.init_node('motorController')
pub = rospy.Publisher('from_motor_controller', String, queue_size=10)

sending_data = None
def callback(data):
    #rospy.loginfo(rospy.get_caller_id() + "I heard %s", data.data)
    print(rospy.get_caller_id() + "  I heard %s", data.data)
    global sending_data
    sending_data = "I am sending to robot controller %s" % data.data
    
def controller():

    rate = rospy.Rate(10) # 10hz
    
    while not rospy.is_shutdown():
        rospy.Subscriber("cmd_vel", String, callback)
        #rospy.loginfo(sending_data)
        pub.publish(sending_data)
        rate.sleep()


if __name__ == '__main__':
    controller()
