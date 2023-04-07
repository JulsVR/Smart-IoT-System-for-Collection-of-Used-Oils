#include <Arduino.h>
#include <OneWire.h>
#include <DallasTemperature.h>

#define ONE_WIRE_BUS 4
#define READINGS 10
float temp = 0.0;
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

int get_temperature()
{

  sensors.requestTemperatures(); 
  float temp[READINGS];
  for(int i=0; i<READINGS; i++)
  {
     temp[i] = sensors.getTempCByIndex(0);
  }

  return temp;
}
void setup() {
    Serial.begin(9600);
    sensors.begin();

    temp = get_temperature();
    Serial.print(temp);
    Serial.println("ºC");
    delay(2000);
}


void loop() {
/*
  sensors.requestTemperatures(); 

  float tempC = sensors.getTempCByIndex(0);

  Serial.print("Temperature: ");
  Serial.print(tempC);
  Serial.print("°C / ");
  delay(2000); 
  */
}
