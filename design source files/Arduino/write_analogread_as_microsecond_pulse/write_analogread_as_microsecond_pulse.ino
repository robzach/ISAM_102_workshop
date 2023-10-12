const int PROXPIN = A6,
          OUTPIN = 14;

// proxpin A6 works! Other input pins seemingly DO NOT WORK for analog read!

void setup() {
  pinMode(PROXPIN, INPUT);
  pinMode(OUTPIN, OUTPUT);
}

void loop() {
  // read sensor pin
  int proxVal = analogRead(PROXPIN);


  // turn on output pin for a pulse width equal to the analog read in microseconds, plus 10 to deal with zeros
  digitalWrite(OUTPIN, HIGH);
  delayMicroseconds(proxVal + 10);
  digitalWrite(OUTPIN, LOW);


  // int PWMval = map(proxVal, 0, 1023, 0, 255);
  // PWMval = constrain(PWMval, 0, 255);
  // analogWrite(OUTPIN, PWMval);

  delay(10);
}
