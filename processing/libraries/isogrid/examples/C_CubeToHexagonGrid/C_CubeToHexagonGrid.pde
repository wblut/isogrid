import wblut.isogrid.*;

WB_IsoHexGrid grid;
color[] colors;
void setup() {
  size(1000, 1000, P3D);
  smooth(8);  
  grid=new WB_IsoHexGrid(500.0, 500.0, 100.0, 100.0);
  grid.addCube(0,0,0);
  grid.collectLines();
  colors=new color[]{color(255, 255, 0), color(255, 0, 255), color(0, 255, 255)};
}

void draw() {
  background(255);
  noStroke();
  grid.drawTriangles(this, colors);
  strokeWeight(1);
  stroke(0);
  grid.drawLines(this);
  fill(0);
  strokeWeight(4);
  for (int q=-8; q<=8; q++) {
    for (int r=-8; r<=8; r++) {
      grid.drawPoint(this, q, r);
      grid.drawLabel(this,q,r,12,4);
    }
  }

}

void mousePressed() {
  for(int r=0;r<10;r++){
    int i=(int)random(-5, 5);
    int j=(int)random(-5, 5);
    grid.addCube(i, j, -i-j) ;
  }
  grid.collectLines();
}
