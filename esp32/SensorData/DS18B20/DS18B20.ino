#include <Arduino.h>
#include <OneWire.h>
#include <DallasTemperature.h>

#define ONE_WIRE_BUS 4
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

void setup() {
  Serial.begin(9600);
  sensors.begin();
}

void loop() {
  sensors.requestTemperatures(); 

  float tempC = sensors.getTempCByIndex(0);

  Serial.print("Temperature: ");
  Serial.print(tempC);
  Serial.print("°C / ");
  delay(1000);
}