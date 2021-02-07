#include <Adafruit_BMP280.h>
#include <SPI.h>
#include <Wire.h>
#include <SD.h>

#define CS_pin 10
#define LED_pin 7
#define buzz_pin 2
File myFile;
File topFile;
int seconds;
float altitude_val, pre_altitude_val, temperature_val, pressure_val;
boolean top_alt = false;
Adafruit_BMP280 bmp;


void setup(){

    //Initialize sensors and board

    Serial.begin(9600);
    pinMode(LED_pin, OUTPUT);
    pinMode(CS_pin, OUTPUT);
    pinMode(buzz_pin, OUTPUT);

    //Check if it is working

    if (bmp.begin(0x76) && SD.begin(CS_pin)) {
        digitalWrite(LED_pin, HIGH);
    }
    else {

        while(1) {

            digitalWrite(LED_pin, HIGH);
            delay(500);
            digitalWrite(LED_pin, LOW);
            delay(1000);
            
        }
        
    }

    //Create datalog file

    if(!SD.exists("datalog.csv")) {

        myFile = SD.open("datalog.csv", FILE_WRITE);
        if (myFile) {

            myFile.println("Time(s),Temperature(C),Pressure(hPa),Altitude(m)");
            myFile.close();
        }

    }

    //Set parameters of BMP280

    bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,     /* Operating Mode. */
                    Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                    Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                    Adafruit_BMP280::FILTER_X16,      /* Filtering. */
                    Adafruit_BMP280::STANDBY_MS_500); /* Standby time. */

}

void loop(){

    // Read sensors

    pre_altitude_val = altitude_val;
    delay(1000);
    altitude_val = bmp.readAltitude(1013.25);

    temperature_val = bmp.readTemperature();
    pressure_val = bmp.readPressure()/100;


    //Save information SD

    myFile = SD.open("datalog.csv", FILE_WRITE);

    if(myFile) {
        myFile.print(seconds);
        myFile.print(",");
        myFile.print(temperature_val);
        myFile.print(",");
        myFile.print(pressure_val);
        myFile.print(",");
        myFile.println(altitude_val);
       
       myFile.close();
    }


    //Send information Radio



    //check if it has reached the top

    if (pre_altitude_val > altitude_val && !top_alt && altitude_val > 500) {

        top_alt = true;

        if(!SD.exists("top_alt.txt")) {

        topFile = SD.open("top_alt.txt", FILE_WRITE);
        if (topFile) {

            topFile.print("The CanSat has reached the top at ");
            topFile.print(altitude_val);
            topFile.print("m");
            topFile.close();

            }
        }
    }

    //check if it's on the ground and turn on the buzzer

    else if(pre_altitude_val == altitude_val && top_alt) {

        tone(buzz_pin, 600);
    }

    seconds += 1;
}