import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
float inByte = 0;     
int COM = 4;
String text = "48   20  37  201";

void setup () {
  // set the window size.
  size(1920, 1080);

  Serial.printArray());

  // Open port.
  myPort = new Serial(this, Serial.list()[COM], 9600);

  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

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
  String[] text_value = myPort.readString().split("/t");
  float[] value= new float[text_value.length];
  for(int counter = 0; counter<text_value.length; counter++ ){
      value[counter]=parseFloat(text_value[counter]);
  }
  
  println(inByte);
  inByte = map(value[1], -200, 1023, 0, height);
  redraw();

  }
}