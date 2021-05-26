#include <Adafruit_BMP280.h>
#include <SPI.h>
#include <Wire.h>
#include <SD.h>
#include <SoftwareSerial.h>
#include <TinyGPS.h>
#include <MQ135.h>

#define CS_pin 9
#define LED_pin 7
#define buzz_pin 2
#define RX_pin 5
#define TX_pin 6
#define MQ4_pin A0
#define MQ135_pin A1

float seconds, altitude_val, pre_altitude_val, temperature_val, pressure_val, latitude_val, longitude_val, co2_val; 
float MQ4_volt, MQ4_RSgas, MQ4_ratio, MQ4_value, flat, flon;
float MQ4_R0 = 11.820;
float slope = -0.318;
float y_intercept = 1.133;
double methane_val, methane_log;
char gps_data;
boolean top_alt, reach_ground, new_data;
unsigned long age;

File myFile;
File topFile;
Adafruit_BMP280 bmp;
TinyGPS gps;
SoftwareSerial softSerial(RX_pin, TX_pin);
MQ135 gasSensor = MQ135(A1);


void setup(){

    //Initialize sensors and board

    Serial.begin(9600);
    softSerial.begin(9600);
    pinMode(LED_pin, OUTPUT);
    pinMode(CS_pin, OUTPUT);
    pinMode(buzz_pin, OUTPUT);
    pinMode(MQ135_pin, INPUT);
    pinMode(MQ4_pin, INPUT);

    //Check if it is working

    if (bmp.begin() && SD.begin(CS_pin) && softSerial.available()) {
        digitalWrite(LED_pin, HIGH);
    }
    else {
        
        if(!bmp.begin()){
            Serial.print("bmp");
        }
        else if(!SD.begin()){
            Serial.print("SD");
        }
        else if(!softSerial.available()){
            Serial.print("GPS");
        }
        else{
            Serial.print("Pégate un tiro");
        }

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

            myFile.println("Time(s),Temperature(C),Pressure(hPa),Altitude(m),Latitude(),Longitude(),Methane(PPM),CO2(PPM)");
            myFile.close();
        }
    }
    
}

void loop(){

    if (!reach_ground) {
        // Read sensors:
      
        //GPS
        for (unsigned long star = millis(); millis() - start < 1000){

            while(softSerial.available()){
                gps_data = sofSerial.read();
                if (gps.encode(gps_data)) {
                    new_data = true;
                }
            }
        }

        if (new_data) {

            gps.f_get_position(&flat, &flon, &age);
            latitude_val = (flat == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flat, 6);
            longitude_val = (flon == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flon, 6);
        }

        //BMP280
        altitude_val = bmp.readAltitude(1013.25);
        temperature_val = bmp.readTemperature();
        pressure_val = bmp.readPressure()/100;
        
        //MQ135
        co2_val = gasSensor.getPPM();

        //MQ4
        MQ4_value = analogRead(MQ4_pin);
        MQ4_volt = MQ4_value * (5.0 / 1023.0);
        MQ4_RSgas = ((5.0 * 10.0) / MQ4_volt) - 10.0;
        MQ4_ratio = MQ4_RSgas / MQ4_R0;

        methane_log = (log10(MQ4_ratio) - y_intercept) / slope;
        methane_val = pow(10, methane_log);

        //Time
        seconds= millis()/1000;

        //Save information SD

        myFile = SD.open("datalog.csv", FILE_WRITE);

        if(myFile) {
            myFile.print(seconds);
            myFile.print(",");
            myFile.print(temperature_val);
            myFile.print(",");
            myFile.print(pressure_val);
            myFile.print(",");
            myFile.print(altitude_val);
            myFile.print(",");
            myFile.print(latitude_val);
            myFile.print(",");
            myFile.print(longitude_val);
            myFile.print(",");
            myFile.print(methane_val);
            myFile.print(",");
            myFile.println(co2_val);
            myFile.close();
        }


        //Send information Radio
        
        Serial.print(seconds);
        Serial.print(",");
        Serial.print(temperature_val);
        Serial.print(",");
        Serial.print(pressure_val);
        Serial.print(",");
        Serial.print(altitude_val);
        Serial.print(",");
        Serial.print(latitude_val);
        Serial.print(",");
        Serial.print(longitude_val);
        Serial.print(",");
        Serial.print(methane_val);
        Serial.print(",");
        Serial.println(co2_val);
    }

    //check if it has reached the top

    if (altitude_val - pre_altitude_val > 3 && !top_alt && altitude_val > 200) {

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
        reach_ground = true;
    }

    pre_altitude_val = altitude_val;
}