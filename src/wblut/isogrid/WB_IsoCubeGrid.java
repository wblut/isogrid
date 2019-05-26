/**
 *
 */
package wblut.isogrid;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PShape;


/**
 * @author FVH
 *
 */
public abstract class WB_IsoCubeGrid {
	private int			I;
	private int			J;
	private int			K;
	private double[]	center;
	private double		dx, dy, dz;
	private int			li, ui, lj, uj, lk, uk;
	private boolean		invert;

	public abstract void set(int i, int j, int k);

	public abstract void clear(int i, int j, int k);

	public final boolean get(int i, int j, int k) {
		if (i > li - 1 && j > lj - 1 && k > lk - 1 && i < ui && j < uj
				&& k < uk) {
			return (invert) ? !getInternal(i, j, k) : getInternal(i, j, k);
		} else {
			return false;
		}
	}

	abstract boolean getInternal(int i, int j, int k);

	public int getI() {
		return I;
	}

	public int getJ() {
		return J;
	}

	public int getK() {
		return K;
	}

	public double[] getCenter() {
		return center;
	}

	public double[] getMin() {
		return new double[] {center[0]-I * 0.5 * dx, center[1]-J * 0.5 * dy, center[2]-K * 0.5 * dz};
	}

	public double getDX() {
		return dx;
	}

	public double getDY() {
		return dy;
	}

	public double getDZ() {
		return dz;
	}

	public void setCenter(final double cx,double cy, double cz) {
		center[0]=cx;
		center[1]=cy;
		center[2]=cz;
	}

	public void setDx(final double dX) {
		this.dx = dX;
	}

	public void setDy(final double dY) {
		this.dy = dY;
	}

	public void setDz(final double dZ) {
		this.dz = dZ;
	}

	public void setInvert(boolean b) {
		this.invert = b;
	}

	private WB_IsoCubeGrid() {
	}

	public static WB_IsoCubeGrid createGrid(double cx, double cy, double cz,  final int I,
			final int J, final int K, final double dX, final double dY,
			final double dZ) {
		WB_IsoCubeGrid grid = new WB_IsoCubeGridArray(cx,cy,cz, I, J, K, dX,
				dY, dZ);
		return grid;
	}

	public static WB_IsoCubeGrid createGrid( double cx, double cy, double cz, final int I,
			final int J, final int K, final double dX, final double dY,
			final double dZ, boolean[] values) {
		WB_IsoCubeGrid grid = new WB_IsoCubeGridArray(cx,cy,cz, I, J, K, dX,
				dY, dZ, values);
		return grid;
	}

	public void setLimits(int li, int ui, int lj, int uj, int lk, int uk) {
		this.li = li;
		this.ui = ui;
		this.lj = lj;
		this.uj = uj;
		this.lk = lk;
		this.uk = uk;
	}

	public void clearLimits() {
		this.li = 0;
		this.ui = I;
		this.lj = 0;
		this.uj = J;
		this.lk = 0;
		this.uk = K;
	}

	public int getLi() {
		return li;
	}

	public int getUi() {
		return ui;
	}

	public int getLj() {
		return lj;
	}

	public int getUj() {
		return uj;
	}

	public int getLk() {
		return lk;
	}

	public int getUk() {
		return uk;
	}
	
	public void drawEdges(PApplet home) {
		home.pushMatrix();
		translate(home, getMin());
		drawIEdges(home);
		drawJEdges(home);
		drawKEdges(home);
		home.popMatrix();
	}
	
	private void translate(PApplet home, double[] v) {
		home.translate((float)v[0],(float)v[1],(float)v[2]);
	}

	public void drawFaces(PApplet home) {
		home.pushMatrix();
		translate(home,getMin());
		drawIFaces(home);
		drawJFaces(home);
		drawKFaces(home);
		home.popMatrix();
	}

	public void drawFaces(PApplet home, int[] colors) {
		home.pushStyle();
		home.pushMatrix();
		translate(home,getMin());
		home.fill(colors[0]);
		drawIFaces(home);
		home.fill(colors[1]);
		drawJFaces(home);
		home.fill(colors[2]);
		drawKFaces(home);
		home.popMatrix();
		home.popStyle();
	}

