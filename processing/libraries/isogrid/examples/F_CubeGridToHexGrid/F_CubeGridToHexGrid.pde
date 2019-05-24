import wblut.isogrid.*;

WB_IsoCubeGrid cubes;
WB_IsoHexGrid grid;
color[] colors;
void setup() {
  size(1000, 1000, P3D);
  smooth(8);  
  createCubeGrid();
  grid=new WB_IsoHexGrid(500.0, 500.0, 50.0, 50.0);//center x, center y, scale x, scale y
  grid.addGrid(cubes);
  grid.collectLines();
}

void createCubeGrid(){
  cubes=WB_IsoCubeGrid.createGrid(0.0,0.0,0.0,10,10,10,50.0,50.0,50.0);//center x, center y, center z, number of cubes (10,10,10),cube size (50.0,50.0,50.0)
  for(int i=0;i<10;i++){
    for(int j=0;j<10;j++){
      for(int k=0;k<10;k++){
        if(random(100)<50) cubes.set(i,j,k);
      }
    }
  }
  
  grid=new WB_IsoHexGrid(500.0, 500.0, 50.0, 50.0);//center x, center y, scale x, scale y
  grid.addGrid(cubes);
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
}

void mousePressed(){
  createCubeGrid();
  grid.addGrid(cubes);
  grid.collectLines();
}
