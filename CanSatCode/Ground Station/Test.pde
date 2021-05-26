static final byte ROJO=0,VERDE=1,AZUL=2,OPACIDAD=3;
static final int CANTIDAD_SENSORES=3;
static final int CANTIDAD_VALORES=20;
static final String NOMBRE_FONDO="fondo.png";
static final int[][] COLOR_LINEA={{0x44,0x88,0xCC,0xFF},{0xFF,0xAA,0x00,0xFF},{0xCC,0x44,0xAA,0xFF}};
static final int[][] COLOR_AREA={{0x44,0x88,0xCC,0x88},{0xFF,0xAA,0x00,0x88},{0xCC,0x44,0xAA,0x88}};
static final int[] COLOR_FONDO={0xFF,0xFF,0XFF};
static final float GROSOR_LINEA=2.0;
static final float DIAMETRO_MARCA=8.0;
static final float VALOR_MINIMO=0.0; // Valor mínimo de la suma de todos los componentes
static final float VALOR_MAXIMO=100.0; // Valor máximo de la suma de valores
static final String SEPARADOR="\t"; // Los datos de cada sensor se separan con un tabulador
static final char TERMINADOR=10; // Cada grupo de datos se termina con un código ASCII 10 → Nueva línea → \n
 
Serial conexion_sensores;
float[][] valor_sensor=new float[CANTIDAD_SENSORES][CANTIDAD_VALORES];
float coeficiente_valor;
float[] vertical_area=new float[CANTIDAD_VALORES];
float[] vertical_marca=new float[CANTIDAD_VALORES];
PImage fondo;
 
void setup()
{
  size(792,396,P2D); // El tamaño de la ventana no se puede establecer con variables en setup (usar settings)
  surface.setResizable(false);
  surface.setTitle("consumo relativo comparado");
  noLoop();
  smooth(4);
  conexion_sensores=new Serial(this,"/dev/ttyUSB1",9600);
  conexion_sensores.bufferUntil(TERMINADOR);
  for(int numero_sensor=0;numero_sensor<CANTIDAD_SENSORES;numero_sensor++)
  {
    for(int numero_valor=0;numero_valor<CANTIDAD_VALORES;numero_valor++)
    {
      valor_sensor[numero_sensor][numero_valor]=0.0;
    }
  }
  fondo=loadImage(NOMBRE_FONDO);
  coeficiente_valor=height/(VALOR_MAXIMO-VALOR_MINIMO);
  //strokeCap(ROUND); // El modo del final de líneas por defecto es redondeado
  //ellipseMode(CENTER); // Por defecto el modo de elipse es desde el centro
  if(DIAMETRO_MARCA>GROSOR_LINEA) // Si la marca no es visible hay que configurar el tipo de esquina
  {
    strokeJoin(ROUND); // El modo de esquina por defecto es en ángulo
  }
}
 
void draw()
{
  for(int numero_valor=0;numero_valor<valor_sensor[0].length;numero_valor++)
  {
    vertical_area[numero_valor]=height;
    for(int numero_sensor=0;numero_sensor<valor_sensor.length;numero_sensor++)
    {
      vertical_area[numero_valor]-=(valor_sensor[numero_sensor][numero_valor]-VALOR_MINIMO)*coeficiente_valor;
    }
    vertical_marca[numero_valor]=vertical_area[numero_valor];
  }
  if(fondo==null)
  {
    background(COLOR_FONDO[ROJO],COLOR_FONDO[VERDE],COLOR_FONDO[AZUL]);
  }
  else
  {
    image(fondo,0,0);
  }
  strokeWeight(GROSOR_LINEA);
  for(int numero_sensor=0;numero_sensor<valor_sensor.length;numero_sensor++)
  {
    stroke
    (
      COLOR_LINEA[numero_sensor][ROJO],
      COLOR_LINEA[numero_sensor][VERDE],
      COLOR_LINEA[numero_sensor][AZUL],
      COLOR_LINEA[numero_sensor][OPACIDAD]
    );
    fill
    (
      COLOR_AREA[numero_sensor][ROJO],
      COLOR_AREA[numero_sensor][VERDE],
      COLOR_AREA[numero_sensor][AZUL],
      COLOR_AREA[numero_sensor][OPACIDAD]
    );
    beginShape();
    for(int numero_valor=valor_sensor[numero_sensor].length-1;numero_valor>=0;numero_valor--)
    {
      vertex(numero_valor*width/(valor_sensor[numero_sensor].length-1),vertical_area[numero_valor]);
    }
    for(int numero_valor=0;numero_valor<valor_sensor[numero_sensor].length;numero_valor++)
    {
      vertical_area[numero_valor]+=(valor_sensor[numero_sensor][numero_valor]-VALOR_MINIMO)*coeficiente_valor;
      vertex(numero_valor*width/(valor_sensor[numero_sensor].length-1),vertical_area[numero_valor]);
    }
    endShape(CLOSE);
    if(DIAMETRO_MARCA>0)
    {
      noStroke();
      fill
      (
        COLOR_LINEA[numero_sensor][ROJO],
        COLOR_LINEA[numero_sensor][VERDE],
        COLOR_LINEA[numero_sensor][AZUL],
        COLOR_LINEA[numero_sensor][OPACIDAD]
      );
      for(int numero_valor=0;numero_valor<valor_sensor[numero_sensor].length;numero_valor++)
      {
        ellipse
        (
          numero_valor*width/(valor_sensor[numero_sensor].length-1),
          vertical_marca[numero_valor],
          DIAMETRO_MARCA,
          DIAMETRO_MARCA
        );
        vertical_marca[numero_valor]=vertical_area[numero_valor];
      }
    }
  }
}
 
void stop() // Al terminar un Applet. No hay garantía de que se ejecute y, como estas operaciones se realizan al terminar, en realidad no son necesarias y solo se incluyen para recordar el uso de clear y stop
{
  conexion_sensores.clear(); // Solo para ilustrar la posibilidad de borrar los datos que queden en el buffer
  conexion_sensores.stop(); // Solo para ilustrar la posibilidad de terminar las comunicaciones serie y liberar el puerto que se está usando
}
 
void serialEvent(Serial serie)
{
  String[] texto_valor=serie.readString().split(SEPARADOR);
  float[] valor=new float[texto_valor.length];
  for(int numero_valor=0;numero_valor<texto_valor.length;numero_valor++)
  {
    valor[numero_valor]=parseFloat(texto_valor[numero_valor]);
  }
  nuevo_valor(valor_sensor,valor);
  redraw();
}
 
void nuevo_valor(float[][] valor_sensor, float[] valor)
{
  for(int numero_sensor=0; numero_sensor<valor_sensor.length; numero_sensor++)
  {
    for(int numero_valor=1; numero_valor<valor_sensor[0].length; ++)
    {
      valor_sensor[numero_sensor][numero_valor-1]=valor_sensor[numero_sensor][numero_valor];
    }
    valor_sensor[numero_sensor][valor_sensor[0].length-1]=valor[numero_sensor];
  }
}