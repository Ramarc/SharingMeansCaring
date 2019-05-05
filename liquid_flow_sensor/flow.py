#!/usr/bin/python3

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import json
import requests
import RPi.GPIO as GPIO
import time, sys

GPIO_ID = 23

GPIO.setmode(GPIO.BCM)
GPIO.setup(GPIO_ID, GPIO.IN, pull_up_down = GPIO.PUD_UP)

global pulses
pulses = 0

def countPulse(channel):
    global pulses
    pulses = pulses+1

def currentFlow(name, divider):
    val = float(pulses / divider) if (pulses / divider) else 0
    print(str(name) + " = " + str(val))

GPIO.add_event_detect(GPIO_ID, GPIO.FALLING, callback=countPulse)

while True:
    try:
        time.sleep(5)
        print("")
        currentFlow('pulses', 1)
        currentFlow('liters', 450.0)
        currentFlow('gallons', 1703.0)
    except KeyboardInterrupt:
        GPIO.cleanup()
        sys.exit()
