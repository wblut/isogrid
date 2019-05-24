class IsoSystem { 
  WB_IsoHexGrid grid;
  WB_IsoCubeGrid cubes;
  PShape wire;
  PShape[] faces;
  int[] colors;
  boolean[] values;
  boolean[] tmp;
  double L;
  int I, J, K, IJK;
  double cx, cy;
  PApplet home;
  int seed;

  IsoSystem(double L, int I, int J, int K, double cx, double cy, int[] colors, int seed, 
    PApplet home) {
    this.home = home;
    this.L = L;
    this.I = I;
    this.J = J;
    this.K = K;
    IJK=I*J*K;
    this.colors = colors;
    this.cx=cx;
    this.cy=cy;
    values = new boolean[IJK];
    tmp = new boolean[IJK];
    this.seed=seed;
    home.randomSeed(seed);
    grid = new WB_IsoHexGrid(cx, cy, L, L);
    int id;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          id=index(i, j, k);
          values[id] =true;
        }
      }
    }
    cubes = WB_IsoCubeGrid.createGrid(0, 0, 0, I, J, K, L, L, L, values);
    mapCubeGridToHexGrid();
  }

  void clear() {
    for (int id = 0; id < IJK; id++) {
      values[id] =true;
      id++;
    }
    tmp = new boolean[IJK];
    grid = new WB_IsoHexGrid(cx, cy, L, L);
    cubes = WB_IsoCubeGrid.createGrid(0, 0, 0, I, J, K, L, L, L, values);
    mapCubeGridToHexGrid();
  }

  void invert() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index] = ! values[index++];
        }
      }
    }
  }

  void noise() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index++] &=  (home.noise(0.04*i, 0.04*j, 0.04*k)>0.4) ;
        }
      }
    }
  }

  void andBlock(int di, int dj, int dk, int step, boolean val) {
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di + i < I && dj + j < J && dk + k < K) {
            values[index(di + i, dj + j, dk + k)] &= val;
          }
        }
      }
    }
  }

  void setBlock(int di, int dj, int dk, int step, boolean val) {
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            values[index(di+i, dj+j, dk+k)] = val;
          }
        }
      }
    }
  }

  void setBlock(int di, int dj, int dk, int scale, int step, boolean val) {
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di * scale + i < I && dj * scale + j < J && dk * scale + k < K) {
            values[index(di * scale + i, dj * scale + j, dk * scale + k)] = val;
          }
        }
      }
    }
  }

  void refineGrid() {
    refineRandomGrid(64, 50.0f, 50.0f, true);
    refineRandomGrid(32, 40.0f, 50.0f, true);
    refineRandomGrid(16, 30.0f, 50.0f, true);
    refineRandomGrid(8, 20.0f, 50.0f, true);
    refineRandomGrid(4, 1.0f, 20.0f, true);
  }

  void refineRandomGrid(int step, float refine, float chance, boolean sel) {
    int hs = step / 2;
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          if (/* values[index(i, j, k)]==sel && */random(100) < refine) {
            boolean on = random(100) < chance;
            andBlock(i, j, k, hs, on);
            on = random(100) < chance;
            andBlock(i, j + hs, k, hs, on);
            on = random(100) < chance;
            andBlock(i, j, k + hs, hs, on);
            on = random(100) < chance;
            andBlock(i, j + hs, k + hs, hs, on);
            on = random(100) < chance;
            andBlock(i + hs, j, k, hs, on);
            on = random(100) < chance;
            andBlock(i + hs, j + hs, k, hs, on);
            on = random(100) < chance;
            andBlock(i + hs, j, k + hs, hs, on);
            on = random(100) < chance;
            andBlock(i + hs, j + hs, k + hs, hs, on);
          }
        }
      }
    }
  }


  void createFullGrid() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index++] = true;// (q+r+s==(I/2+J/2+K/2));
        }
      }
    }
  }

  void sliceIGrid(int step, float chance) {
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          if (random(100) < chance ) {
            sliceIBlock(i, j, k, step);
          }
        }
      }
    }
  }

  void sliceIBlock(int di, int dj, int dk, int step) {

    boolean off = false;
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            if (sliceI(di+i, dj+j, dk+k, 8, 6)) {
              values[index(di+i, dj+j, dk+k)] = false;
            }
          }
        }
      }
    }
  }

  void sliceJGrid(int step, float chance) {
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          if (random(100) < chance) {
            sliceJBlock(i, j, k, step);
          }
        }
      }
    }
  }

  void sliceJBlock(int di, int dj, int dk, int step) {

    boolean off = false;
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            if (sliceJ(di+i, dj+j, dk+k, 8, 6)) {
              values[index(di+i, dj+j, dk+k)] = false;
            }
          }
        }
      }
    }
  }

  void sliceKGrid(int step, float chance) {
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          if (random(100) < chance) {
            sliceKBlock(i, j, k, step);
          }
        }
      }
    }
  }

  void sliceKBlock(int di, int dj, int dk, int step) {

    boolean off = false;
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            if (sliceK(di+i, dj+j, dk+k, 8, 6)) {
              values[index(di+i, dj+j, dk+k)] = false;
            }
          }
        }
      }
    }
  }
  
  

  boolean sliceI(int i, int j, int k, int period, int on) {
    return i % period >= on;// || s%35>=23 || q%45>=38;
  }

  boolean sliceJ(int i, int j, int k, int period, int on) {
    return j % period >= on;
  }

  boolean sliceK(int i, int j, int k, int period, int on) {
    return k % period >= on;
  }

  void edgeGrid(int step, float chance) {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          tmp[index] = values[index];
          index++;
        }
      }
    }
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          if (random(100) < chance) {
            edgeBlock(i, j, k, step);
          }
        }
      }
    }
    index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index] = tmp[index];// (q+r+s==(I/2+J/2+K/2));
          index++;
        }
      }
    }
  }

  void edgeBlock(int di, int dj, int dk, int step) {
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            tmp[index(di+i, dj+j, dk+k)] = false;
            boolean ref = (di+i < I && dj+j < J && dk+k < K)
              ? values[index(di+i, dj+j, dk+k)]
              : false;
            if (di+i > 0 && dj+j < J && dk+k < K
              && values[index(di+i - 1, dj+j, dk+k)] != ref) {
              tmp[index(di+i, dj+j, dk+k)] = true;
              continue;
            }
            if (di+i < I && dj+j > 0 && dk+k < K
              && values[index(di+i, dj+j - 1, dk+k)] != ref) {
              tmp[index(di+i, dj+j, dk+k)] = true;
              continue;
            }
            if (di+i < I && dj+j < J && dk+k > 0
              && values[index(di+i, dj+j, dk+k - 1)] != ref) {
              tmp[index(di+i, dj+j, dk+k)] = true;
              continue;
            }
            if (di+i > 0 && dj+j > 0 && dk+k < K
              && values[index(di+i - 1, dj+j - 1, dk+k)] != ref) {
              tmp[index(di+i, dj+j, dk+k)] = true;
              continue;
            }
            if (di+i < I && dj+j > 0 && dk+k > 0
              && values[index(di+i, dj+j - 1, dk+k - 1)] != ref) {
              tmp[index(di+i, dj+j, dk+k)] = true;
              continue;
            }
            if (di+i > 0 && dj+j < J && dk+k > 0
              && values[index(di+i - 1, dj+j, dk+k - 1)] != ref) {
              tmp[index(di+i, dj+j, dk+k)] = true;
              continue;
            }
            if (di+i > 0 && dj+j > 0 && dk+k > 0
              && values[index(di+i - 1, dj+j - 1, dk+k - 1)] != ref) {
              tmp[index(di+i, dj+j, dk+k)] = true;
              continue;
            }
          }
        }
      }
    }
  }

  void wireGrid(int step, float chance) {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          tmp[index] = values[index];
          index++;
        }
      }
    }
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          if (random(100) < chance) {
            wireBlock(i, j, k, step);
          }
        }
      }
    }
    index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index] = tmp[index];// (q+r+s==(I/2+J/2+K/2));
          index++;
        }
      }
    }
  }

  void wireBlock(int di, int dj, int dk, int step) {
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            tmp[index(di+i, dj+j, dk+k)] = false;
          }
        }
      }
    }
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            int activeq, activer, actives, activeqr, activers, activeqs, activeqrs;
            activeq = ((di+i - 1 >= 0 && values[index(di+i - 1, dj+j, dk+k)]) ? 1 : 0)
              + ((di+i + 1 < I && values[index(di+i + 1, dj+j, dk+k)]) ? 1 : 0);
            activer = ((dj+j - 1 >= 0 && values[index(di+i, dj+j - 1, dk+k)]) ? 1 : 0)
              + ((dj+j + 1 < J && values[index(di+i, dj+j + 1, dk+k)]) ? 1 : 0);
            actives = ((dk+k - 1 >= 0 && values[index(di+i, dj+j, dk+k - 1)]) ? 1 : 0)
              + ((dk+k + 1 < K && values[index(di+i, dj+j, dk+k + 1)]) ? 1 : 0);
            activeqr = activeq + activer;
            activeqs = activeq + actives;
            activers = activer + actives;
            activeqrs = activeq + activer + actives;
            if (activeq == 0 || actives == 0 || activer == 0) {
              tmp[index(di+i, dj+j, dk+k)] = false;
            } else {
              tmp[index(di+i, dj+j, dk+k)] = values[index(di+i, dj+j, dk+k)];
            }
          }
        }
      }
    }
  }

  void rotateI() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          tmp[index] = values[index];
          index++;
        }
      }
    }

    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index(i, j, k)] = (J == K) ? tmp[index(i, k, J - 1 - j)]
            : tmp[index(i, J - 1 - j, K - 1 - k)];
        }
      }
    }
  }

  void rotateJ() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          tmp[index] = values[index];
          index++;
        }
      }
    }

    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index(i, j, k)] = (I == K) ? tmp[index(k, j, I - 1 - i)]
            : tmp[index(I - 1 - i, j, K - 1 - k)];
        }
      }
    }
  }

  void rotateK() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          tmp[index] = values[index];
          index++;
        }
      }
    }

    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index(i, j, k)] = (I == J) ? tmp[index(j, I - 1 - i, k)]
            : tmp[index(I - 1 - i, J - 1 - j, k)];
        }
      }
    }
  }

  void mirrorI() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          tmp[index] = values[index];// (q+r+s==(I/2+J/2+K/2));
          index++;
        }
      }
    }

    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index(i, j, k)] = tmp[index((i > I / 2) ? I - i - 1 : i, j, k)];
        }
      }
    }
  }

  void mirrorJ() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          tmp[index] = values[index];// (q+r+s==(I/2+J/2+K/2));
          index++;
        }
      }
    }

    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index(i, j, k)] = tmp[index(i, (j > J / 2) ? J - j - 1 : j, k)];
        }
      }
    }
  }

  void mirrorK() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          tmp[index] = values[index];// (q+r+s==(I/2+J/2+K/2));
          index++;
        }
      }
    }

    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          values[index(i, j, k)] = tmp[index(i, j, (k > K / 2) ? K - k - 1 : k)];
        }
      }
    }
  }

  void mirrorIK() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          tmp[index] = values[index];// (q+r+s==(I/2+J/2+K/2));
          index++;
        }
      }
    }

    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          if (i >k) {
            values[index(i, j, k)] = tmp[index(k, j, i)];
          } else {
            values[index(i, j, k)] = tmp[index(i, j, k)];
          }
        }
      }
    }
  }

  void mapCubeGridToHexGrid() {
    grid.clear();
    int index = 0;
    int noi = (I / 2);
    int nor = (J / 2);
    int nos = (K / 2);
    for (int i = -noi; i < noi; i++) {
      for (int j = -nor; j < nor; j++) {
        for (int k = -nos; k < nos; k++) {
          if (values[index++]) {
            grid.addCube(i, j, k);
          }
        }
      }
    }
    grid.collectLines();
    List<WB_IsoGridLine> lines=grid.getLines();
    wire = cubes.createWireframePShape(home);
    wire.disableStyle();
    faces = cubes.createPShapes(home,colors);
    for (PShape shape : faces) {
      shape.disableStyle();
    }
  }

  int index(int i, int j, int k) {
    return k + K * j + K * J * i;
  }

  void drawEdges() {
    grid.drawLines(home);
  }

  void drawFaces() {
    grid.drawTriangles(home, colors);
  }
}
