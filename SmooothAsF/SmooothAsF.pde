  // Library importieren
import ddf.minim.*;

// Objekte erstellen
Minim minim;
AudioPlayer input;

PImage img;
float maxZ = 1000;
float xDif=0, yDif=random (0, 10000), inc=0.005;
int numCubes=1024, sqrtCubes= (int)Math.sqrt(numCubes);
float intensity;
int counter=0;
Cube[] cubes;

void setup()
{
  
  background (0xff);
  fullScreen(P3D);
   pickImg();
  smooth();
  noStroke();

  minim = new Minim(this);

  input = minim.loadFile("http://stream.electroradio.fm/192k");


  input.play();

  cubes = new Cube[numCubes];
  for (int i=0; i<(int)sqrtCubes; i++)
  {
    for (int j=0; j<(int)sqrtCubes; j++)
    {
      color c = img.get((int)(i*width/sqrtCubes),(int)((j*height/sqrtCubes)));
      cubes[i+j*sqrtCubes] = new Cube(
      (int)map(i,0,(float)sqrtCubes,0,width),
      (int)map(j,0,(float)sqrtCubes,0,height),c);
    }
  }
}

void draw()
{
  intensity = intensity/4*3;
  yDif=0;
  xDif += inc;
  float[] buffer = input.mix.toArray();
  for (int i=0; i< sqrtCubes; i++)
  {
    for (int j=0; j < sqrtCubes; j++)
    {
    yDif += inc;
    intensity +=abs( buffer[(int)map(i * sqrtCubes + j, 0, numCubes, 1, buffer.length)]/(i*sqrtCubes+j+1))*2;
    cubes[i*sqrtCubes+j].display(buffer[(int)map(i * sqrtCubes + j, 0, numCubes, 1, buffer.length)], intensity);
  }
  }
  saveFrame("screenshots/sceen_#####.tif");
}

class Cube
{
  float startingZ = -10000;
  float maxZ = 1000;

  float cRed=0, cGreen=0, cBlue=0;
  float pRed=0, pGreen=0, pBlue=0;

  float x, y, z;
  float size;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  color c;

  Cube(int x1, int y1, color c1)
  {
    x =x1;
    y = y1;
    z = 0;
    size = 15;
    rotX = random(-3, 3);
    rotY = random(-3, 3);
    rotZ = random(-3, 3);
    this.c = c1;
  }

  void display(float audio, float inten)
  {
    fill(0);
    noStroke();
    z= -100+inten;
    pushMatrix();
    translate (x, y, z);

    sumRotX += inten * (rotX / 2000);
    sumRotY += inten * (rotY / 2000);
    sumRotZ += inten * (rotZ / 2000);

    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);

    fill(red(c),
    green(c),
    blue(c), 
      //alpha
      map(inten, 0,20, 0x44, 0xbb));
    box(size+size*inten/2);
    popMatrix();

    pRed = cRed;
    pGreen =cGreen;
    pBlue = cBlue;

    if (z >= maxZ)
    {
      x = random (width*-2, width*2);
      y = random (height*-2, height*2);
      z = startingZ;
    }
  }
  
  void setColor(color c1)
  {
    this.c = c1;
  }
}

void mouseClicked() 
{
  pickImg();
  
    for (int i=0; i< sqrtCubes; i++)
  {
    for (int j=0; j < sqrtCubes; j++)
    {
      color c = img.get((int)(i*width/sqrtCubes),(int)((j*height/sqrtCubes)));
      cubes[i+sqrtCubes*j].setColor(c);
    }
  }
}
void pickImg()
{
  int i= (int)random(4);
  img = loadImage("PIC"+i+".jpg");
  img.resize(width,height);
}
