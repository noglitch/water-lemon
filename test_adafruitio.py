#!/usr/bin/env python

import time, sys, os

from chirp import Chirp
from Adafruit_IO import Client
from math import log10
from datetime import datetime

aio = Client('some_customer_id_here')
filedir = "/var/run/water-lemon"
filename = filedir + "/do_water_lemontree.tmp"

def remove_signal():
    try:
        # if file exists, delete it
        if os.path.isfile(filename):
            os.unlink(filename)
    except:
        print "Error: cannot remove signal file"

def water_plant_signal():
    try:
        f = open(filename, 'a')
        dt = datetime.now().isoformat()
        f.write(dt)
        f.write('\n')
        f.close()
    except:
        print "Error: cannot write signal file"

if __name__ == "__main__":
    addr = 0x20
    if len(sys.argv) == 2:
        if sys.argv[1].startswith("0x"):
            addr = int(sys.argv[1], 16)
        else:
            addr = int(sys.argv[1])

    remove_signal()
    chirp = Chirp(2, addr)

    print chirp
    print "Send data to adafruit.io"
    while True:
        val=chirp.temp()
        time.sleep(0.2)
        hval=chirp.cap_sense()
        if hval < 415:
            water_plant_signal()
        time.sleep(0.2)
        lval=chirp.light();
        print "%d\t%d\t%d" % (hval, val, lval)
        valf=float(val) / 10
        aio.send('temp', valf)
        aio.send('humid', hval)
        aio.send('light-lemon', lval)
        aio.send('light-log10-lemon', log10(lval))
        time.sleep(3600)

