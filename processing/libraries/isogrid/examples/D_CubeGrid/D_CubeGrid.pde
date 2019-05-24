import wblut.isogrid.*;

WB_IsoCubeGrid cubes;
PShape faces,edges;

void setup() {
  size(1000, 1000, P3D);
  smooth(8);  
  cubes=WB_IsoCubeGrid.createGrid(0.0,0.0,0.0,10,10,10,50.0,50.0,50.0);//center x, center y, center z, number of cubes (10,10,10),cube size (50.0,50.0,50.0)
  for(int i=0;i<10;i++){
    for(int j=0;j<10;j++){
      for(int k=0;k<10;k++){
        if(random(100)<25) cubes.set(i,j,k);
      }
    }
  }
  
  faces=cubes.createPShape(this);
  faces.disableStyle();
  edges=cubes.createWireframePShape(this);
  edges.disableStyle();
}

void draw() {
  background(255);
  translate(width/2,height/2);
  pointLight(255, 255, 255, 1000, 0, 0);
   pointLight(255, 255, 255, -500, 0, 1000);
   pointLight(255, 255, 255, 0, 500, -1000);
  rotateX(map(mouseY,0,height,PI,-PI));
  rotateY(map(mouseX,0,width,-PI,PI));
  fill(255);
  noStroke();
  shape(faces);
  strokeWeight(1);
  stroke(0);
  noFill();
  shape(edges);
}
