void GUI(){
  int x=10;
  int y=0;
  int dy=16;
  text("iso 190522",x,y+=dy);
  text("",x,y+=dy);
  text("spacebar: save",x,y+=dy);
  text("n: reset, same noise seed",x,y+=dy);
  text("N: reset, new noise seed",x,y+=dy);
  text("",x,y+=dy);
  text("1-7: random remove blocks of size 128-64-...-2",x,y+=dy);
  text("q: random refine",x,y+=dy);
  text("a: Perlin noise subtract",x,y+=dy);
  text("z: invert",x,y+=dy);
  text("",x,y+=dy);
  text("E: edge transform",x,y+=dy);
  text("e: random selection edge transform",x,y+=dy);
  text("W: wire transform",x,y+=dy);
  text("w: random selection wire transform",x,y+=dy);
  text("",x,y+=dy);
  text("S: slice I direction",x,y+=dy);
  text("s: random selection slice I direction",x,y+=dy);
  text("D: slice J direction",x,y+=dy);
  text("d: random selection slice J direction",x,y+=dy);
  text("F: slice K direction",x,y+=dy);
  text("f: random selection slice K direction",x,y+=dy);
  text("",x,y+=dy);
  text("k: 90° rotate I axis",x,y+=dy);
  text("l: 90° rotate J axis",x,y+=dy);
  text("m: 90° rotate K axis",x,y+=dy);
  text("",x,y+=dy);
  text("u: mirror I plane",x,y+=dy);
  text("i: mirror J plane",x,y+=dy);
  text("o: mirror K plane",x,y+=dy);
  text("p: mirror IK plane",x,y+=dy);
 
}
