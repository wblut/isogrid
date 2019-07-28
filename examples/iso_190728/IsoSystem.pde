class IsoSystem { 
  WB_IsoHexGrid grid;
  int[] colors;
  boolean[] voxels;
  boolean[] buffer;
  boolean[] swap;
  int[] colorIndices;
  int[] bufferci;
  int[] swapci;
  double L;
  int I, J, K, IJK;
  double centerX, centerY;
  PApplet home;
  int seed;

  IsoSystem(double L, int I, int J, int K, double centerX, double centerY, int[] colors, int seed, 
    PApplet home) {
    this.home = home;
    this.L = L;
    this.I = I;
    this.J = J;
    this.K = K;
    IJK=I*J*K;
    this.colors = colors;
    this.centerX=centerX;
    this.centerY=centerY;
    voxels = new boolean[IJK];
    buffer = new boolean[IJK];
    colorIndices=new int[IJK];
    bufferci = new int[IJK];
    this.seed=seed;
    home.randomSeed(seed);
    grid = new WB_IsoHexGrid(centerX, centerY, L, L);
    int id=0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[id] =true;
          id++;
        }
      }
    }
    mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
  }

  IsoSystem(double L, int I, int J, int K, double centerX, double centerY, int[] colors, int seed, boolean[] voxels, 
    PApplet home) {
    this.home = home;
    this.L = L;
    this.I = I;
    this.J = J;
    this.K = K;
    IJK=I*J*K;
    this.colors = colors;
    this.centerX=centerX;
    this.centerY=centerY;
    this.voxels=voxels;
    buffer = new boolean[IJK];
    colorIndices=new int[IJK];
    bufferci = new int[IJK];
    this.seed=seed;
    home.randomSeed(seed);
    grid = new WB_IsoHexGrid(centerX, centerY, L, L);
   
    mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
  }

  public void clear() {
    for (int id = 0; id < IJK; id++) {
      voxels[id] =true;
      id++;
    }
    buffer = new boolean[IJK];
    colorIndices=new int[IJK];
    bufferci = new int[IJK];
    grid = new WB_IsoHexGrid(centerX, centerY, L, L);
    mapVoxelsToHexGrid(DUAL, mini, maxi, minj, maxj, mink, maxk);
  }

  public void set(int i, int j, int k, int blocki, int blockj, int blockk) {
    for (int di=0; di<blocki; di++) {
      for (int dj=0; dj<blockj; dj++) {
        for (int dk=0; dk<blockk; dk++) {
          int index=index(i+di, j+dj, k+dk);
          if (index>-1) {
            voxels[index]=true;
          }
        }
      }
    }
  }

  public void set(int i, int j, int k, int colorIndex, int blocki, int blockj, int blockk) {
    for (int di=0; di<blocki; di++) {
      for (int dj=0; dj<blockj; dj++) {
        for (int dk=0; dk<blockk; dk++) {
          int index=index(i+di, j+dj, k+dk);
          if (index>-1) {
            voxels[index]=true;
            colorIndices[index]=colorIndex;
          }
        }
      }
    }
  }

  public void clear(int i, int j, int k, int blocki, int blockj, int blockk) {
    for (int di=0; di<blocki; di++) {
      for (int dj=0; dj<blockj; dj++) {
        for (int dk=0; dk<blockk; dk++) {
          int index=index(i+di, j+dj, k+dk);
          if (index>-1) {
            voxels[index]=false;
          }
        }
      }
    }
  }

  public void and(int i, int j, int k, int blocki, int blockj, int blockk) {
    for (int di=0; di<blocki; di++) {
      for (int dj=0; dj<blockj; dj++) {
        for (int dk=0; dk<blockk; dk++) {
          int index=index(i+di, j+dj, k+dk);
          if (index>-1) {
            voxels[index]&=true;
          }
        }
      }
    }
  }

  public void or(int i, int j, int k, int blocki, int blockj, int blockk) {
    for (int di=0; di<blocki; di++) {
      for (int dj=0; dj<blockj; dj++) {
        for (int dk=0; dk<blockk; dk++) {
          int index=index(i+di, j+dj, k+dk);
          if (index>-1) {
            voxels[index]|=true;
          }
        }
      }
    }
  }

  public void xor(int i, int j, int k, int blocki, int blockj, int blockk) {
    for (int di=0; di<blocki; di++) {
      for (int dj=0; dj<blockj; dj++) {
        for (int dk=0; dk<blockk; dk++) {
          int index=index(i+di, j+dj, k+dk);
          if (index>-1) {
            voxels[index]^=true;
          }
        }
      }
    }
  }

  public void invert(int i, int j, int k, int blocki, int blockj, int blockk) {
    for (int di=0; di<blocki; di++) {
      for (int dj=0; dj<blockj; dj++) {
        for (int dk=0; dk<blockk; dk++) {
          int index=index(i+di, j+dj, k+dk);
          if (index>-1) {
            voxels[index]=!voxels[index];
          }
        }
      }
    }
  }

  public void invert() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[index] = ! voxels[index++];
        }
      }
    }
  }

  public void noise() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[index++] &=  (home.noise(0.012f*i, 0.012f*j, 0.012f*k)>0.4f) ;
        }
      }
    }
  }

  public void noise(int blocki, int blockj, int blockk, float dx, float dy, float dz, float n) {
    boolean b;
    for (int i = 0; i < I; i+=blocki) {
      for (int j = 0; j < J; j+=blockj) {
        for (int k = 0; k < K; k+=blockk) {
          b=(home.noise(dx*i, dy*j, dz*k)<n);
          for (int di = 0; di < blocki; di++) {
            for (int dj = 0; dj < blockj; dj++) {
              for (int dk = 0; dk < blockk; dk++) {
                voxels[index(i+di, j+dj, k+dk)] &= b ;
              }
            }
          }
        }
      }
    }
  }
  
  public void colorNoise(int blocki, int blockj, int blockk, float dx, float dy, float dz, float n) {
    boolean b;
    for (int i = 0; i < I; i+=blocki) {
      for (int j = 0; j < J; j+=blockj) {
        for (int k = 0; k < K; k+=blockk) {
          b=(home.noise(dx*(i+I), dy*(j+J), dz*(k+K))<n);
          for (int di = 0; di < blocki; di++) {
            for (int dj = 0; dj < blockj; dj++) {
              for (int dk = 0; dk < blockk; dk++) {
               if(b) colorIndices[index(i+di, j+dj, k+dk)] =1;
              }
            }
          }
        }
      }
    }
  }



  public void subdivideGrid() {
    //subdivideRandomGrid(128, 50.0f, 50.0f,0.0f);
    subdivideRandomGrid(64, 50.0f, 50.0f,0.0f);
    subdivideRandomGrid(32, 40.0f, 50.0f,0.0f);
    subdivideRandomGrid(16, 30.0f, 50.0f,0.0f);
    subdivideRandomGrid(8, 20.0f, 50.0f,0.0f);
    subdivideRandomGrid(4, 1.0f, 20.0f,0.0f);
  }

  public void subdivideRandomGrid(int step, float divide, float retain,float jgradient) {
    int hs = step / 2;
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          if (random(100) < divide+(jgradient/J)*j) {
            boolean on = random(100) < retain;
            if (on) {
              and(i, j, k, hs, hs, hs);
            } else {
              clear(i, j, k, hs, hs, hs);
            }
            on = random(100) < retain;
            if (on) {
              and(i+hs, j, k, hs, hs, hs);
            } else {
              clear(i+hs, j, k, hs, hs, hs);
            }
            on = random(100) < retain;
            if (on) {
              and(i, j+hs, k, hs, hs, hs);
            } else {
              clear(i, j+hs, k, hs, hs, hs);
            }
            on = random(100) < retain;
            if (on) {
              and(i, j, k+hs, hs, hs, hs);
            } else {
              clear(i, j, k+hs, hs, hs, hs);
            }
            on = random(100) < retain;
            if (on) {
              and(i+hs, j+hs, k, hs, hs, hs);
            } else {
              clear(i+hs, j+hs, k, hs, hs, hs);
            }
            on = random(100) < retain;
            if (on) {
              and(i+hs, j, k+hs, hs, hs, hs);
            } else {
              clear(i+hs, j, k+hs, hs, hs, hs);
            }
            on = random(100) < retain;
            if (on) {
              and(i, j+hs, k+hs, hs, hs, hs);
            } else {
              clear(i, j+hs, k+hs, hs, hs, hs);
            }
            on = random(100) < retain;
            if (on) {
              and(i+hs, j+hs, k+hs, hs, hs, hs);
            } else {
              clear(i+hs, j+hs, k+hs, hs, hs, hs);
            }
          }
        }
      }
    }
  }


  public void createFullGrid() {
    int index = 0;
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[index++] = true;// (q+r+s==(I/2+J/2+K/2));
        }
      }
    }
  }

  public void colorGrid(int step, float chance1, float chance2) {
    float roll;
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          roll=random(100);
          if (roll < chance1 ) {
            colorBlock(i, j, k, step, 1);
          } else if (roll < chance1 + chance2 ) {
            colorBlock(i, j, k, step, 2);
          } else {
            colorBlock(i, j, k, step, 0);
          }
        }
      }
    }
  }

  public void colorBlock(int di, int dj, int dk, int step, int col) {
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            colorIndices[index(di+i, dj+j, dk+k)] = col;
          }
        }
      }
    }
  }

  public void sliceIGrid(int step, float chance) {
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

  public void sliceIBlock(int di, int dj, int dk, int step) {
    boolean off = false;
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            if (sliceI(di+i, dj+j, dk+k, 52, 44)) {
              voxels[index(di+i, dj+j, dk+k)] = false;
            }
          }
        }
      }
    }
  }

  public void sliceJGrid(int step, float chance) {
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

  public void sliceJBlock(int di, int dj, int dk, int step) {
    boolean off = false;
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            if (sliceJ(di+i, dj+j, dk+k, 8, 6)) {
              voxels[index(di+i, dj+j, dk+k)] = false;
            }
          }
        }
      }
    }
  }

  public void sliceKGrid(int step, float chance) {
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

  public void sliceKBlock(int di, int dj, int dk, int step) {
    boolean off = false;
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            if (sliceK(di+i, dj+j, dk+k, 52, 44)) {
              voxels[index(di+i, dj+j, dk+k)] = false;
            }
          }
        }
      }
    }
  }



  public boolean sliceI(int i, int j, int k, int period, int on) {
    return i % period >= on;// || s%35>=23 || q%45>=38;
  }

  public boolean sliceJ(int i, int j, int k, int period, int on) {
    return j % period >= on;
  }

  public boolean sliceK(int i, int j, int k, int period, int on) {
    return k % period >= on;
  }

  public void copyFromBuffer(int di, int dj, int dk, int step) {
    for (int i = 0; i < step; i++) {
      for (int j = 0; j < step; j++) {
        for (int k = 0; k < step; k++) {
          if (di+i < I && dj+j < J && dk+k < K) {
            voxels[index(di+i, dj+j, dk+k)] = buffer[index(di+i, dj+j, dk+k)] ;
          }
        }
      }
    }
  }

  public void edgeGrid(int step, float chance) {
    swap();
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          edgeBlock(i, j, k, step, chance);
        }
      }
    }
  }
