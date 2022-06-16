############################################################################
#
#	This program is free software; you can redistribute it and/or modify
#  	it under the terms of the GNU General Public License as published by
#  	the Free Software Foundation; either version 2, or (at your option)
#  	any later version.
#
#	Program to listen network traffic from DNP3Crafter.py
#
#	Author: Fernando Burrieza Galan
#
#	Version: 1.1
#
#	Since: 19/03/2022
#
###########################################################################


import socket
import sys

print('						                 	') 
print('    ____  _   ______ _____    __    _      __                      	')
print('   / __ \/ | / / __ \__  /   / /   (_)____/ /____  ____  ___  _____	')
print('  / / / /  |/ / /_/ //_ <   / /   / / ___/ __/ _ \/ __ \/ _ \/ ___/ 	')
print(' / /_/ / /|  / ____/__/ /  / /___/ (__  ) /_/  __/ / / /  __/ /    	')
print('/_____/_/ |_/_/   /____/  /_____/_/____/\__/\___/_/ /_/\___/_/\n   	')
print('									')

HOST = "192.168.1.100"  # Standard interface address
PORT = 20000  # Port to listen on

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    conn, addr = s.accept()
    with conn:
        print('Connected by', addr)
        while True:
            data = conn.recv(1024)