	public void drawEdges(PApplet home, int[] colors) {
		home.pushStyle();
		home.pushMatrix();
		translate(home,getMin());
		home.stroke(colors[0]);
		drawIEdges(home);
		home.stroke(colors[1]);
		drawJEdges(home);
		home.stroke(colors[2]);
		drawKEdges(home);
		home.popMatrix();
		home.popStyle();
	}

	private void drawIEdges(PApplet home) {
		int val00, valm0, valmm, val0m, sum;
		double x, y, z;
		for (int i = getLi(); i < getUi(); i++) {
			x = i * getDX();
			for (int j = getLj(); j <= getUj(); j++) {
				y = j * getDY();
				for (int k = getLk(); k <= getUk(); k++) {
					z = k * getDZ();
					val00 = get(i, j, k) ? 1 : 0;
					valm0 = get(i, j - 1, k) ? 1 : 0;
					valmm = get(i, j - 1, k - 1) ? 1 : 0;
					val0m = get(i, j, k - 1) ? 1 : 0;
					sum = val00 + valm0 + valmm + val0m;
					if (sum == 1 || sum == 3) {
						line(home,x, y, z, x + getDX(), y, z);
					}
					if (sum == 2) {
						if (val00 + valmm == 2 || val0m + valm0 == 2) {
							line(home, x, y, z, x + getDX(), y, z);
						}
					}
				}
			}
		}
	}
	
	private void line(PApplet home, double px, double py, double pz, double qx, double qy, double qz) {
		home.line((float)px, (float)py, (float)pz, (float)qx,(float)qy,(float)qz);
	}

	private void drawIFaces(PApplet home) {
		int val0, valm, sum;
		double x, y, z;
		for (int i = getLi(); i <= getUi(); i++) {
			x = i * getDX();
			for (int j = getLj(); j < getUj(); j++) {
				y = j * getDY();
				for (int k = getLk(); k < getUk(); k++) {
					z = k * getDZ();
					val0 = get(i, j, k) ? 1 : 0;
					valm = get(i - 1, j, k) ? 1 : 0;
					sum = val0 + valm;
					if (sum == 1) {
						home.beginShape();
						vertex(home,x, y, z);
						vertex(home,x, y + getDY(), z);
						vertex(home,x, y + getDY(), z + getDZ());
						vertex(home,x, y, z + getDZ());
						home.endShape();
					}
				}
			}
		}
	}
	
	private void vertex(PApplet home, double x, double y, double z) {
		home.vertex((float)x, (float)y, (float)z);
	}

	private void drawJEdges(PApplet home) {
		int val00, valm0, valmm, val0m, sum;
		double x, y, z;
		for (int j = getLj(); j < getUj(); j++) {
			y = j * getDY();
			for (int i = getLi(); i <= getUi(); i++) {
				x = i * getDX();
				for (int k = getLk(); k <= getUk(); k++) {
					z = k * getDZ();
					val00 = get(i, j, k) ? 1 : 0;
					valm0 = get(i - 1, j, k) ? 1 : 0;
					valmm = get(i - 1, j, k - 1) ? 1 : 0;
					val0m = get(i, j, k - 1) ? 1 : 0;
					sum = val00 + valm0 + valmm + val0m;
					sum = val00 + valm0 + valmm + val0m;
					if (sum == 1 || sum == 3) {
						line(home,x, y, z, x, y + getDY(), z);
					}
					if (sum == 2) {
						if (val00 + valmm == 2 || val0m + valm0 == 2) {
							line(home,x, y, z, x, y + getDY(), z);
						}
					}
				}
			}
		}
	}

	private void drawJFaces(PApplet home) {
		int val0, valm, sum;
		double x, y, z;
		for (int i = getLi(); i < getUi(); i++) {
			x = i * getDX();
			for (int j = getLj(); j <= getUj(); j++) {
				y = j * getDY();
				for (int k = getLk(); k < getUk(); k++) {
					z = k * getDZ();
					val0 = get(i, j, k) ? 1 : 0;
					valm = get(i, j - 1, k) ? 1 : 0;
					sum = val0 + valm;
					if (sum == 1) {
						home.beginShape();
						vertex(home,x, y, z);
						vertex(home,x + getDX(), y, z);
						vertex(home,x + getDX(), y, z + getDZ());
						vertex(home,x, y, z + getDZ());
						home.endShape();
					}
				}
			}
		}
	}