/*


  public void edgeBlock(int di, int dj, int dk, int step, float chance) {
    if (random(100) < chance) {
      boolean val, compval;
      int id;
      for (int i = 0; i < step; i++) {
        for (int j = 0; j < step; j++) {
          for (int k = 0; k < step; k++) {
            if (di+i < I && dj+j < J && dk+k < K) {
              id=index(di+i, dj+j, dk+k);
              val=buffer[id];
              compval=(di+i+1<I)?buffer[index(di+i+1, dj+j, dk+k)]:false;
              voxels[id]=(val!=compval);
              if (voxels[id]) continue;
              compval=(dj+j+1<J)?buffer[index(di+i, dj+j+1, dk+k)]:false;
              voxels[id]=(val!=compval);
              if (voxels[id]) continue;
              compval=(dk+k+1<K)?buffer[index(di+i, dj+j, dk+k+1)]:false;
              voxels[id]=(val!=compval);
              if (voxels[id]) continue;
              compval=(di+i+1<I)&&(dj+j+1<J)?buffer[index(di+i+1, dj+j+1, dk+k)]:false;
              voxels[id]=(val!=compval);
              if (voxels[id]) continue;
              compval=(di+i+1<I)&&(dk+k+1<K)?buffer[index(di+i+1, dj+j, dk+k+1)]:false;
              voxels[id]=(val!=compval);
              if (voxels[id]) continue;
              compval=(dk+k+1<K)&&(dj+j+1<J)?buffer[index(di+i, dj+j+1, dk+k+1)]:false;
              voxels[id]=(val!=compval);
              if (voxels[id]) continue;
              compval=(di+i+1<I)&&(dj+j+1<J)&&(dk+k+1<K)?buffer[index(di+i+1, dj+j+1, dk+k+1)]:false;
              voxels[id]=(val!=compval);
              if (voxels[id]) continue;
            }
          }
        }
      }
    } else {
      copyFromBuffer(di, dj, dk, step);
    }
  }
*/
  void edgeBlock(int di, int dj, int dk, int step, float chance) {
    if (random(100) < chance) {
      for (int i = 0; i < step; i++) {
        for (int j = 0; j < step; j++) {
          for (int k = 0; k < step; k++) {
            if (di+i < I && dj+j < J && dk+k < K) {
              voxels[index(di+i, dj+j, dk+k)] = false;
              boolean ref = (di+i < I && dj+j < J && dk+k < K)
                ? buffer[index(di+i, dj+j, dk+k)]
                : false;
              if (di+i > 0 && dj+j < J && dk+k < K
                && buffer[index(di+i - 1, dj+j, dk+k)] != ref) {
                voxels[index(di+i, dj+j, dk+k)] = true;
                continue;
              }
              if (di+i < I && dj+j > 0 && dk+k < K
                && buffer[index(di+i, dj+j - 1, dk+k)] != ref) {
                voxels[index(di+i, dj+j, dk+k)] = true;
                continue;
              }
              if (di+i < I && dj+j < J && dk+k > 0
                && buffer[index(di+i, dj+j, dk+k - 1)] != ref) {
                voxels[index(di+i, dj+j, dk+k)] = true;
                continue;
              }
              if (di+i > 0 && dj+j > 0 && dk+k < K
                && buffer[index(di+i - 1, dj+j - 1, dk+k)] != ref) {
                voxels[index(di+i, dj+j, dk+k)] = true;
                continue;
              }
              if (di+i < I && dj+j > 0 && dk+k > 0
                && buffer[index(di+i, dj+j - 1, dk+k - 1)] != ref) {
                voxels[index(di+i, dj+j, dk+k)] = true;
                continue;
              }
              if (di+i > 0 && dj+j < J && dk+k > 0
                && buffer[index(di+i - 1, dj+j, dk+k - 1)] != ref) {
                voxels[index(di+i, dj+j, dk+k)] = true;
                continue;
              }
              if (di+i > 0 && dj+j > 0 && dk+k > 0
                && buffer[index(di+i - 1, dj+j - 1, dk+k - 1)] != ref) {
                voxels[index(di+i, dj+j, dk+k)] = true;
                continue;
              }
            }
          }
        }
      }
    } else {
      copyFromBuffer(di, dj, dk, step);
    }
  }

  public void wireGrid(int step, float chance) {
    swap();
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          wireBlock(i, j, k, step, chance);
        }
      }
    }
  }

  public void wireBlock(int di, int dj, int dk, int step, float chance) {
    if (random(100) < chance) {
      for (int i = 0; i < step; i++) {
        for (int j = 0; j < step; j++) {
          for (int k = 0; k < step; k++) {
            if (di+i < I && dj+j < J && dk+k < K) {
              int active, activeq, activer, actives, activeqr, activers, activeqs, activeqrs;
              activeq = ((di+i - 1 >= 0 && buffer[index(di+i - 1, dj+j, dk+k)]) ? 1 : 0)
                + ((di+i + 1 < I && buffer[index(di+i + 1, dj+j, dk+k)]) ? 1 : 0);
              activer = ((dj+j - 1 >= 0 && buffer[index(di+i, dj+j - 1, dk+k)]) ? 1 : 0)
                + ((dj+j + 1 < J && buffer[index(di+i, dj+j + 1, dk+k)]) ? 1 : 0);
              actives = ((dk+k - 1 >= 0 && buffer[index(di+i, dj+j, dk+k - 1)]) ? 1 : 0)
                + ((dk+k + 1 < K && buffer[index(di+i, dj+j, dk+k + 1)]) ? 1 : 0);

              active= ((activeq == 0)?1:0) +((activer == 0)?1:0)+((actives == 0)?1:0);
              if (active==1) {
                voxels[index(di+i, dj+j, dk+k)] = false;
              } else {
                voxels[index(di+i, dj+j, dk+k)] = buffer[index(di+i, dj+j, dk+k)];
              }
            }
          }
        }
      }
    } else {
      copyFromBuffer(di, dj, dk, step);
    }
  }

  public void IKGrid() {
    swap();
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          int activeq, activer, actives, activeqr, activers, activeqs, activeqrs;
          activeq = ((i - 1 >= 0 && buffer[index(i - 1, j, k)]) ? 1 : 0)
            + ((i + 1 < I && buffer[index(i + 1, j, k)]) ? 1 : 0);
          activer = ((j - 1 >= 0 && buffer[index(i, j - 1, k)]) ? 1 : 0)
            + ((j + 1 < J && buffer[index(i, j + 1, k)]) ? 1 : 0);
          actives = ((k - 1 >= 0 && buffer[index(i, j, k - 1)]) ? 1 : 0)
            + ((k + 1 < K && buffer[index(i, j, k + 1)]) ? 1 : 0);
          activeqrs = activeq + activer + actives;
          if (activer== 0 || activer==2) {
            voxels[index(i, j, k)] = false;
          } else {
            voxels[index(i, j, k)] = buffer[index(i, j, k)];
          }
        }
      }
    }
  }

  public void hollowGrid(int step, float chance) {
    swap();
    for (int i = 0; i < I; i += step) {
      for (int j = 0; j < J; j += step) {
        for (int k = 0; k < K; k += step) {
          hollowBlock(i, j, k, step, chance);
        }
      }
    }
  }



  public void hollowBlock(int di, int dj, int dk, int step, float chance) {
    if (random(100) < chance) {
      for (int i = 0; i < step; i++) {
        for (int j = 0; j < step; j++) {
          for (int k = 0; k < step; k++) {
            if (di+i < I && dj+j < J && dk+k < K) {
              int activeq, activer, actives, activeqr, activers, activeqs, activeqrs;
              activeq = ((di+i - 1 >= 0 && buffer[index(di+i - 1, dj+j, dk+k)]) ? 1 : 0)
                + ((di+i + 1 < I && buffer[index(di+i + 1, dj+j, dk+k)]) ? 1 : 0);
              activer = ((dj+j - 1 >= 0 && buffer[index(di+i, dj+j - 1, dk+k)]) ? 1 : 0)
                + ((dj+j + 1 < J && buffer[index(di+i, dj+j + 1, dk+k)]) ? 1 : 0);
              actives = ((dk+k - 1 >= 0 && buffer[index(di+i, dj+j, dk+k - 1)]) ? 1 : 0)
                + ((dk+k + 1 < K && buffer[index(di+i, dj+j, dk+k + 1)]) ? 1 : 0);
              activeqrs = activeq + activer + actives;

              if (activeqrs== 6) {
                voxels[index(di+i, dj+j, dk+k)] = false;
              } else {
                voxels[index(di+i, dj+j, dk+k)] = buffer[index(di+i, dj+j, dk+k)];
              }
            }
          }
        }
      }
    } else {
      copyFromBuffer(di, dj, dk, step);
    }
  }

  public void rotateI() {
    swap();
    swapci();

    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[index(i, j, k)] = (J == K) ? buffer[index(i, k, J - 1 - j)]
            : buffer[index(i, J - 1 - j, K - 1 - k)];
          colorIndices[index(i, j, k)] = (J == K) ? bufferci[index(i, k, J - 1 - j)]
            : bufferci[index(i, J - 1 - j, K - 1 - k)];
        }
      }
    }
  }

  public void rotateJ() {
    swap();
    swapci();

    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[index(i, j, k)] = (I == K) ? buffer[index(k, j, I - 1 - i)]
            : buffer[index(I - 1 - i, j, K - 1 - k)];
          colorIndices[index(i, j, k)] = (I == K) ? bufferci[index(k, j, I - 1 - i)]
            : bufferci[index(I - 1 - i, j, K - 1 - k)];
        }
      }
    }
  }



  public void rotateK() {
    swap();
    swapci();

    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[index(i, j, k)] = (I == J) ? buffer[index(j, I - 1 - i, k)]
            : buffer[index(I - 1 - i, J - 1 - j, k)];
          colorIndices[index(i, j, k)] = (I == J) ? bufferci[index(j, I - 1 - i, k)]
            : bufferci[index(I - 1 - i, J - 1 - j, k)];
        }
      }
    }
  }

  public void flip() {
    swap();
    swapci();
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[index(i, j, k)] =  buffer[index(I-i-1, J-j-1, K - k - 1)];
          colorIndices[index(i, j, k)] =  bufferci[index(I-i-1, J-j-1, K - k - 1)];
        }
      }
    }
  }

  public void mirrorI() {
    swap();
    swapci();
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[index(i, j, k)] = buffer[index((i > I / 2) ? I - i - 1 : i, j, k)];
          colorIndices[index(i, j, k)] = bufferci[index((i > I / 2) ? I - i - 1 : i, j, k)];
        }
      }
    }
  }

  public void mirrorJ() {
    swap();
    swapci();
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[index(i, j, k)] = buffer[index(i, (j > J / 2) ? J - j - 1 : j, k)];
          colorIndices[index(i, j, k)] = bufferci[index(i, (j > J / 2) ? J - j - 1 : j, k)];
        }
      }
    }
  }

  public void mirrorK() {
    swap();
    swapci();
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          voxels[index(i, j, k)] = buffer[index(i, j, (k > K / 2) ? K - k - 1 : k)];
          colorIndices[index(i, j, k)] = bufferci[index(i, j, (k > K / 2) ? K - k - 1 : k)];
        }
      }
    }
  }

  public void mirrorIK() {
    swap();
    swapci();
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {
          if (i >k) {
            voxels[index(i, j, k)] = buffer[index(k, j, i)];
            colorIndices[index(i, j, k)] = bufferci[index(k, j, i)];
          } else {
            voxels[index(i, j, k)] = buffer[index(i, j, k)];
            colorIndices[index(i, j, k)] = bufferci[index(i, j, k)];
          }
        }
      }
    }
  }

  public void tri() {
    swap();
    swapci();
    for (int i = 0; i < I; i++) {
      for (int j = 0; j < J; j++) {
        for (int k = 0; k < K; k++) {

          voxels[index(i, j, k)] = ((buffer[index(i, j, k)]?1:0)+(buffer[index(k, i, j)]?1:0)+(buffer[index(j, k, i)]?1:0))>=2;
          colorIndices[index(i, j, k)] = round((bufferci[index(i, j, k)]+bufferci[index(k, i, j)]+bufferci[index(j, k, i)])/3.0f);
        }
      }
    }
  }


  public void swap() {
    swap=buffer;
    buffer=voxels;
    voxels=swap;
  }


  public void swapci() {
    swapci=bufferci;
    bufferci=colorIndices;
    colorIndices=swapci;
  }

  public void mapVoxelsToHexGrid(boolean dual, int mini, int maxi, int minj, int maxj, int mink, int maxk) {
    grid.clear();
    int[] ranges=new int[8];
    if (dual) {
      for (int i = min(maxi-2, I-2); i >=max(0, mini); i--) {
        for (int j =min(maxj-2, J-2); j>=max(0, minj); j--) {
          for (int k = min(maxk-2, K-2); k >=max(0, mink); k--) {

            grid.addCube(i-I/2/*+(int)(I*(-0.25+0.5*home.noise(0.015*j)))*/, j-J/2, k-K/2/*+(int)(K*(-0.25+0.5*home.noise(0.015*j+25)))*/, state(i, j, k, dual), colorIndices[index(i, j, k)]);
          }
        }
      }
    } else {
      for (int i = max(mini, 0); i < min(I, maxi); i++) {
        for (int j =max(minj, 0); j < min(J, maxj); j++) {
          for (int k = max(mink, 0); k < min(K, maxk); k++) {

            grid.addCube(i-I/2/*+(int)(I*(-0.25+0.5*home.noise(0.015*j)))*/, j-J/2, k-K/2/*+(int)(K*(-0.25+0.5*home.noise(0.015*j+25)))*/, state(i, j, k, dual), colorIndices[index(i, j, k)]);
          }
        }
      }
    }
    grid.collectLines();
    List<WB_IsoGridLine> lines=grid.getLines();
  }

  public int state(int i, int j, int k, boolean dual) {
    if (dual) {
      int state = 0;
      if (voxels[index(i, j, k)])
        state += 1;
      if (voxels[index(i + 1, j, k)])
        state += 2;
      if (voxels[index(i, j + 1, k)])
        state += 4;
      if (voxels[index(i + 1, j + 1, k)])
        state += 8;
      if (voxels[index(i, j, k + 1)])
        state += 16;
      if (voxels[index(i + 1, j, k + 1)])
        state += 32;
      if (voxels[index(i, j + 1, k + 1)])
        state += 64;
      if (voxels[index(i + 1, j + 1, k + 1)])
        state += 128;
      return state;
    } else {
      if (voxels[index(i, j, k)]) {
        return 255;
      } else {
        return 0;
      }
    }
  } 

  public int index(int i, int j, int k) {
    if (i<0||i>=I||j<0||j>=J||k<0||k>=K) return -1;
    return k + K * j + K * J * i;
  }



  public void drawEdges() {
    grid.drawLines(home);
  }

  public void drawFaces(int zmin, int zmax) {

    if (FADE) {
      grid.drawFragments(home, colors, zmin, zmax, 5*(I+J+K)/16+offset, -(I+J+K)/4+offset, -I/2, I/2, -J/2, J/2, -K/2, K/2);
    } else {
      grid.drawFragments(home, colors, zmin, zmax);
    }
  }
}
