import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
float inByte = 0;     
int COM = 4
float times, temperature, pressure, altitude, latitude, longitude, methane, carbon;

void setup () {

  size(1920, 1080);                                             // set the window size.
  Serial.printArray());
  myPort = new Serial(this, Serial.list()[COM], 9600);          // Open port.
  myPort.bufferUntil('\n');                                     // don't generate a serialEvent() unless you get a newline character:

  // set initial background:
  background(0);
}

void draw () {
  // draw the line:
  stroke(127, 34, 255);
  line(xPos, height, xPos, height - value[1]);

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
  String[] text_value = myPort.readString().split(\tabulador);
  float[] value= new float[text_value.length];
  for(int counter = 0; counter<text_value.length; counter++ ){
      value[counter]=parseFloat(text_value[counter]);
  }
  
  temperature = map(value[1], -200, 1023, 0, height);
  pressure = map(value[2], -200, 1023, 0, height);
  altitude = map(value[3], -200, 1023, 0, height);
  methane = map(value[6], -200, 1023, 0, height);
  carbon = map(value[7], -200, 1023, 0, height);

  redraw();

  }
}
