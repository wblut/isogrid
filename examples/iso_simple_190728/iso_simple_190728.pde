import wblut.isogrid.*;
import processing.pdf.*;
import processing.svg.*;
import java.util.*;
IsoSystem iso;

String name;
String operators;
String creation;
int maxIJK;
boolean saveFrame, savePDF, saveSVG;
float stroke;
PrintWriter param;
int I, J, K, mini, maxi, minj, maxj, mink, maxk;
int offset;
float scale;
int seed;
color[] colors;

boolean FADE;
boolean GUI;

int angle=0;
float tw, th;

int min, max;
void setup() {
  fullScreen(P3D);
  smooth(8);
  noCursor();
  I=K=128;
  J=128;
  mini=0;
  minj=0;
  mink=0;
  maxi=I;
  maxj=J;
  maxk=K;
  offset=0;
  scale=3.0;
  seed=(int)random(1000000);
  noiseSeed(seed);
  randomSeed(seed);
 
  createColors();
  iso=new IsoSystem(scale, I, J, K, 0, 0, colors, seed, this);
  creation=iso.seed+"-"+I+"/"+J+"/"+K;
  operators=System.lineSeparator();
  maxIJK=max(I, J, K);
  GUI=true;
}


void draw() {
  if (saveFrame ) {
    if (savePDF) {
      println("Begin record PDF");
      beginRecord(PDF, "saves/"+name+"/vector.pdf");
    } else if (saveSVG) {
      println("Begin record SVG");
      beginRecord(SVG, "saves/"+name+"/vector.svg");
    } else {
      save("saves/"+name+"/screenshot.png");
      PrintWriter pw=createWriter("saves/"+name+"/parameters.txt");
      pw.println( iso.seed+"-"+I+"/"+J+"/"+K+operators);
      pw.flush();
      pw.close();
    }
    stroke=0.25;
    translate(width/2+tw, height/2+th);
    rotate(radians(angle));
    scale(1.0, -1.0);
    background(255);
    noFill();
    strokeWeight(2*stroke);
    stroke(0);
    iso.drawEdges();
    if (saveFrame == true) {
      if (!savePDF && ! saveSVG) {
        savePDF=true;
      } else if (! saveSVG) {
        println("End record PDF");
        endRecord(); 
        savePDF=false;
        saveSVG=true;
      } else {
        println("End record SVG");
        endRecord(); 
        saveFrame=false;
        saveSVG=false;
        save("saves/"+name+"/"+name+".png");
      }
    }
  } else {
    ortho();
    background(15);

    pushMatrix();
    translate(width/2+tw, height/2+th);
    rotate(radians(angle));
    scale(1.0, -1.0); 
    noStroke();

    iso.drawFaces(-2*maxIJK, 2*maxIJK);
    strokeWeight(1);
    stroke(0);
    iso.drawEdges();
    popMatrix();
    if(GUI) GUI();
  }
}
