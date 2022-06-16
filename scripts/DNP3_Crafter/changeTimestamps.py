############################################################################
#
#	This program is free software; you can redistribute it and/or modify
#  	it under the terms of the GNU General Public License as published by
#  	the Free Software Foundation; either version 2, or (at your option)
#  	any later version.
#
#	Program to change the timestamp of packets to have a timestamp for each day
#
#	Author: Fernando Burrieza Galan
#
#	Version: 1.0
#
#	Since: 12/04/2022
#
###########################################################################

# Import Scapy module
import os
import sys
from scapy import all as scapy
from subprocess import call
import pathlib


def process_packets(infile, timestamp):
    pkts = scapy.rdpcap(infile)
    cooked=[]
    for p in pkts:
        p.time = timestamp
        timestamp += 0.015
        pmod=p
        cooked.append(pmod)
    scapy.wrpcap(infile, cooked)
    return timestamp

# Declare Timestamp to start the modification
timestamp = 1650098111.000000
dirname = sys.argv[1]
print(dirname)
ext = ('.pcap')

# Loop to iterate through all files
for files in os.listdir(dirname):
    if files.endswith(ext):
        #process the function
        print(dirname+files)
        timestamp =  process_packets(dirname+files, timestamp)
    else:
        continue
