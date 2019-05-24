import wblut.isogrid.*;

WB_IsoHexGrid grid;
color[] colors;
void setup() {
  size(1000, 1000, P3D);
  smooth(8);  
  grid=new WB_IsoHexGrid(500.0, 500.0, 100.0, 100.0);//center x, center y, scale x, scale y
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
      grid.drawLabel(this, q, r, 12, 4);
    }
  }
  strokeWeight(1);
  noFill();

  stroke(0);
  for (int q=-8; q<=8; q++) {
    for (int r=-8; r<=8; r++) {
        for (int i=0; i<6; i++) {
          grid.drawTriangle(this, q, r, 0);// q,r is the center of the hexagon, 0 is the triangle to draw (0-5)
      }
    }
  }
}
