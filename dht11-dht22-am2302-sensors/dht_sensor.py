#!/usr/bin/python

# This mapp requires https://github.com/adafruit/Adafruit_Python_DHT/
# please verify it's installed before using this mapp

# Copyright 2019 Marc Blodeau

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

import sys
import Adafruit_DHT

# Parse command line parameters.
sensor_args = { '11': Adafruit_DHT.DHT11,
                '22': Adafruit_DHT.DHT22,
                '2302': Adafruit_DHT.AM2302 }

if len(sys.argv) == 4 and sys.argv[1] in sensor_args:
    sensor = sensor_args[sys.argv[1]]
    pin = sys.argv[2]
    labels = sys.argv[3]
else:
    print('Usage: ./dht_sensor.py [11|22|2302] <GPIO pin number> <F|C>')
    sys.exit(1)

humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)

if labels == 'F':
        temperature = temperature * 9/5.0 + 32

if humidity is not None and temperature is not None:
        print('{0:0.1f},{1:0.1f}'.format(temperature, humidity))
else:
        print('error while getting a reading')
        sys.exit(1)

###############################################################################


# Local Variables: ***
# tab-width: 4 ***
# indent-tabs-mode: t ***
# End: ***
#
# vim: ts=4 sw=4 noexpandtab
