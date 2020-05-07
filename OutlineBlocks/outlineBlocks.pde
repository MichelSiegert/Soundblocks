// Library importieren
import ddf.minim.*;

// Objekte erstellen
Minim minim;
AudioPlayer input;

float maxZ = 1000;
float xDif=0, yDif=random (0, 10000), inc=0.005;
int numCubes=1500;
float intensity;
Cube[] cubes;

void setup()
{
  fullScreen(P3D);

  smooth();
  noStroke();

  minim = new Minim(this);

  input = minim.loadFile("http://stream.electroradio.fm/192k");


  input.play();

  cubes = new Cube[numCubes];
  for (int i=0; i<numCubes; i++)
  {
    cubes[i] = new Cube();
  }
}

void draw()
{
  background (0, 0,0x22, 5);
  intensity= 0;
  yDif=0;
  xDif += inc;
  float[] buffer = input.mix.toArray();
  for (int i=0; i < numCubes; i++)
  {
    yDif += inc;
    intensity +=abs( buffer[(int)map(i, 0, numCubes, 1, buffer.length)]/(i+1))*5;
    cubes[i].display(buffer[(int)map(i, 0, numCubes, 1, buffer.length)], intensity);
  }
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

  Cube()
  {
    x = random (width*-2, width*2);
    y = random (height*-2, height*2);
    z = random(startingZ, maxZ);
    size = random(25, 125);
    rotX = random(-1, 1);
    rotY = random(-1, 1);
    rotZ = random(-1, 1);
  }

  void display(float audio, float inten)
  {
    fill(0);
    stroke(0xff);
    pushMatrix();
    translate (x, y, z);

    sumRotX += inten * (rotX / 1000);
    sumRotY += inten * (rotY / 1000);
    sumRotZ += inten * (rotZ / 1000);

    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);

    //play around w/ this alot. ^
    cRed =  (((noise(xDif, yDif)*audio*0x300))+pRed)*4/5;
    cGreen= (((noise(yDif)*audio*0x300))+pGreen)*4/5;
    cBlue=  (((audio*0x200)%256)+pBlue)*3/4;

    fill(cRed, cGreen, cBlue, 
      //alpha
      map(inten, 0, 10, 0, 0xff));

    box(size+size*inten/50);
    popMatrix();
    z+=2*inten;

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
