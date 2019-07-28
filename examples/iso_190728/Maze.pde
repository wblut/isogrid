void maze(int x, int MI, int MJ, int MK) {
  I=x*MI;
  J=x*MJ;
  K=x*MK;
  mini=0;
  minj=0;
  mink=0;
  maxi=I;
  maxj=J;
  maxk=K;
  maxIJK=max(I, J, K);
  boolean[] voxels = new boolean[I*J*K];
  Maze maze=new Maze(MI, MJ, MK);
  int id=0;
  for (int i = 0; i < I; i++) {
    for (int j = 0; j < J; j++) {
      for (int k = 0; k < K; k++) {

        if (isCenterx(x, i)&&isCenterx(x, j)&&isCenterx(x, k)&&maze.getCell(i/x, j/x, k/x).links.size()>0) {
          voxels[id] =true;
        } else if (isDownx(x, i)&&isCenterx(x, j)&&isCenterx(x, k)) {
          voxels[id] =maze.isLinked(i/x-1, j/x, k/x, i/x, j/x, k/x);
        } else if (isUpx(x, i)&&isCenterx(x, j)&&isCenterx(x, k)) {
          voxels[id] =maze.isLinked(i/x, j/x, k/x, i/x+1, j/x, k/x);
        } else if (isDownx(x, j)&&isCenterx(x, i)&&isCenterx(x, k)) {
          voxels[id] =maze.isLinked(i/x, j/x-1, k/x, i/x, j/x, k/x);
        } else if (isUpx(x, j)&&isCenterx(x, i)&&isCenterx(x, k)) {
          voxels[id] =maze.isLinked(i/x, j/x, k/x, i/x, j/x+1, k/x);
        } else if (isDownx(x, k)&&isCenterx(x, i)&&isCenterx(x, j)) {
          voxels[id] =maze.isLinked(i/x, j/x, k/x-1, i/x, j/x, k/x);
        } else if (isUpx(x, k)&&isCenterx(x, i)&&isCenterx(x, j)) {
          voxels[id] =maze.isLinked(i/x, j/x, k/x, i/x, j/x, k/x+1);
        }
        id++;
      }
    }
  }
  iso=new IsoSystem(scale, I, J, K, 0, 0, colors, seed, voxels, this);
  iso.mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
}



boolean isCenterx(int x, int v) {
  return (x%2==0)? (v%x)==x/2-1||(v%x)==x/2  : (v%x)==x/2;
}
boolean isUpx(int x, int v) {
  return (v%x)>x/2;
}

boolean isDownx(int x, int v) {
  return  (x%2==0)?(v%x)<x/2-1:(v%x)<x/2;
}


class Maze {
  int layers, rows, columns, unvisited;
  Cell[][][] cells;
  Maze(int layers, int rows, int columns) {
    this.layers=layers;
    this.rows=rows;
    this.columns=columns;
    initGrid();
    configureCells();
    AldousBroder();
  }

  void initGrid() {
    cells=new Cell[layers][rows][columns];
    for (int l=0; l<layers; l++) {
      for (int r=0; r<rows; r++) {
        for (int c=0; c<columns; c++) {
          cells[l][r][c]=new Cell(l, r, c);
        }
      }
    }
  }


  void configureCells() {
    unvisited=layers*rows*columns;
    for (int l=0; l<layers; l++) {
      for (int r=0; r<rows; r++) {
        for (int c=0; c<columns; c++) {
          cells[l][r][c].N=getCell(l, r-1, c);
          cells[l][r][c].S=getCell(l, r+1, c);
          cells[l][r][c].W=getCell(l, r, c-1);
          cells[l][r][c].E=getCell(l, r, c+1);
          cells[l][r][c].U=getCell(l+1, r, c);
          cells[l][r][c].D=getCell(l-1, r, c);
        }
      }
    }
     for (int l=layers/3; l<2*layers/3; l++) {
      for (int r=rows/3; r<2*rows/3; r++) {
        for (int c=columns/3; c<2*columns/3; c++) {
          cells[l][r][c].visited=true;
     unvisited--;
        }
      }
    }
  }

  Cell getCell(int layer, int row, int column) {
    if (layer>=0 && layer<layers && row>=0 && row<rows && column>=0&column<columns) {
      return cells[layer][row][column];
    }
    return null;
  }

  Cell getRandomCell() {
    return getCell((int)random(layers), (int)random(rows), (int)random(columns));
  }


  void AldousBroder() {
    Cell cell= getRandomCell();
    if(cell.visited){
      
    }else{
    cell.visited=true;
     unvisited--;
    }
    cell.label=0;
    Cell neighbor;
   

    List<Cell> neighbors=new ArrayList<Cell>();
    while (unvisited>0) {
      cell.getNeighbors(neighbors);
      neighbor=neighbors.get((int)random(neighbors.size()));
      if (!neighbor.visited) {
        cell.link(neighbor);
        neighbor.visited=true;

        unvisited--;
      }
      cell=neighbor;
    }
  }

  boolean isLinked(int l1, int r1, int c1, int l2, int r2, int c2) {
    Cell cell1=getCell(l1, r1, c1);
    Cell cell2=getCell(l2, r2, c2);
    return cell1!=null && cell2!=null && cell1.isLinked(cell2);
  }
}


class Cell {
  int layer, row, column;
  Cell N, S, E, W, U, D;
  LinkedHashSet<Cell> links;
  boolean visited;
  int label;
  Cell(int layer, int row, int column) {
    this.layer=layer;
    this.row=row;
    this.column=column;
    links= new LinkedHashSet<Cell>();
    visited=false;
  }


  void link(Cell cell, boolean bidirectional) {
    links.add(cell);
    if (bidirectional) cell.link(this, false);
  }

  void unlink(Cell cell, boolean bidirectional) {
    links.remove(cell);
    if (bidirectional) cell.unlink(this, false);
  }

  void link(Cell cell) {
    link(cell, true);
  }

  void unlink(Cell cell) {
    unlink(cell, true);
  }

  boolean isLinked(Cell cell) {
    return links.contains(cell);
  }

  Collection<Cell> getLinks() {
    return links;
  }

  void getNeighbors(List<Cell> neighbors) {
    neighbors.clear();
    if (U!=null) neighbors.add(U);
    if (D!=null) neighbors.add(D);
    if (N!=null) neighbors.add(N);
    if (S!=null) neighbors.add(S);
    if (E!=null) neighbors.add(E);
    if (W!=null) neighbors.add(W);
  }
}
