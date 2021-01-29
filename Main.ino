#include <Adafruit_BMP280.h>
#include <SPI.h>
#include <Wire.h>


float(altitude, pre_altitude)
int(LED_pin = 13)

void setup(){
    
    serialBegin(9600);
    pinMode(LED_pin, OUTPUT);
    
    if (bmp.begin()) {
        digitalWrite(LED_pin, HIGH));
    }
    else {
        digitalWrite(LED_pin, HIGH);
        delay(1000);
        digitalWrite(LED_pin, LOW);
        delay(1000)

    }

    bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,     /* Operating mode */
                    Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                    Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                    Adafruit_BMP280::FILTER_X16,      /* Filtering. */
                    Adafruit_BMP280::STANDBY_MS_500); /* Standby time. */
}

void loop(){

    pre_altitude = altitude
    delay(1000)
    altitude = bmp.readAltitude(1013.25)

    if (pre_altitude > altitude && altitude > 500) {
        //Deploy parachute
        

        // Read sensors

        Serial.print(F("Temperatura = "));
        Serial.print(bmp.readTemperature());
        Serial.println(F(" ºC"));

        Serial.print(F("Presión = "));
        Serial.print(bmp.readPressure());
        Serial.println(F(" Pa"));
        
        Serial.print(F("Altirud = "));
        Serial.print(bmp.readAltitude(1013.25));
        Serial.println(F(" m"));

        Serial.println();


        //Save information SD



        //Send information Radio
    }
    
}