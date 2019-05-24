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
      grid.drawLabel(this,q,r,12,4);
    }
  }
  strokeWeight(1);
  noFill();
  
  //Triangular grid contains 3 hexagonal grids. One grid where q+r is a multiple of 3, one where q+r is 1 larger than a multiple of 3, and a third one where q+r is 2 larger than a multiple of 3.
  
  stroke(255,165,0);
  for (int q=-8; q<=8; q++) {
    for (int r=-8; r<=8; r++) {
      if((q+r)%3==0) grid.drawHex(this,q,r);//(q+r) is a multiple of 3
    }
  }
  
   stroke(255,0,255);
  for (int q=-8; q<=8; q++) {
    for (int r=-8; r<=8; r++) {
      if((q+r)%3==1 || (q+r)%3==-2) grid.drawHex(this,q,r); //(q+r) is 1 larger, or 2 smaller, than a multiple of 3
    }
  }
  
   stroke(0,255,255);
  for (int q=-8; q<=8; q++) {
    for (int r=-8; r<=8; r++) {
      if((q+r)%3==2 || (q+r)%3==-1) grid.drawHex(this,q,r);//(q+r) is 2 larger, or 1 smaller, than a multiple of 3
    }
  }

}
