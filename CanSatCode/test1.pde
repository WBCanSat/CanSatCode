int xPos = 1;         // horizontal position of the graph
float inByte = 0;     
String text = "48   20  37  201";

void setup () {
  // set the window size.
  size(1920, 1080);
  // set initial background:
  background(0);
}

void draw () {
  // draw the line:
  stroke(127, 34, 255);
  line(xPos, height, xPos, height - inByte);

  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    background(0);
  } else {
    // increment the horizontal position:
    xPos++;
  }
}

void noLoop() {
  // get the ASCII string:
  String[] text_value = text.split("/t");
  float[] value= new float[text_value.length];
  for(int counter = 0; counter<text_value.length; counter++ ){
      value[counter]=parseFloat(text_value[counter]);
  }
  
  println(inByte);
  inByte = map(value[1], -200, 1023, 0, height);
  redraw();

  }
}