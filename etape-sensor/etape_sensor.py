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

import time
import re
import busio
import digitalio
import board
import adafruit_mcp3xxx.mcp3008 as MCP
from adafruit_mcp3xxx.analog_in import AnalogIn

spi = busio.SPI(clock=board.SCK, MISO=board.MISO, MOSI=board.MOSI)
cs = digitalio.DigitalInOut(board.D22)
mcp = MCP.MCP3008(spi, cs)
chan0 = AnalogIn(mcp, MCP.P0)

# update these numbers for the etape used
markers = [
	'0:33088:33216',
	'1:33217:33600',
	'2:33601:34112',
	'3:34113:35392',
	'4:35393:36544',
	'5:36545:37440',
	'6:37441:38592',
	'7:38593:39872',
	'8:39873:40960',
	'9:40961:42432',
	'10:42433:43712',
	'11:43713:45312',
	'12:45313:46592',
	'13:46593:47872',
	'14:47873:49856',
	'15:49857:51584',
	'16:51583:53440',
	'17:53441:55040',
	'18:55041:56324',
]

# change this to the length of the etape in inches
maxdepth = 18
depth = 0

def depthCalc(basis, low, high):
	deepness = (basis - (1 - ((chan0.value - low) / (high - low))))

	if deepness < 0:
		deepness = 0

	return deepness

for counts in markers:
	data = list(map(int, re.split(':', counts)))

	if data[1] <= chan0.value <= data[2]:
		depth = depthCalc(data[0], data[1], data[2])

print('percent   : ' + str(round((depth / maxdepth) * 100, 2)))
print('depth [in]: ' + str(round(depth, 2)))
print('depth [cm]: ' + str(round(depth * 2.54, 2)))
print('ADC Raw   :', chan0.value)
print('ADC Volt  : ' + str(chan0.voltage) + 'V')

###############################################################################

# Local Variables: ***
# tab-width: 4 ***
# indent-tabs-mode: t ***
# End: ***
#
# vim: ts=4 sw=4 noexpandtab
