import grafica.*;
import java.awt.*;
import processing.serial.*;

Serial myPort;
public GPlot plot1, plot2, plot3, plot4, plot5, plot6;
float[] value;
float seconds, altitude, temperature, pressure, latitude, longitude, co2, methane;
String text = "Esperando conexión...";
PImage bg;

void setup() {
 
  surface.setResizable(true);
  delay(100);
  javax.swing.JFrame jframe = (javax.swing.JFrame)((processing.awt.PSurfaceAWT.SmoothCanvas)getSurface().getNative()).getFrame();
  jframe.setLocation(0, 0);
  jframe.setExtendedState(jframe.getExtendedState() | jframe.MAXIMIZED_BOTH);
  
  bg = loadImage("background.jpg");
  bg.resize(width, height);
  background(0);
  image (bg, 0, 0);
  
  // Open port.
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.bufferUntil(10);
  
  //Setup First Plot
  plot1 = new GPlot(this);
  plot1.setPos(0.351*width, 0.0465*height);
  plot1.setOuterDim(0.298*width, 0.431*height);
  plot1.getTitle().setText("Nivel Metano (PPM)");
  plot1.getXAxis().getAxisLabel().setText("Tiempo (s)");
  plot1.getYAxis().getAxisLabel().setText("Metano (PPM)");
  plot1.setBoxBgColor(255);
  plot1.getMainLayer().setLineColor(color(111, 51, 142));
  plot1.getMainLayer().setPointColor(color(111, 51, 142));
  plot1.activatePanning();
  plot1.activatePointLabels();
  plot1.activateReset(RIGHT, GPlot.CTRLMOD);
  plot1.activateZooming(1.2, CENTER, CENTER);

  //Setup Second Plot
  plot2 = new GPlot(this);
  plot2.setPos(0.6755*width, 0.0465*height);
  plot2.setOuterDim(0.298*width, 0.431*height);
  plot2.getTitle().setText("Nivel CO2 (PPM)");
  plot2.getXAxis().getAxisLabel().setText("Tiempo (s)");
  plot2.getYAxis().getAxisLabel().setText("CO2 (PPM)");
  plot2.setBoxBgColor(255);
  plot2.activatePanning();
  plot2.activatePointLabels();
  plot2.activateReset(RIGHT, GPlot.CTRLMOD);
  plot2.activateZooming(1.2, CENTER, CENTER);
  
  //Setup Third Plot
  plot3 = new GPlot(this);
  plot3.setPos(0.026*width, 0.423*height);
  plot3.setOuterDim(0.298*width, 0.531*height);
  plot3.getTitle().setText("GPS");
  plot3.getXAxis().getAxisLabel().setText("Latitud");
  plot3.getYAxis().getAxisLabel().setText("Longitud");
  plot3.activatePanning();
  plot3.activatePointLabels();
  plot3.activateReset(RIGHT, GPlot.CTRLMOD);
  plot3.activateZooming(1.2, CENTER, CENTER);
  
  //Setup Fourth Plot
  plot4 = new GPlot(this);
  plot4.setPos(0.351*width, 0.523*height);
  plot4.setOuterDim(0.190*width, 0.431*height);
  plot4.getTitle().setText("Temperatura (ºC)");
  plot4.getXAxis().getAxisLabel().setText("Tiempo (s)");
  plot4.getYAxis().getAxisLabel().setText("Temperatura (ºC)");
  plot4.activatePanning();
  plot4.activatePointLabels();
  plot4.activateReset(RIGHT, GPlot.CTRLMOD);
  plot4.activateZooming(1.2, CENTER, CENTER);

  //Setup Fifth Plot
  plot5 = new GPlot(this);
  plot5.setPos(0.567*width, 0.523*height);
  plot5.setOuterDim(0.190*width, 0.431*height);
  plot5.getTitle().setText("Presión (hPa)");
  plot5.getXAxis().getAxisLabel().setText("Tiempo (s)");
  plot5.getYAxis().getAxisLabel().setText("Presión (hPa)");
  plot5.activatePanning();
  plot5.activatePointLabels();
  plot5.activateReset(RIGHT, GPlot.CTRLMOD);
  plot5.activateZooming(1.2, CENTER, CENTER);

  //Setup Sixth Plot
  plot6 = new GPlot(this);
  plot6.setPos(0.783*width, 0.523*height);
  plot6.setOuterDim(0.190*width, 0.431*height);
  plot6.getTitle().setText("Altitud (m)");
  plot6.getXAxis().getAxisLabel().setText("Tiempo (s)");
  plot6.getYAxis().getAxisLabel().setText("Altitud (m)");
  plot6.activatePanning();
  plot6.activatePointLabels();
  plot6.activateReset(RIGHT, GPlot.CTRLMOD);
  plot6.activateZooming(1.2, CENTER, CENTER);
}

