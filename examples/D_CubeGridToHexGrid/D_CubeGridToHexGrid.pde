import wblut.isogrid.*;

boolean[][][] cubes;
WB_IsoHexGrid grid;
color[] colors;
void setup() {
  size(1000, 1000, P3D);
  smooth(8);  
  grid=new WB_IsoHexGrid(500.0, 500.0, 50.0, 50.0);//center x, center y, scale x, scale y
  createCubeGrid();
  addCubesToGrid();
  colors=new color[]{color(255, 255, 0), color(255, 0, 255), color(0, 255, 255)};
}

void createCubeGrid(){
  cubes=new boolean[10][10][10];
  for(int i=0;i<10;i++){
    for(int j=0;j<10;j++){
      for(int k=0;k<10;k++){
        cubes[i][j][k]= random(100)<50;
      }
    }
  }
}

void addCubesToGrid(){
  for(int i=0;i<10;i++){
    for(int j=0;j<10;j++){
      for(int k=0;k<10;k++){
        if(cubes[i][j][k]) grid.addCube(i,j,k);
      }
    }
  }
  grid.collectLines();
}

void draw() { 
  background(25);
  noStroke();
  grid.drawFragments(this, colors);
  strokeWeight(1);
  stroke(0);
  grid.drawLines(this);
}

void mousePressed(){
  grid=new WB_IsoHexGrid(500.0, 500.0, 50.0, 50.0);//center x, center y, scale x, scale y
  createCubeGrid();
  addCubesToGrid();
}
