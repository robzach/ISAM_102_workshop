#include <Servo.h>

const int PROXPIN = A6,
          SERVOPIN = 3;

// const int LEDARRAY[] = { 3, 4, 5, 6, 7, 8, 9, 10 };

// int LEDarrayLength;

// max. observed voltage is 1.5V, convert to analogRead value
const int MAXANALOGREAD = 1.5 / 5.0 * 1024;

Servo gearDriver;

void setup() {
  gearDriver.attach(SERVOPIN);
  pinMode(PROXPIN, INPUT);

  // LEDarrayLength = sizeof(LEDARRAY) / sizeof(LEDARRAY[0]);

  // for (int i = 0; i < LEDarrayLength; i++) {
  //   pinMode(LEDARRAY[i], OUTPUT);
  // }
}

void loop() {
  int proxVal = analogRead(PROXPIN);
  int motorVal = map(proxVal, 50, 1000, 5, 175);
  motorVal = constrain(motorVal, 5, 175);

/*
  int LEDnumToLight = map(proxVal, 0, 1023, 0, 8);


  // turn off all LEDs to start
  for (int i = 0; i < LEDarrayLength; i++) {
    digitalWrite(LEDARRAY[i], LOW);
  }

  // turn on the LEDs you want on
  for (int i = 0; i < LEDnumToLight; i++) {
    digitalWrite(LEDARRAY[i], HIGH);
  }
  */

  gearDriver.write(motorVal);

  delay(10);
}
