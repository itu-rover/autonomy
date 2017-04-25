#!/usr/bin/env python
# -*- coding: utf-8 -*-

import asyncore
from server import EchoServer
from serial_com import SerialNode
from settings import *
import rospy
from std_msgs.msg import String
import threading

rospy.init_node('robotController')
pub = rospy.Publisher('cmd_vel', String, queue_size=10)

recevied_data = None
def callback(data):
    #rospy.loginfo(rospy.get_caller_id() + "I heard %s", data.data)
    print(rospy.get_caller_id() + "   I heard %s", data.data)
    global recevied_data
    received_data = data.data


def communication():
    serial_node.run()

def controller():

    rate = rospy.Rate(10) # 10hz
    while not rospy.is_shutdown():
        try:
            server_data = serial_node.server.handler.data
        except Exception as e:
            print(e)
            server_data = None
        rospy.Subscriber("from_motor_controller", String, callback)
        data = "From TCP: %s" % str(server_data)
        #rospy.loginfo(data)
        pub.publish(data)
        rate.sleep()

if __name__ == '__main__':
    try:
        tcp_server = EchoServer(HOST, PORT)
        serial_node = SerialNode(tcp_server)
        communication_thread = threading.Thread(target=communication)
        communication_thread.daemon = True
        communication_thread.start()
        controller()

    except rospy.ROSInterruptException:
        pass
