"""
includes CC BY 4.0 code from Garth Zeglin's 16-223 course website sketches:
analog_input.py
servo_step.py
"""

import board, math, time, pwmio, analogio, digitalio, adafruit_simplemath

# Set up built-in green LED for output.
internal_led = digitalio.DigitalInOut(board.LED)  # GP25
internal_led.direction = digitalio.Direction.OUTPUT

# additional LED output
external_led = digitalio.DigitalInOut(board.GP16)
external_led.direction = digitalio.Direction.OUTPUT

# Create a PWMOut object on Pin GP0 to drive the servo. The frequency argument
# specifies the pulse repetition rate in Hz (pulses per second).
servo = pwmio.PWMOut(board.GP0, duty_cycle=0, frequency=50)  # physical pin #1

# IR proximity sensor, physical pin #31
sensor = analogio.AnalogIn(board.A0)

# potentiometer, physical pin #32
pot = analogio.AnalogIn(board.A1)

fastblink = 0.01     # one tenth of a second
slowblink = 0.5   # two milliseconds
lastBlink = 0       # the last time the blinking LED changed states

highest = 0         # highest-yet observed value
lowest = 65536      # lowest-yet observed value

lastUpdate = 0
interval = 1      # delay between sending serial updates (seconds)

minimumServoAngle = 90      # 90º drives continuous servo to stop
maximumServoAngle = 180     # 180º drives continuous servo at highest speed


#### servo function ####

#--------------------------------------------------------------------------------
# Define a function to issue a servo command by updating the PWM signal output.
# This function maps an angle specified in degrees between 0 and 180 to a servo
# command pulse width between 1 and 2 milliseconds, and then to the
# corresponding duty cycle fraction, specified as a 16-bit fixed-point integer.

def servo_write(servo, angle, debug=False):
    # calculate the desired pulse width in units of seconds
    pulse_width  = 0.001 + angle * (0.001 / 180.0)

    # fetch the current pulse repetition rate from the hardware driver
    pulse_rate = servo.frequency

    # calculate the duration in seconds of a single pulse cycle
    cycle_period = 1.0 / pulse_rate

    # calculate the desired ratio of pulse ON time to cycle duration
    duty_cycle   = pulse_width / cycle_period

    # convert the ratio into a 16-bit fixed point integer
    duty_fixed   = int(2**16 * duty_cycle)

    # limit the ratio range and apply to the hardware driver
    servo.duty_cycle = min(max(duty_fixed, 0), 65535)

    # print some diagnostics to the console
    if debug:
        print(f"Driving servo to angle {angle}")
        print(f" Pulse width {pulse_width} seconds")
        print(f" Duty cycle {duty_cycle}")
        print(f" Command value {servo.duty_cycle}\n")

#### main loop ####

while True:

    # read the IR sensor once per cycle
    sensor_val = sensor.value

    # read the potentiometer once per cycle
    pot_val = pot.value

    # update slowestServoAngle based on current potentiometer position
    slowestServoAngle = adafruit_simplemath.map_range(
        pot_val,
        0,
        65535,
        minimumServoAngle,
        maximumServoAngle)


    # set highest and lowest levels based on observations
    if sensor_val > highest:
        highest = sensor_val

    if sensor_val < lowest:
        lowest = sensor_val


    # calculate servo command
    servoPos = adafruit_simplemath.map_range(
        sensor_val,
        lowest,
        highest,
        slowestServoAngle,
        maximumServoAngle)

    # calculate blink rate for on-board LED at varying rate as coarse indicator
    blinkInterval = adafruit_simplemath.map_range(
        sensor_val,
        lowest,
        highest,
        slowblink,
        fastblink)


    # drive servo
    servo_write(servo, servoPos, debug=False)

    # if it's been long enough, toggle LEDs oppositely from each other
    if time.monotonic() > (lastBlink + blinkInterval):
        if internal_led.value == False:
            internal_led.value = True
            external_led.value = False
        else:
            internal_led.value = False
            external_led.value = True

        lastBlink = time.monotonic()



    # print serial debugging data every "interval" seconds
    if time.monotonic() > (lastUpdate + interval):
        print("time.monotonic =", time.monotonic(),
            "\tpot_val =", pot_val,
            "\tsensor_val =", sensor_val,
            "\tlowest =", lowest,
            "\thighest =", highest)
        lastUpdate = time.monotonic()

    # uncomment the following to print tuples to plot with the mu editor
#     print((sensor_val, "sensor"), (1000, ""))
#     print(sensor_val)
#     time.sleep(0.1)  # slow sampling to avoid flooding
