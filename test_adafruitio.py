#!/usr/bin/env python

import time, sys

from chirp import Chirp
from Adafruit_IO import Client
from math import log10

aio = Client('some_customer_id_here')

if __name__ == "__main__":
    addr = 0x20
    if len(sys.argv) == 2:
        if sys.argv[1].startswith("0x"):
            addr = int(sys.argv[1], 16)
        else:
            addr = int(sys.argv[1])
    chirp = Chirp(2, addr)

    print chirp
    print "Send data to adafruit.io"
    while True:
        val=chirp.temp()
        time.sleep(0.5)
        hval=chirp.cap_sense()
        time.sleep(0.5)
        lval=chirp.light();
        print "%d\t%d\t%d" % (hval, val, lval)
        valf=float(val) / 10
        aio.send('temp', valf)
        aio.send('humid', hval)
        aio.send('light-lemon', lval)
        aio.send('light-log10-lemon', log10(lval))
        time.sleep(3600)

