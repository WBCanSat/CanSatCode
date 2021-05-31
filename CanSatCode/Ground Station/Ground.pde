import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph

int COM = 0;
float times=0;
float temperature=0;
float pressure=0;
float altitude=0;
float latitude=0;
float longitude=0;
float methane=0;
float carbon=0;

void setup () {

size(640, 480);      // set the window size.
 
  printArray(Serial.list());

  myPort = new Serial(this, Serial.list()[0], 9600);          // Open port.
  myPort.bufferUntil(10);                                     // don't generate a serialEvent() unless you get a newline character:

  // set initial background:
  background(0);
}

void draw () {
  // draw the line:
  stroke(127, 34, 255);
  line(xPos, height, xPos, height - temperature);

stroke(127, 34, 255);
  line(xPos, height, xPos, height - pressure);

stroke(127, 34, 255);
  line(xPos, height, xPos, height - altitude);

stroke(127, 34, 255);
  line(xPos, height, xPos, height -  methane);

stroke(127, 34, 255);
  line(xPos, height, xPos, height - carbon);



  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    background(0);
  } else {
    // increment the horizontal position:
    xPos++;
  }
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String[] text_value = myPort.readString().split("\t");
  float[] value= new float[text_value.length];
  for(int counter = 0; counter<text_value.length; counter++ ){
      value[counter]=parseFloat(text_value[counter]);
  }

  temperature = map(value[1], -20, 60, 0, 180);
  pressure = map(value[2], 1037.51, 877.16, 180,360 );
  altitude = map(value[3], -200, 1200, 360,540);
  methane = map(value[6], 1000, 2000, 0, height);
  carbon = map(value[7], 100, 700, 0, height);

}