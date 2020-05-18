// Library importieren
import ddf.minim.*;

// Objekte erstellen
Minim minim;
AudioPlayer input;

float maxY = 1000;
float xDif=0, yDif=random (0, 10000), inc=0.005;
int numCubes=1024;
float intensity;
Cube[] cubes;

void setup()
{
  fullScreen(P3D);
  strokeWeight(1);
  stroke(0xff);
  smooth();
  minim = new Minim(this);

  input = minim.loadFile("http://stream.electroradio.fm/192k");


  input.play();

  cubes = new Cube[numCubes];
  for (int i=0; i<numCubes; i++)
  {
    cubes[i] = new Cube(i);
  }
}

void draw()
{
  background (0, 0, 0x22, 5);
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
}

class Cube
{
  float startingY = -height;
  float maxY = height+600;
  float cRed=0, cGreen=0, cBlue=0;
  float pRed=0, pGreen=0, pBlue=0;

  float x, y, z;
  float size;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;  
  float posCounter=0;

  Cube(int position)
  {
    x = (int) map(position,0,numCubes,-width*2,width*2);
    z = random (-2000, -0);
    y = random(startingY,maxY);
    size = random(25, 50);
    rotX = random(-3, 3);
    rotY = random(-3, 3);
    rotZ = random(-3, 3);
  }

  void display(float audio, float inten)
  {
    fill(0);
    pushMatrix();
    translate (x, y, z);

    sumRotX += inten * (rotX / 1000);
    sumRotY += inten * (rotY / 1000);
    sumRotZ += inten * (rotZ / 1000);

    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);

    //play around w/ this alot. ^
    cRed =  (cRed*49/50+noise(xDif, yDif)*audio*5/4)%1;
    cGreen= (cGreen*49/50 + noise(yDif)*audio*5/4)%1; 
    cBlue=  (cBlue*49/50+audio*1/3) %1;

    fill(map(cRed, 0, 1, 0x33, 255), 
      map(cGreen, 0, 1, 0x33, 255), 
      map(cBlue, 0, 1, 0x33, 255), 
      //alpha
      map(inten, 0, 20, 0x00, 0xff));
    box(size+size*inten/50);
    popMatrix();
    x = 

    pRed = cRed;
    pGreen =cGreen;
    pBlue = cBlue;

    if (y >= maxY)
    {
      z = random (-2000, -0);
      y = -2000;
    }
  }
}