void draw(){
  image (bg, 0, 0);
  
  noStroke();
  fill(color(237, 241, 242, 220));
  rect(0.026*width, 0.046*height, 0.298*width, 0.331*height, 15);       //opciones
  rect(0.026*width, 0.423*height, 0.298*width, 0.531*height, 15);       //GPS
  rect(0.351*width, 0.046*height, 0.298*width, 0.431*height, 15);       //metano
  rect(0.675*width, 0.046*height, 0.298*width, 0.431*height, 15);       //co2
  rect(0.351*width, 0.523*height, 0.190*width, 0.431*height, 15);       //temperatura
  rect(0.567*width, 0.523*height, 0.190*width, 0.431*height, 15);       //presión
  rect(0.783*width, 0.523*height, 0.190*width, 0.431*height, 15);       //altitud
  
  textAlign(CENTER);
  textSize(0.0463*height);
  fill(0);
  text("Tiempo", 0.1302*width, 0.081*height);
  text(seconds, 0.1302*width, 0.141*height);
  
  textSize(0.01*height);
  text(text, 0.1302*width, 0.241*height);
   
  //Draw First Plot (Methane)
  plot1.addPoint(seconds, methane, "(" + str(seconds) + " , " + str(methane) + ")");
  plot1.beginDraw();
  plot1.drawBox();
  plot1.drawXAxis();
  plot1.drawYAxis();
  plot1.drawTitle();
  plot1.drawGridLines(GPlot.BOTH);
  plot1.drawLines();
  plot1.drawPoints();
  plot1.drawLabels();
  plot1.endDraw();

  //Draw Second Plot (CO2)
  plot2.addPoint(seconds, co2, "(" + str(seconds) + " , " + str(co2) + ")");
  plot2.beginDraw();
  plot2.drawBox();
  plot2.drawXAxis();
  plot2.drawYAxis();
  plot2.drawTitle();
  plot2.drawGridLines(GPlot.BOTH);
  plot2.drawLines();
  plot2.drawPoints();
  plot2.drawLabels();
  plot2.endDraw();
  
  //Draw Third Plot (GPS position)
  plot3.addPoint(latitude, longitude, "(" + str(latitude) + " , " + str(longitude) + ")");
  plot3.beginDraw();
  plot3.drawBox();
  plot3.drawXAxis();
  plot3.drawYAxis();
  plot3.drawTitle();
  plot3.drawGridLines(GPlot.BOTH);
  plot3.drawLines();
  plot3.drawPoints();
  plot3.drawLabels();
  plot3.endDraw();
  
  //Draw Fourth Plot (Temperature)
  plot4.addPoint(seconds, temperature, "(" + str(seconds) + " , " + str(temperature) + ")");
  plot4.beginDraw();
  plot4.drawBox();
  plot4.drawXAxis();
  plot4.drawYAxis();
  plot4.drawTitle();
  plot4.drawGridLines(GPlot.BOTH);
  plot4.drawLines();
  plot4.drawPoints();
  plot4.drawLabels();
  plot4.endDraw();
  
  //Draw Fifth Plot (Pressure)
  plot5.addPoint(seconds, pressure, "(" + str(seconds) + " , " + str(pressure) + ")");
  plot5.beginDraw();
  plot5.drawBox();
  plot5.drawXAxis();
  plot5.drawYAxis();
  plot5.drawTitle();
  plot5.drawGridLines(GPlot.BOTH);
  plot5.drawLines();
  plot5.drawPoints();
  plot5.drawLabels();
  plot5.endDraw();

  //Draw Sixth Plot (Altitude)
  plot6.addPoint(seconds, altitude, "(" + str(seconds) + " , " + str(altitude) + ")");
  plot6.beginDraw();
  plot6.drawBox();
  plot6.drawXAxis();
  plot6.drawYAxis();
  plot6.drawTitle();
  plot6.drawGridLines(GPlot.BOTH);
  plot6.drawLines();
  plot6.drawPoints();
  plot6.drawLabels();
  plot6.endDraw();
}

void serialEvent (Serial myPort) {
  text = myPort.readString();
  
  if (text != null){
    String[] text_value = text.split(",");
    float[] value= new float[text_value.length];
    for(int counter = 0; counter<text_value.length; counter++ ){
      value[counter]=parseFloat(text_value[counter]);
      }
      
    if (value.length == 8) {
      seconds = value[0];
      temperature = value[1];
      pressure = value[2];
      altitude = value[3];
      latitude = value[4];
      longitude = value[5];
      methane = value[6];
      co2 = value[7];
    }
  }
}
