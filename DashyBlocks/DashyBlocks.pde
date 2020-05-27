// Library importieren
import ddf.minim.*;

// Objekte erstellen
Minim minim;
AudioPlayer input;

PImage img;
float maxZ = 1000;
float xDif=0, yDif=random (0, 10000), inc=0.005;
int numCubes=1024;
float intensity;
Cube[] cubes;

void setup()
{
  fullScreen(P3D);

  img = loadImage("PIC0.jpg");
  img.resize(width,height);
  smooth();
  noStroke();

  minim = new Minim(this);

  input = minim.loadFile("http://stream.electroradio.fm/192k");


  input.play();

  cubes = new Cube[numCubes];
  for (int i=0; i<(int)Math.sqrt(numCubes); i++)
  {
    for (int j=0; j<(int)Math.sqrt(numCubes); j++)
    {
      color c = img.get((int)(i*width/Math.sqrt(numCubes)),(int)((j*height/Math.sqrt(numCubes))));
      cubes[i+j*(int)Math.sqrt(numCubes)] = new Cube(
      (int)map(i,0,(float)Math.sqrt(numCubes),0,width),
      (int)map(j,0,(float)Math.sqrt(numCubes),0,height),c);
    }
  }
}

void draw()
{
  background (0, 0,0x22, 5);
  intensity = 0;
  yDif=0;
  xDif += inc;
  float[] buffer = input.mix.toArray();
  for (int i=0; i < numCubes; i++)
  {
    yDif += inc;
    intensity =abs( buffer[(int)map(i, 0, numCubes, 1, buffer.length)])*10;
    cubes[i].display(buffer[(int)map(i, 0, numCubes, 1, buffer.length)], intensity);
  }
}

class Cube
{
  float startingZ = -10000;
  float maxZ = 1000;
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
    z= -100+inten*10;
    pushMatrix();
    translate (x, y, z);

    sumRotX += inten * (rotX / 100);
    sumRotY += inten * (rotY / 100);
    sumRotZ += inten * (rotZ / 100);

    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    fill(red(c),
    green(c),
    blue(c), 
      //alpha
      map(inten, 0,20, 0x88, 0xff));
    box(map(brightness(c),0,255,5,25));
    popMatrix();

    if (z >= maxZ)
    {
      x = random (width*-2, width*2);
      y = random (height*-2, height*2);
      z = startingZ;
    }
  }
}
