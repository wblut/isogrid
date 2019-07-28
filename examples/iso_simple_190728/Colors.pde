void createColors() {
  colors=new int[20];
  
  float hsqrt2=sqrt(2.0)*0.5;
  float hsqrt3=sqrt(3.0)*0.5;

  float[][] normals=new float[3][3];

  normals[0]= new float[]{1, 0, 0};
  normals[1]= new float[]{0, 1, 0};
  normals[2]= new float[]{0, 0, 1};

  float[][]  light=new float[][]{

    {1, 0, 0, 255, 255, 0}, 
    {0, 1, 0, 0, 255, 255}, 
    {0, 0, 1, 255, 0, 255} 
  };


  for (int i=0; i<3; i++) {
    float red, green, blue, dot;
    red=green=blue=0;
    for (int l=0; l<3; l++) {
      dot=((i>6)?1.0:1.0)*max(0, normals[i][0]*light[l][0]+normals[i][1]*light[l][1]+normals[i][2]*light[l][2]);
      red+=dot*light[l][3];
      green+=dot*light[l][4];
      blue+=dot*light[l][5];
    }

    float max=max(red, green, blue);
    if (max>400.0) {
      red*=400.0/max; 
      green*=400.0/max; 
      blue*=400.0/max;
    }
    colors[i]=color(constrain(red, 0, 255), constrain(green, 0, 255), constrain(blue, 0, 255));
  }

  light=new float[][]{

    {1, 0, 0, 255, 255, 255}, 
    {0, 1, 0, 80, 80, 80}, 
    {0, 0, 1, 0, 0, 0} 
  };

  for (int i=0; i<3; i++) {
    float red, green, blue, dot;
    red=green=blue=0;
    for (int l=0; l<3; l++) {
      dot=max(0, normals[i][0]*light[l][0]+normals[i][1]*light[l][1]+normals[i][2]*light[l][2]);
      red+=dot*light[l][3];
      green+=dot*light[l][4];
      blue+=dot*light[l][5];
    }

    float max=max(red, green, blue);
    if (max>400.0) {
      red*=400.0/max; 
      green*=400.0/max; 
      blue*=400.0/max;
    }
    colors[i+3]=color(constrain(red, 0, 255), constrain(green, 0, 255), constrain(blue, 0, 255));
  }
}