	private void drawKEdges(PApplet home) {
		int val00, valm0, valmm, val0m, sum;
		double x, y, z;
		for (int k = getLk(); k < getUk(); k++) {
			z = k * getDZ();
			for (int j = getLj(); j <= getUj(); j++) {
				y = j * getDY();
				for (int i = getLi(); i <= getUi(); i++) {
					x = i * getDX();
					val00 = get(i, j, k) ? 1 : 0;
					valm0 = get(i - 1, j, k) ? 1 : 0;
					valmm = get(i - 1, j - 1, k) ? 1 : 0;
					val0m = get(i, j - 1, k) ? 1 : 0;
					sum = val00 + valm0 + valmm + val0m;
					if (sum == 1 || sum == 3) {
						line(home,x, y, z, x, y, z + getDZ());
					}
					if (sum == 2) {
						if (val00 + valmm == 2 || val0m + valm0 == 2) {
							line(home,x, y, z, x, y, z + getDZ());
						}
					}
				}
			}
		}
	}

	private void drawKFaces(PApplet home) {
		int val0, valm, sum;
		double x, y, z;
		for (int i = getLi(); i < getUi(); i++) {
			x = i * getDX();
			for (int j = getLj(); j < getUj(); j++) {
				y = j * getDY();
				for (int k = getLk(); k <= getUk(); k++) {
					z = k * getDZ();
					val0 = get(i, j, k) ? 1 : 0;
					valm = get(i, j, k - 1) ? 1 : 0;
					sum = val0 + valm;
					if (sum == 1) {
						home.beginShape();
						vertex(home,x, y, z);
						vertex(home,x + getDX(), y, z);
						vertex(home,x + getDX(), y + getDY(), z);
						vertex(home,x, y + getDY(), z);
						home.endShape();
					}
				}
			}
		}
	}






	/**
	 *
	 * @param mesh
	 * @param home
	 * @return
	 */
	public PShape createPShape(
			final PApplet home) {
		home.pushMatrix();
		final PShape retained = home.createShape();
		retained.beginShape(PConstants.QUADS);
		double[] c =getMin();
		retained.translate((float)c[0],(float)c[1],(float)c[2]);
		drawIFaces( retained);
		drawJFaces( retained);
		drawKFaces( retained);
		retained.endShape();
		home.popMatrix();
		return retained;
	}

	/**
	 *
	 * @param home
	 * @param mesh
	 * @return
	 */
	public PShape createPShape( final PApplet home, int[] colors) {
		home.pushMatrix();
		home.pushStyle();
		final PShape retained = home.createShape();
		retained.beginShape(PConstants.QUADS);
		double[] c = getMin();
		retained.translate((float)c[0],(float)c[1],(float)c[2]);
		home.noStroke();
		home.fill(colors[0]);
		drawIFaces( retained);
		home.fill(colors[1]);
		drawJFaces( retained);
		home.fill(colors[2]);
		drawKFaces( retained);
		retained.endShape();
		home.popStyle();
		home.popMatrix();
		return retained;
	}

	public PShape[] createPShapes( final PApplet home, int[] colors) {
		PShape[] result = new PShape[3];
		home.pushMatrix();
		home.pushStyle();
		result[0] = home.createShape();
		result[0].beginShape(PConstants.QUADS);
		double[] c = getMin();
		result[0].translate((float)c[0],(float)c[1],(float)c[2]);
		home.noStroke();
		home.fill(colors[0]);
		drawIFaces( result[0]);
		result[0].endShape();
		result[1] = home.createShape();
		result[1].beginShape(PConstants.QUADS);
		result[1].translate((float)c[0],(float)c[1],(float)c[2]);
		home.noStroke();
		home.fill(colors[1]);
		drawJFaces( result[1]);
		result[1].endShape();
		result[2] = home.createShape();
		result[2].beginShape(PConstants.QUADS);
		result[2].translate((float)c[0],(float)c[1],(float)c[2]);
		home.noStroke();
		home.fill(colors[2]);
		drawKFaces( result[2]);
		result[2].endShape();
		home.popStyle();
		home.popMatrix();
		return result;
	}

