# pico_blink.py

# Raspberry Pi Pico - Blink demo

# Blink the onboard LED and print messages to the serial console.

import board
import time
from digitalio import DigitalInOut, Direction, Pull

#---------------------------------------------------------------
# Set up the hardware: script equivalent to Arduino setup()
# Set up built-in green LED
led = DigitalInOut(board.LED)  # GP25
led.direction = Direction.OUTPUT

#---------------------------------------------------------------
# Run the main loop: script equivalent to Arduino loop()

while True:
    led.value = True
    print("On")
    time.sleep(1.0)

    led.value = False
    print("Off")
    time.sleep(1.0)
