/*

Scotty Driver for ISAM 102 workshop

Reads an infrared ranger as input and drives a servo motor as output.

Code written for an MH-ET Live Tiny 88 board, a cheap ATTiny88 implementation.
(Note that our testing got no analog read values out of pins A0 through A5
for an unknown reason, hence using A6 as our input pin.)

pin mapping:

Arduino pin | role  | description
___________________________________________________________________
A6            input   attached to output leg of IR proximity sensor
3             output  driving a continuous rotation servo


Code released to the public domain by the author, 10/12/2023
Robert Zacharias, rzachari@andrew.cmu.edu

*/

#include <Servo.h>

const int PROXPIN = A6,
          SERVOPIN = 3;

// max. observed voltage is 1.5V, convert to analogRead value
const int MAXANALOGREAD = 1.5 / 5.0 * 1024;

Servo gearDriver;

void setup() {
  gearDriver.attach(SERVOPIN);
  pinMode(PROXPIN, INPUT);
}

void loop() {
  int proxVal = analogRead(PROXPIN);
  int motorVal = map(proxVal, 50, 1000, 5, 175);
  motorVal = constrain(motorVal, 5, 175);
  
  gearDriver.write(motorVal);

  delay(10);
}
