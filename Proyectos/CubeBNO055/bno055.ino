#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

Adafruit_BNO055 bno = Adafruit_BNO055(55);

void setup() {
  Serial.begin(115200);
  if (!bno.begin()) {
    Serial.println("ERR");
    while (1);
  }
  delay(1000);
  bno.setExtCrystalUse(true);
}

void loop() {
  sensors_event_t event;
  bno.getEvent(&event); // Euler: x=heading (yaw), y=roll, z=pitch en grados
  // CSV: yaw,roll,pitch
  Serial.print(event.orientation.x, 4); Serial.print(',');
  Serial.print(event.orientation.y, 4); Serial.print(',');
  Serial.print(event.orientation.z, 4); Serial.println();
  delay(20);
}