	public PShape createWireframePShape(final PApplet home) {
		home.pushMatrix();
		final PShape retained = home.createShape();
		retained.beginShape(PConstants.LINES);
		double[] c = getMin();
		retained.translate((float)c[0],(float)c[1],(float)c[2]);
		drawIEdges( retained);
		drawJEdges( retained);
		drawKEdges( retained);
		retained.endShape();
		home.popMatrix();
		return retained;
	}

	private void drawIEdges(final  PShape retained) {
		int val00, valm0, valmm, val0m, sum;
		double x, y, z;
		for (int i = getLi(); i < getUi(); i++) {
			x = i * getDX();
			for (int j = getLj(); j <= getUj(); j++) {
				y = j * getDY();
				for (int k = getLk(); k <= getUk(); k++) {
					z = k * getDZ();
					val00 = get(i, j, k) ? 1 : 0;
					valm0 = get(i, j - 1, k) ? 1 : 0;
					valmm = get(i, j - 1, k - 1) ? 1 : 0;
					val0m = get(i, j, k - 1) ? 1 : 0;
					sum = val00 + valm0 + valmm + val0m;
					if (sum == 1 || sum == 3) {
						line(retained, x, y, z, x + getDX(), y, z);
					}
					if (sum == 2) {
						if (val00 + valmm == 2 || val0m + valm0 == 2) {
							line(retained, x, y, z, x + getDX(), y, z);
						}
					}
				}
			}
		}
	}

	private void drawIFaces(final  PShape retained) {
		int val0, valm, sum;
		double x, y, z;
		for (int i = getLi(); i <= getUi(); i++) {
			x = i * getDX();
			for (int j = getLj(); j < getUj(); j++) {
				y = j * getDY();
				for (int k = getLk(); k < getUk(); k++) {
					z = k * getDZ();
					val0 = get(i, j, k) ? 1 : 0;
					valm = get(i - 1, j, k) ? 1 : 0;
					sum = val0 + valm;
					if (sum == 1) {
						retained.vertex((float) x, (float) y, (float) z);
						retained.vertex((float) x, (float) (y + getDY()),
								(float) z);
						retained.vertex((float) x, (float) (y + getDY()),
								(float) (z + getDZ()));
						retained.vertex((float) x, (float) y,
								(float) (z + getDZ()));
					}
				}
			}
		}
	}

	private void drawJEdges(final  PShape retained) {
		int val00, valm0, valmm, val0m, sum;
		double x, y, z;
		for (int j = getLj(); j < getUj(); j++) {
			y = j * getDY();
			for (int i = getLi(); i <= getUi(); i++) {
				x = i * getDX();
				for (int k = getLk(); k <= getUk(); k++) {
					z = k * getDZ();
					val00 = get(i, j, k) ? 1 : 0;
					valm0 = get(i - 1, j, k) ? 1 : 0;
					valmm = get(i - 1, j, k - 1) ? 1 : 0;
					val0m = get(i, j, k - 1) ? 1 : 0;
					sum = val00 + valm0 + valmm + val0m;
					sum = val00 + valm0 + valmm + val0m;
					if (sum == 1 || sum == 3) {
						line(retained, x, y, z, x, y + getDY(), z);
					}
					if (sum == 2) {
						if (val00 + valmm == 2 || val0m + valm0 == 2) {
							line(retained, x, y, z, x, y + getDY(), z);
						}
					}
				}
			}
		}
	}

	private void drawJFaces(final  PShape retained) {
		int val0, valm, sum;
		double x, y, z;
		for (int i = getLi(); i < getUi(); i++) {
			x = i * getDX();
			for (int j = getLj(); j <= getUj(); j++) {
				y = j * getDY();
				for (int k = getLk(); k < getUk(); k++) {
					z = k * getDZ();
					val0 = get(i, j, k) ? 1 : 0;
					valm = get(i, j - 1, k) ? 1 : 0;
					sum = val0 + valm;
					if (sum == 1) {
						retained.vertex((float) x, (float) y, (float) z);
						retained.vertex((float) (x + getDX()), (float) y,
								(float) z);
						retained.vertex((float) (x + getDX()), (float) y,
								(float) (z + getDZ()));
						retained.vertex((float) x, (float) y,
								(float) (z + getDZ()));
					}
				}
			}
		}
	}

