

import wblut.isogrid.*;
import processing.pdf.*;
import processing.svg.*;
import java.util.List;

IsoSystem iso;

String name;
String creation, operators;
int maxIJK;
boolean saveFrame, savePDF, saveSVG;
float stroke;
PrintWriter param;
int I, J, K;
float scale;
int seed;
color[] colors;

void setup() {
  fullScreen(P3D);
  smooth(8);
  I=128;
  J=128;
  K=128;
  scale=3.5;
  seed=(int)random(1000000);
  noiseSeed(seed);
  randomSeed(seed);
  colors=new color[]{color(255, 255, 0), color(0, 255, 255), color(255, 0, 255), color(255)};
  iso=new IsoSystem(scale, I, J, K, 0, 0, colors, seed, this);
  creation=iso.seed+"-"+I+"/"+J+"/"+K;
  operators="";
  maxIJK=max(I, J, K);
}


void draw() {
  if (saveFrame ) {
    if (savePDF) {
      beginRecord(PDF, "saves/"+name+"_vector.pdf");
    } else if (saveSVG){
      beginRecord(SVG, "saves/"+name+"_vector.svg");
    } else {
      save("saves/"+name+"_screenshot.png");
      PrintWriter pw=createWriter("saves/"+name+"_parameters.txt");
      pw.println(creation+operators);
      pw.flush();
      pw.close();
    }
    stroke=0.25;
    translate(width/2, height/2);
    scale(1.0, -1.0);
    background(255);
    noFill();
    strokeWeight(2*stroke);
    stroke(0);
    iso.drawEdges();
    if (saveFrame == true) {
      if (!savePDF && ! saveSVG) {
        savePDF=true;
      } if (! saveSVG) {
        endRecord(); 
         savePDF=false;
        saveSVG=true;
      } else {
        endRecord(); 
        saveFrame=false;
        saveSVG=false;
      }
    }
  } else {
    ortho();
    background(255);  

    hint(ENABLE_DEPTH_TEST);
    pushMatrix();
    translate(width/2, height/2);
    scale(1.0, -1.0); 
    pointLight(255, 255, 255, 1000, 0, 0);
    pointLight(255, 255, 255, -500, 0, 1000);
    pointLight(255, 255, 255, 0, 500, -1000);
    rotateX(asin(1.0/sqrt(3.0)));
    rotateY(-QUARTER_PI);//+radians(frameCount*0.125));
    noStroke();
    fill(255);
    noStroke();
    shape(iso.faces[0]);
    shape(iso.faces[1]);
    shape(iso.faces[2]);
    strokeWeight(1);
    stroke(0);
    shape(iso.wire);
    popMatrix();
    hint(DISABLE_DEPTH_TEST);
    fill(0);
    GUI();
  }
}

void keyPressed() {
  if (key=='n') {
    noiseSeed(seed);
    randomSeed(seed);
    iso=new IsoSystem(scale, I, J, K, 0, 0, colors, seed, this);
    creation=iso.seed+"-"+I+"/"+J+"/"+K;   
    operators="";
  } else if (key=='N') {
    seed=(int)random(1000000);
    noiseSeed(seed);
    randomSeed(seed);
    iso=new IsoSystem(scale, I, J, K, 0, 0, colors, seed, this);
    creation=iso.seed+"-"+I+"/"+J+"/"+K;   
    operators="";
  } else {
    if (key==' ') {
      saveFrame = true;
      java.util.Date dNow = new java.util.Date( );
      java.text.SimpleDateFormat ft = new java.text.SimpleDateFormat ("yyyy_MM_dd_HHmmss_S");
      name="iso"+"_"+ft.format(dNow);
    } else if (key=='q') {
      iso.refineGrid();
      iso.mapCubeGridToHexGrid();
      operators="-q";
    } else if (key=='e') {
      iso.edgeGrid(32, 50);
      iso.mapCubeGridToHexGrid();
      operators+="-e/32/50";
    } else if (key=='E') {
      iso.edgeGrid(maxIJK, 101);
      iso.mapCubeGridToHexGrid();
      operators+="-E";
    } else if (key=='w') {
      iso.wireGrid(36, 12.5);
      iso.mapCubeGridToHexGrid();
      operators+="-w/36/12.5";
    } else if (key=='W') {
      iso.wireGrid(maxIJK, 101);
      iso.mapCubeGridToHexGrid();
      operators+="-W";
    } else if (key=='s') {
      iso.sliceIGrid(32, 25);
      iso.mapCubeGridToHexGrid();
      operators+="-s/32/25";
    } else if (key=='S') {
      iso.sliceIGrid(maxIJK, 100);
      iso.mapCubeGridToHexGrid();
      operators+="-S";
    } else if (key=='d') {
      iso.sliceJGrid(32, 25);
      iso.mapCubeGridToHexGrid();
      operators+="-d/32/25";
    } else if (key=='D') {
      iso.sliceJGrid(maxIJK, 100);
      iso.mapCubeGridToHexGrid();
      operators+="-D";
    } else if (key=='f') {
      iso.sliceKGrid(32, 25);
      iso.mapCubeGridToHexGrid();
      operators+="-f/32/25";
    } else if (key=='F') {
      iso.sliceKGrid(maxIJK, 100);
      iso.mapCubeGridToHexGrid();
      operators+="-F";
    } else if (key=='z') {
      iso.invert();
      iso.mapCubeGridToHexGrid();
      operators+="-z";
    } else if (key=='a') {
      iso.noise();
      iso.mapCubeGridToHexGrid();
      operators+="-a";
    } else if (key=='1') {
      iso.refineRandomGrid(128, 20.0, 50.0, true);
      iso.mapCubeGridToHexGrid();
      operators+="-1";
    } else if (key=='2') {
      iso.refineRandomGrid(64, 20.0, 50.0, true);
      iso.mapCubeGridToHexGrid();
      operators+="-2";
    } else if (key=='3') {
      iso.refineRandomGrid(32, 20.0, 50.0, true);
      iso.mapCubeGridToHexGrid();
      operators+="-3";
    } else if (key=='4') {
      iso.refineRandomGrid(16, 20.0, 50.0, true);
      iso.mapCubeGridToHexGrid();
      operators+="-4";
    } else if (key=='5') {
      iso.refineRandomGrid(8, 20.0, 50.0, true);
      iso.mapCubeGridToHexGrid();
      operators+="-5";
    } else if (key=='6') {
      iso.refineRandomGrid(4, 20.0, 50.0, true);
      iso.mapCubeGridToHexGrid();
      operators+="-6";
    } else if (key=='7') {
      iso.refineRandomGrid(2, 20.0, 50.0, true);
      iso.mapCubeGridToHexGrid();
      operators+="-7";
    } else if (key=='k') {
      iso.rotateI();
      iso.mapCubeGridToHexGrid();
      operators+="-k";
    } else if (key=='l') {
      iso.rotateJ();
      iso.mapCubeGridToHexGrid();
      operators+="-l";
    } else if (key=='m') {
      iso.rotateK();
      iso.mapCubeGridToHexGrid();
      operators+="-m";
    } else if (key=='u') {
      iso.mirrorI();
      iso.mapCubeGridToHexGrid();
      operators+="-u";
    } else if (key=='i') {
      iso.mirrorJ();
      iso.mapCubeGridToHexGrid();
      operators+="-i";
    } else if (key=='o') {
      iso.mirrorK();
      iso.mapCubeGridToHexGrid();
      operators+="-o";
    } else if (key=='p') {
      iso.mirrorIK();
      iso.mapCubeGridToHexGrid();
      operators+="-p";
    }
    println(creation+operators);
  }
}
