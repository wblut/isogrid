void keyPressed() {
  if (key == 'z') {
    offset++;
  } else if (key =='c') {
    offset--;
  } else if (key == 'q') {
    angle=(angle+30)%360;
  } else if (key == 'e') {
    angle=((angle-30)%360+360)%360;
  } else if (key =='a') {
    tw-=10;
  } else if (key == 'd') {
    tw+=10;
  } else if (key == 'w') {
    th-=10;
  } else if (key == 's') {
    th+=10;
  } else if (key=='x') {
    iso.invert();
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="invert"+System.lineSeparator();
  } else if (key=='+') {
    scale*=1.1f; 
    iso.grid.setSize(scale, scale);
  } else if (key=='-') {
    scale*=0.9f; 
    iso.grid.setSize(scale, scale);
  } else if (key=='1') {
    iso.subdivideRandomGrid(128, 25f, 50.0f, 0.0f);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="subdivide 128/25/50/0"+System.lineSeparator();
  } else if (key=='2') {
    iso.subdivideRandomGrid(64, 25f, 50.0f, 0.0f);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="subdivide 64/25/50/0"+System.lineSeparator();
  } else if (key=='3') {
    iso.subdivideRandomGrid(32, 25f, 50.0f, 0.0f);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="subdivide 32/25/50/0"+System.lineSeparator();
  } else if (key=='4') {
    iso.subdivideRandomGrid(16, 25f, 50.0f, 0.0f);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="subdivide 16/25/50/0"+System.lineSeparator();
  } else if (key=='5') {
    iso.subdivideRandomGrid(8, 25f, 50.0f, 0.0f);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="subdivide 8/25/50/0"+System.lineSeparator();
  } else if (key=='6') {
    iso.subdivideRandomGrid(4, 25f, 35.0f, -40.0f);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="subdivide 4/25/50/0"+System.lineSeparator();
  } else if (key=='7') {
    iso.subdivideRandomGrid(2, 25.0f, 50.0f, 0.0f);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="subdivide 2/25/50/0"+System.lineSeparator();
  } else if (key=='8') {
    iso.subdivideGrid();
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="subdivide 64-32-16-8-4/50-40-30-20-1/50-50-50-50-20/0"+System.lineSeparator();
  } else if (key=='9') {
    maze(8, 16, 16, 16);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="maze 8/16/16/16"+System.lineSeparator();
  } else if (key=='0') {
    iso.noise(1, 1, 1, 0.04, 0.04, 0.04, 0.60);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="noise 1/1/1/0.04/0.04/0.04/0.6"+System.lineSeparator();
  } else if (key=='r') {
    iso.edgeGrid(32, 50);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="edge 32/50"+System.lineSeparator();
  } else if (key=='R') {
    iso.edgeGrid(maxIJK, 101);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="edge ALL"+System.lineSeparator();
  } else if (key=='t') {
    iso.wireGrid(32, 25.0f);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="wire 32/25"+System.lineSeparator();
  } else if (key=='T') {
    iso.wireGrid(maxIJK, 101);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="wire ALL"+System.lineSeparator();
  } else if (key=='y') {
    iso.flip();
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="flip"+System.lineSeparator();
  } else if (key=='u') {
    iso.mirrorI();
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="mirror I"+System.lineSeparator();
  } else if (key=='i') {
    iso.mirrorJ();
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="mirror J"+System.lineSeparator();
  } else if (key=='o') {
    iso.mirrorK();
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="mirror K"+System.lineSeparator();
  } else if (key=='p') {
    iso.mirrorIK();
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="mirror IK"+System.lineSeparator();
  } else if (key=='f') {
    FADE=!FADE;
  } else if (key=='g') {
    GUI=!GUI;
  }else if (key=='h') {
    iso.hollowGrid(32, 25);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="hollow 32/25"+System.lineSeparator();
  } else if (key=='H') {
    iso.hollowGrid(maxIJK, 100);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="hollow ALL"+System.lineSeparator();
  } else if (key=='j') {
    DUAL=!DUAL;
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="dual"+System.lineSeparator();
  } else if (key=='k') {
    iso.rotateI();
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="rotate I"+System.lineSeparator();
  } else if (key=='l') {
    iso.rotateJ();
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="rotate J"+System.lineSeparator();
  } else if (key==';') {
    iso.rotateK();
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="rotate K"+System.lineSeparator();
  } else if (key=='n') {
    noiseSeed(seed);
    randomSeed(seed);
    iso=new IsoSystem(scale, I, J, K, 0, 0, colors, seed, this);
    creation=iso.seed+"-"+I+"/"+J+"/"+K;
    operators=System.lineSeparator();
  } else if (key=='N') {
    seed=(int)random(1000000);
    noiseSeed(seed);
    randomSeed(seed);
    iso=new IsoSystem(scale, I, J, K, 0, 0, colors, seed, this);
    creation=iso.seed+"-"+I+"/"+J+"/"+K;
    operators=System.lineSeparator();
  } else if (key=='m') {
    iso.sliceIGrid(72, 25);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="slice I 72/25"+System.lineSeparator();
  } else if (key=='M') {
    iso.sliceIGrid(maxIJK, 100);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="slice I ALL"+System.lineSeparator();
  } else if (key==',') {
    iso.sliceJGrid(32, 25);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="slice J 32/25"+System.lineSeparator();
  } else if (key=='<') {
    iso.sliceJGrid(maxIJK, 100);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="slice J ALL"+System.lineSeparator();
  } else if (key=='.') {
    iso.sliceKGrid(72, 25);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="slice K 72/25"+System.lineSeparator();
  } else if (key=='>') {
    iso.sliceKGrid(maxIJK, 100);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);    
    operators+="slice K ALL"+System.lineSeparator();
  } else if (key=='/') { 
    iso.colorNoise(4, 4, 4, 0.06, 0.06, 0.06, 0.45);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="colorNoise 4/4/4/0.06/0.06/0.6/0.45"+System.lineSeparator();
  } else if (key=='?') { 
    iso.colorGrid(16, 0.35);
    iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
    operators+="colorNoise 16/0.35"+System.lineSeparator();
  } else if (key==' ') {
    saveFrame = true;
    java.util.Date dNow = new java.util.Date( );
    java.text.SimpleDateFormat ft = new java.text.SimpleDateFormat ("yyyy_MM_dd_HHmmss_S");
    name="iso"+"_"+ft.format(dNow);
    WB_CubeGridExporter.export(sketchPath("saves/"+name+"/"+name+".obj"), 0, 0, 0, I, J, K, scale, scale, scale, iso.voxels, 0, I, 0, J, 0, K);
  } 

  println(creation +operators);
}
