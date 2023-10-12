#include <Servo.h>

const int PROXPIN = 19,
          SERVOPIN = 3;

Servo gearDriver;

void setup() {
  gearDriver.attach(SERVOPIN);
  pinMode(PROXPIN, INPUT);

  Serial.begin(9600);
}

void loop() {
  for (int i = 0; i < 180; i++) {
    gearDriver.write(i);
    delay(50);
  }
   for (int i = 180; i > 0; i--) {
    gearDriver.write(i);
    delay(50);
  }
}
