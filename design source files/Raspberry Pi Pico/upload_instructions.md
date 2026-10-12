# Uploading CircuitPython code to the Raspberry Pi Pico

Download the latest CircuitPython .uf2 file from <https://circuitpython.org/board/raspberry_pi_pico/>; the currently-documented build uses version 10.3.1. You will use this file to prepare the board to read the CircuitPython instructions that we use in this project.

1. Plug the Rasperry Pi Pico into the computer; if no new drive appears then unplug and while holding the BOOTSEL button plug back in
2. Copy the downloaded UF2 file into the Raspberry Pi drive that appears (the drive is called `RPI-RP2`)
3. That drive will automatically unmount and then a new drive called `CIRCUITPY` should appear
4. From the design source files –> Raspberry Pi Pico folder, copy `code.py` and the whole `lib` folder into the `CIRCUITPY` drive, overwriting the old files
5. The on-board LED should start blinking irregularly, in a way that's affected by your touching pin 31 on the Pico with your finger; if that's working, it's visual evidence that you've successfully uploaded this code. (Pin 31 is an analog input that affects the LED blinking rate; touching it with your finger causes a voltage change there which in turn changes the blink rate.)