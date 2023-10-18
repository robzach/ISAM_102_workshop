/*

Scotty Driver for ISAM 102 workshop at Carnegie Mellon University
on Oct. 18, 2023

Reads an infrared ranger as input and drives a servo motor as output.

Code written for an MH-ET LIVE Tiny88 board, a cheap ATTiny88 implementation.
(Note that our testing got no analog read values out of pins A0 through A5
for an unknown reason, hence using A6 as our input pin.) Can also be used
with Arduino Pro Micro; see below for small pin numbering variation if using
Pro Micro.


pin mappings:

MH-ET LIVE pin |  role  | description
___________________________________________________________________
A6                input   attached to output leg of IR proximity sensor
9                 output  driving a continuous rotation servo
LED_BUILTIN       output  built-in light used for simple feedback


Ard. Pro Micro pin |  role  | description
___________________________________________________________________
A6 (= pin 4)          input   attached to output leg of IR proximity sensor
9                     output  driving a continuous rotation servo
17                    output  built-in light used for simple feedback


version description:

v 0.7: adds simple autoranging feature,
        light-blinking feedback, and
        Arduino Pro Micro pin mapping

See https://github.com/robzach/ISAM_102_workshop for much more information

Code released to the public domain by the author, 10/17/2023
Robert Zacharias, rzachari@andrew.cmu.edu

*/

#include <Servo.h>

// pin mapping for both boards
const int PROXPIN = A6,
          SERVOPIN = 9;

// pin for serial receive LED on Arduino Pro Micro
const int RXLED = 17;

// variables for simple autoranging feature
int minObserved = 1023,
    maxObserved = 0;

// variables for light blinking timing
// unsigned long data type is used for timers that will compare against millis()
unsigned long blinkDelay, lastBlink;
bool LEDstatus;

Servo gearDriver;

void setup() {
  gearDriver.attach(SERVOPIN);
  pinMode(PROXPIN, INPUT);
  pinMode(LED_BUILTIN, OUTPUT); // use RXLED instead for Pro Micro
}

void loop() {

  // read data off of IR sensor
  int proxVal = analogRead(PROXPIN);

  // adjust minObserved and maxObserved as appropriate
  if (proxVal < minObserved) minObserved = proxVal;
  if (proxVal > maxObserved) maxObserved = proxVal;

  // set motor speed between 120º and 180º based on latest observation
  // on a continuous rotation servo, 120º is slow and 180º is 
  // full speed clockwise
  int motorVal = map(proxVal, minObserved, maxObserved, 120, 180);

  // set blinking delay based on latest observation
  // note inverted mapping: shorter delay is quicker blinking
  blinkDelay = map(proxVal, minObserved, maxObserved, 500, 50);

  // drive motor
  gearDriver.write(motorVal);

  // blink light at tempo set by blinkDelay
  if (millis() - lastBlink >= blinkDelay) {

    if (LEDstatus) {  // if LED is already on
      digitalWrite(LED_BUILTIN, LOW); // use RXLED instead for Pro Micro
      LEDstatus = false;
    } else {  // if LED is off
      digitalWrite(LED_BUILTIN, HIGH); // use RXLED instead for Pro Micro
      LEDstatus = true;
    }
    lastBlink = millis(); // reset timer before exiting
  }

  delay(10);
}
