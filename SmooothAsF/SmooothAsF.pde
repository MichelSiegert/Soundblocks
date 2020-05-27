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
  intensity = intensity/4*3;
  yDif=0;
  xDif += inc;
  float[] buffer = input.mix.toArray();
  for (int i=0; i < numCubes; i++)
  {
    yDif += inc;
    intensity +=abs( buffer[(int)map(i, 0, numCubes, 1, buffer.length)]/(i+1))*2;
    cubes[i].display(buffer[(int)map(i, 0, numCubes, 1, buffer.length)], intensity);
  }
  counter = (counter+1) % 200;
  if (counter ==0){pickImg();}
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

    //play around w/ this alot. ^
    cRed =  (cRed*49/50+noise(xDif, yDif)*audio*5/4)%1;
    cGreen= (cGreen*49/50 + noise(yDif)*audio*5/4)%1; 
    cBlue=  (cBlue*49/50+audio*1/3) %1;

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
}

void pickImg()
{
  int i= (int)random(2);
  img = loadImage("PIC"+i+".jpg");
  img.resize(width,height);
}