	private void drawKEdges(final  PShape retained) {
		int val00, valm0, valmm, val0m, sum;
		double x, y, z;
		for (int k = getLk(); k < getUk(); k++) {
			z = k * getDZ();
			for (int j = getLj(); j <= getUj(); j++) {
				y = j * getDY();
				for (int i = getLi(); i <= getUi(); i++) {
					x = i * getDX();
					val00 = get(i, j, k) ? 1 : 0;
					valm0 = get(i - 1, j, k) ? 1 : 0;
					valmm = get(i - 1, j - 1, k) ? 1 : 0;
					val0m = get(i, j - 1, k) ? 1 : 0;
					sum = val00 + valm0 + valmm + val0m;
					if (sum == 1 || sum == 3) {
						line(retained, x, y, z, x, y, z + getDZ());
					}
					if (sum == 2) {
						if (val00 + valmm == 2 || val0m + valm0 == 2) {
							line(retained, x, y, z, x, y, z + getDZ());
						}
					}
				}
			}
		}
	}

	private void drawKFaces(final  PShape retained) {
		int val0, valm, sum;
		double x, y, z;
		for (int i = getLi(); i < getUi(); i++) {
			x = i * getDX();
			for (int j = getLj(); j < getUj(); j++) {
				y = j * getDY();
				for (int k = getLk(); k <= getUk(); k++) {
					z = k * getDZ();
					val0 = get(i, j, k) ? 1 : 0;
					valm = get(i, j, k - 1) ? 1 : 0;
					sum = val0 + valm;
					if (sum == 1) {
						retained.vertex((float) x, (float) y, (float) z);
						retained.vertex((float) (x + getDX()), (float) y,
								(float) z);
						retained.vertex((float) (x + getDX()),
								(float) (y + getDY()), (float) z);
						retained.vertex((float) x, (float) (y + getDY()),
								(float) z);
					}
				}
			}
		}
	}

	private void line(PShape retained, final double x1, final double y1,
			final double z1, final double x2, final double y2,
			final double z2) {
		retained.vertex((float) x1, (float) y1, (float) z1);
		retained.vertex((float) x2, (float) y2, (float) z2);
	}






	public void setI(int i) {
		I = i;
	}

	public void setJ(int j) {
		J = j;
	}

	public void setK(int k) {
		K = k;
	}

	public void setCenter(double[] center) {
		this.center = center;
	}

	public void setLi(int li) {
		this.li = li;
	}

	public void setUi(int ui) {
		this.ui = ui;
	}

	public void setLj(int lj) {
		this.lj = lj;
	}

	public void setUj(int uj) {
		this.uj = uj;
	}

	public void setLk(int lk) {
		this.lk = lk;
	}

	public void setUk(int uk) {
		this.uk = uk;
	}






	static class WB_IsoCubeGridArray extends WB_IsoCubeGrid {
		boolean[]	grid;
		int			JK;

		WB_IsoCubeGridArray(double cx, double cy, double cz, final int I, final int J,
				final int K, final double dX, final double dY,
				final double dZ) {
			setI(I);
			setJ(J);
			setK(K);
			JK = K * J;
			setDx(dX);
			setDy(dY);
			setDz(dZ);
			setCenter(new double[] {cx,cy,cz});
			grid = new boolean[JK * I];
			clearLimits();
		}

		WB_IsoCubeGridArray(double cx, double cy, double cz, final int I, final int J,
				final int K, final double dX, final double dY,
				final double dZ, boolean[] grid) {
			setI(I);
			setJ(J);
			setK(K);
			JK = K * J;
			setDx(dX);
			setDy(dY);
			setDz(dZ);
			setCenter(new double[] {cx,cy,cz});
			this.grid = grid;
			clearLimits();
		}


		@Override
		public void set(final int i, final int j, final int k) {
			if (i > -1 && j > -1 && k > -1 && i < getI() && j < getJ()
					&& k < getK()) {
				grid[index(i, j, k)] = true;
			}
		}

		@Override
		public void clear(final int i, final int j, final int k) {
			if (i > -1 && j > -1 && k > -1 && i < getI() && j <getJ()
					&& k < getK()){
				grid[index(i, j, k)] = false;
			}
		}

		@Override
		boolean getInternal(final int i, final int j, final int k) {
			return grid[index(i, j, k)];
		}

		int index(final int i, final int j, final int k) {
			return k + j * getK() + i * JK;
		}
	}
}
