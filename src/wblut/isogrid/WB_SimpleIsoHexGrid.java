package wblut.isogrid;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import processing.core.PApplet;
import processing.core.PConstants;

public class WB_SimpleIsoHexGrid {
	private static final int c = 6;
	private double[] size;
	private double[] origin;
	private static final int[] next = new int[] { 1, 2, 3, 4, 5, 0 };

	private static final double[] vertexOffsets = new double[] { 1, 0, 1, 1, 0, 1, -1, 0, -1, -1, 0, -1, 0, 0};

	private static final int[] mapTrianglesFromPosOne = new int[] { 4, 3, 0, 5, 2, 1 };
	private static final int[] mapQFromPosOne = new int[] { 1, 1, -1, -1, 0, 0 };
	private static final int[] mapRFromPosOne = new int[] { 1, 1, 0, 0, -1, -1 };
	private static final int[] mapTrianglesFromNegOne = new int[] { 2, 5, 4, 1, 0, 3 };
	private static final int[] mapQFromNegOne = new int[] { 1, 0, 0, -1, -1, 1 };
	private static final int[] mapRFromNegOne = new int[] { 0, 1, 1, -1, -1, 0 };
	private static int[][] triangleVertices = new int[][] { { c, 0, 1 }, { c, 1, 2 }, { c, 2, 3 }, { c, 3, 4 },
			{ c, 4, 5 }, { c, 5, 0 } };
	private int[] labels = new int[] { 0, 1, 1, 2, 2, 0 };

	private static double c60 = Math.cos(Math.PI / 3.0);
	private static double s60 = Math.sin(Math.PI / 3.0);
	private double[] offsets;
	private Map<Long, WB_IsoGridCell> cells;
	private Map<Long, WB_IsoGridLine> linesMap;
	private List<WB_IsoGridLine> lines;

	public static final int[][] neighborHexes = new int[][] { { 2, 1 }, { 1, 2 }, { -1, 1 }, { -2, -1 }, { -1, -2 },
			{ 1, -1 } };

	public WB_SimpleIsoHexGrid(double originx, double originy, double sizex, double sizey) {
		size = new double[] { sizex, sizey };
		origin = new double[] { originx, originy };
		offsets = new double[14];
		for (int i = 0; i < 7; i++) {
			offsets[2 * i] = vertexOffsets[2 * i] * s60;
			offsets[2 * i + 1] = (vertexOffsets[2 * i + 1] - vertexOffsets[2 * i] * c60);
		}
		cells = new HashMap<Long, WB_IsoGridCell>();
		linesMap = new HashMap<Long, WB_IsoGridLine>();
		lines = new ArrayList<WB_IsoGridLine>();

	}

	public void setSize(double sizex, double sizey) {
		size = new double[] { sizex, sizey };

	}

	public void setOrigin(double originx, double originy) {
		origin = new double[] { originx, originy };

	}

	public double[] getSize() {
		return size;

	}

	public double[] getOrigin() {
		return origin;

	}

	public int[] hexToCube(int q, int r) {
		int i = q;
		int j = r;
		int k = 0;
		while (i + j + k < -1) {
			i++;
			j++;
			k++;
		}
		while (i + j + k > +1) {
			i--;
			j--;
			k--;
		}
		return new int[] { i, j, k };
	}

	public int[] cubeToHex(int i, int j, int k) {
		return new int[] { i - k, j - k };
	}

	public void clear() {
		cells.clear();
		linesMap.clear();
	}

	public void clearTriangle(int q, int r, int t) {
		long key = getCellHash(q, r);
		WB_IsoGridCell cell = cells.get(key);
		if (cell == null) {
			return;

		}
		cell.colorIndices[t] = 0;
		cell.labels[t] = -1;
		cell.z[t] = -Integer.MAX_VALUE;
		cell.cubei[t] = -Integer.MAX_VALUE;
		cell.cubej[t] = -Integer.MAX_VALUE;
		cell.cubek[t] = -Integer.MAX_VALUE;
		if (cell.isEmpty())
			cells.remove(key);

	}

	public void clearCube(int i, int j, int k) {
		int z = i + j + k;
		int z3 = z / 3;
		int ni = i - z3;
		int nj = j - z3;
		int nk = k - z3;
		int layer = ni + nj + nk;
		while (layer > 1) {
			ni--;
			nj--;
			nk--;
			layer = ni + nj + nk;
		}
		while (layer < -1) {
			ni++;
			nj++;
			nk++;
			layer = ni + nj + nk;
		}
		int q = i - k;
		int r = j - k;
		int nt;
		switch (layer) {

		case 0:
			for (int t = 0; t < 6; t++) {

				clearTriangle(q, r, t);
			}
			break;
		case 1:
			for (int t = 0; t < 6; t++) {
				nt = mapTrianglesFromPosOne[t];
				clearTriangle(q + mapQFromPosOne[t], r + mapRFromPosOne[t], nt);
			}
			break;
		case -1:
			for (int t = 0; t < 6; t++) {
				nt = mapTrianglesFromNegOne[t];
				clearTriangle(q + mapQFromNegOne[t], r + mapRFromNegOne[t], nt);
			}
			break;
		default:

		}
	}

	public void clearHex(int q, int r) {
		int[] ijk = hexToCube(q, r);
		clearCube(ijk[0], ijk[1], ijk[2]);
	}

	// "Add" is conditional and only overwrites if its z-value is higher than
	// current values
	public void addTriangle(int q, int r, int t, int z, int label, int colorIndex, int i, int j, int k) {
		long key = getCellHash(q, r);
		WB_IsoGridCell cell = cells.get(key);

		if (cell == null) {
			cell = new WB_IsoGridCell(q, r,6);
			cells.put(key, cell);

		}

		if (z > cell.z[t]) {
			cell.labels[t] = label;
			cell.z[t] = z;
			cell.colorIndices[t] = colorIndex;
			cell.cubei[t] = i;
			cell.cubej[t] = j;
			cell.cubek[t] = k;
		}

	}

	public void addTriangle(int q, int r, int t, int z, int label, int i, int j, int k) {
		addTriangle(q, r, t, z, label, 0, i, j, k);

	}

	public void addCube(int i, int j, int k) {
		addCube(i, j, k, 0);
	}


	public void addCube(int i, int j, int k, int colorIndex) {
		int z = i + j + k;
		int z3 = z / 3;
		int ni = i - z3;
		int nj = j - z3;
		int nk = k - z3;
		int layer = ni + nj + nk;
		while (layer > 1) {
			ni--;
			nj--;
			nk--;
			layer = ni + nj + nk;
		}
		while (layer < -1) {
			ni++;
			nj++;
			nk++;
			layer = ni + nj + nk;
		}
		int q = i - k;
		int r = j - k;
		int nt;
		switch (layer) {

		case 0:
			for (int t = 0; t < 6; t++) {
				addTriangle(q, r, t, z, labels[t], colorIndex, i, j, k);
			}
			break;

		case +1:
			for (int t = 0; t < 6; t++) {
				nt = mapTrianglesFromPosOne[t];
				addTriangle(q + mapQFromPosOne[t], r + mapRFromPosOne[t], nt, z, labels[t], colorIndex, i, j, k);
			}
			break;
		case -1:
			for (int t = 0; t < 6; t++) {
				nt = mapTrianglesFromNegOne[t];
				addTriangle(q + mapQFromNegOne[t], r + mapRFromNegOne[t], nt, z, labels[t], colorIndex, i, j, k);
			}
			break;

		default:

		}
	}

	public double[] getGridCoordinates(double q, double r) {
		return new double[] { q * s60 * size[0] + origin[0], (r - q * c60) * size[1] + origin[1] };
	}

	public List<WB_IsoGridCell> getCells() {
		List<WB_IsoGridCell> cellsList = new ArrayList<WB_IsoGridCell>();
		cellsList.addAll(cells.values());
		cellsList.sort(new WB_IsoGridCell.HexCellSort());
		return cellsList;
	}

	public void collectLines() {
		linesMap.clear();
		collectInterHexSegments();
		collectInterTriangleSegments();
		lines = new ArrayList<WB_IsoGridLine>();
		lines.addAll(linesMap.values());
		lines.sort(new WB_IsoGridLine.HexLineSort());
		int i = 0;
		for (WB_IsoGridLine line : lines) {
			line.sort();
			line.optimize();
			if (i % 2 == 0)
				line.reverse();
			i++;
		}
	}

	public List<WB_IsoGridLine> getLines() {
		return lines;
	}

	// long hash from 2 int
	private static long getCellHash(int q, int r) {
		long A = (q >= 0 ? 2 * (long) q : -2 * (long) q - 1);
		long B = (r >= 0 ? 2 * (long) r : -2 * (long) r - 1);
		long C = ((A >= B ? A * A + A + B : A + B * B) / 2);
		return q < 0 && r < 0 || q >= 0 && r >= 0 ? C : -C - 1;
	}

	private static final int[] interHexNeighbor = new int[] { 3, 4, 5, 0, 1, 2 };
	private static final int[] interHexSegment = new int[] { 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 0 };
	private static final int[] interHexNeighborQ = new int[] { +2, +1, -1, -2, -1, 1, };
	private static final int[] interHexNeighborR = new int[] { +1, +2, 1, -1, -2, -1 };

	private void collectInterHexSegments() {
		WB_IsoGridCell neighbor;
		int z, label, colorIndex;
		long hash, nhash;
		for (WB_IsoGridCell cell : cells.values()) {
			hash = getCellHash(cell.getQ(), cell.getR());
			for (int i = 0; i < 6; i++) {
				if (cell.getLabel(i) >= 0) {
					if (interHexNeighbor[i] >= 0) {
						neighbor = getNeighbor(cell.getQ(), cell.getR(), i);
						if (neighbor == null) {
							addSegment(cell.getQ(), cell.getR(), interHexSegment[2 * i], interHexSegment[2 * i + 1]);
						} else {
							nhash = getCellHash(cell.getQ() + interHexNeighborQ[i], cell.getR() + interHexNeighborR[i]);
							label = neighbor.getLabel(interHexNeighbor[i]);
							if (nhash < hash || label == -1) {

								z = neighbor.getZ(interHexNeighbor[i]);
								colorIndex = neighbor.getColorIndex(interHexNeighbor[i]);
								if (areSeparate(label, cell.getLabel(i), colorIndex, cell.getColorIndex(i),
										cell.getZ(i), z)) {
									addSegment(cell.getQ(), cell.getR(), interHexSegment[2 * i],
											interHexSegment[2 * i + 1]);
								}
							}

						}
					}
				}

			}

		}
	}

	private static final int[] interTriangleNeighbor = new int[] { 1,2,3,4,5,0 };
	private static final int[] interTriangleSegment = new int[] { c,1,c,2,c,3,c,4,c,5,c,0 };

	private void collectInterTriangleSegments() {
		int z, label, colorIndex;
		for (WB_IsoGridCell cell : cells.values()) {
			for (int i = 0; i < 6; i++) {
				
					label = cell.getLabel(interTriangleNeighbor[i]);
					z = cell.getZ(interTriangleNeighbor[i]);
					colorIndex = cell.getColorIndex(interTriangleNeighbor[i]);
					if (areSeparate(label, cell.getLabel(i), colorIndex, cell.getColorIndex(i), cell.getZ(i), z)) {
						addSegment(cell.getQ(), cell.getR(), interTriangleSegment[2 * i],
								interTriangleSegment[2 * i + 1]);
					}
				

			}

		}
	}

	private WB_IsoGridCell getNeighbor(int q, int r, int i) {
		return cells.get(getCellHash(q + interHexNeighborQ[i], r + interHexNeighborR[i]));
	}

	private void addSegment(double q, double r, int i1, int i2) {
		WB_IsoGridSegment segment = new WB_IsoGridSegment((int) Math.round(6 * (q + vertexOffsets[2 * i1])),
				(int) Math.round(6 * (r + vertexOffsets[2 * i1 + 1])),
				(int) Math.round(6 * (q + vertexOffsets[2 * i2])),
				(int) Math.round(6 * (r + vertexOffsets[2 * i2 + 1])));
		long key = segment.getHash();
		WB_IsoGridLine line = linesMap.get(key);
		if (line == null) {
			line = new WB_IsoGridLine(segment.getType(), segment.getLineValue());
			linesMap.put(key, line);
		}
		line.add(segment);

	}

	private void vertex(PApplet home, final double px, double py) {
		home.vertex((float) px, (float) py);
	}

	public void drawPoint(PApplet home, double q, double r) {
		double[] point = getGridCoordinates(q, r);
		home.point((float) point[0], (float) point[1]);
	}

	public void drawLine(PApplet home, double q1, double r1, double q2, double r2) {
		double[] point1 = getGridCoordinates(q1, r1);
		double[] point2 = getGridCoordinates(q2, r2);
		home.line((float) point1[0], (float) point1[1], (float) point2[0], (float) point2[1]);
	}

	public void drawLabel(PApplet home, int q, int r, double dx, double dy) {
		double[] point = getGridCoordinates(q, r);
		home.text("(" + q + ", " + r + ")", (float) (point[0] + dx), (float) (point[1] + dy));
	}

	public void drawHex(PApplet home, int q, int r) {
		double[] center = getGridCoordinates(q, r);
		home.beginShape();
		for (int i = 0; i < 6; i++) {
			vertex(home, center[0] + offsets[2 * i] * size[0], center[1] + offsets[2 * i + 1] * size[1]);
		}
		home.endShape(PConstants.CLOSE);
	}

	public void drawHex(PApplet home, double[] center) {
		home.beginShape();
		for (int i = 0; i < 6; i++) {
			vertex(home, center[0] + offsets[2 * i] * size[0], center[1] + offsets[2 * i + 1] * size[1]);
		}
		home.endShape(PConstants.CLOSE);
	}

	public void drawTriangle(PApplet home, int q, int r, int t) {
		double[] center = getGridCoordinates(q, r);
		home.beginShape();
		vertex(home, center[0], center[1]);
		vertex(home, center[0] + offsets[2 * t] * size[0], center[1] + offsets[2 * t + 1] * size[1]);
		vertex(home, center[0] + offsets[2 * next[t]] * size[0], center[1] + offsets[2 * next[t] + 1] * size[1]);
		home.endShape(PConstants.CLOSE);
	}

	public void drawTriangle(PApplet home, double[] center, int t) {
		home.beginShape();
		vertex(home, center[0], center[1]);
		vertex(home, center[0] + offsets[2 * t] * size[0], center[1] + offsets[2 * t + 1] * size[1]);
		vertex(home, center[0] + offsets[2 * next[t]] * size[0], center[1] + offsets[2 * next[t] + 1] * size[1]);
		home.endShape(PConstants.CLOSE);
	}

	public void drawHexGrid(PApplet home) {
		for (WB_IsoGridCell cell : cells.values()) {
			drawHex(home, cell.getQ(), cell.getR());
		}
	}

	public void drawHexCenters(PApplet home) {
		for (WB_IsoGridCell cell : cells.values()) {
			drawPoint(home, cell.getQ(), cell.getR());
		}
	}

	public void drawTriangles(PApplet home) {
		double[] center;
		for (WB_IsoGridCell cell : cells.values()) {
			center = getGridCoordinates(cell.getQ(), cell.getR());
			for (int f = 0; f < 6; f++) {
				if (cell.labels[f] > -1) {
					home.beginShape(PConstants.TRIANGLES);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][0]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][0] + 1] * size[1]);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][1]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][1] + 1] * size[1]);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][2]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][2] + 1] * size[1]);

					home.endShape();
				}
			}
		}
	}

	public void drawTriangles(PApplet home, int[] colors) {
		double[] center;
		for (WB_IsoGridCell cell : cells.values()) {
			center = getGridCoordinates(cell.getQ(), cell.getR());
			for (int f = 0; f < 6; f++) {
				if (cell.labels[f] > -1) {

					home.fill(colors[3 * cell.colorIndices[f] + cell.labels[f]]);
					home.beginShape(PConstants.TRIANGLES);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][0]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][0] + 1] * size[1]);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][1]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][1] + 1] * size[1]);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][2]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][2] + 1] * size[1]);

					home.endShape();
				}
			}
		}
	}

	public void drawTriangles(PApplet home, int zmin, int zmax) {
		double[] center;
		for (WB_IsoGridCell cell : cells.values()) {
			center = getGridCoordinates(cell.getQ(), cell.getR());
			for (int f = 0; f < 6; f++) {
				if (cell.labels[f] > -1 && cell.z[f] >= zmin && cell.z[f] < zmax) {
					home.beginShape(PConstants.TRIANGLES);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][0]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][0] + 1] * size[1]);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][1]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][1] + 1] * size[1]);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][2]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][2] + 1] * size[1]);

					home.endShape();
				}
			}
		}
	}

	public void drawTriangles(PApplet home, int[] colors, int zmin, int zmax) {
		double[] center;
		for (WB_IsoGridCell cell : cells.values()) {
			center = getGridCoordinates(cell.getQ(), cell.getR());
			for (int f = 0; f < 6; f++) {
				if (cell.labels[f] > -1 && cell.z[f] >= zmin && cell.z[f] < zmax) {

					home.fill(colors[3 * cell.colorIndices[f] + cell.labels[f]]);
					home.beginShape(PConstants.TRIANGLES);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][0]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][0] + 1] * size[1]);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][1]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][1] + 1] * size[1]);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][2]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][2] + 1] * size[1]);

					home.endShape();
				}
			}
		}
	}

	public void drawTriangles(PApplet home, int[] colors, int zmin, int zmax, int znear, int zfar, int mini, int maxi,
			int minj, int maxj, int mink, int maxk) {
		double[] center;
		for (WB_IsoGridCell cell : cells.values()) {
			center = getGridCoordinates(cell.getQ(), cell.getR());
			for (int f = 0; f < 6; f++) {
				if (cell.labels[f] > -1 && cell.z[f] >= zmin && cell.z[f] < zmax && cell.cubei[f] >= mini
						&& cell.cubei[f] < maxi && cell.cubej[f] >= minj && cell.cubej[f] < maxj
						&& cell.cubek[f] >= mink && cell.cubek[f] < maxk) {
					home.fill(color(colors[3 * cell.colorIndices[f] + cell.labels[f]],
							(cell.colorIndices[f] == 0) ? cell.z[f] : znear, zfar, znear));
					home.beginShape(PConstants.TRIANGLES);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][0]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][0] + 1] * size[1]);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][1]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][1] + 1] * size[1]);
					vertex(home, center[0] + offsets[2 * triangleVertices[f][2]] * size[0],
							center[1] + offsets[2 * triangleVertices[f][2] + 1] * size[1]);

					home.endShape();
				}
			}
		}
	}

	public void drawLines(PApplet home) {
		for (WB_IsoGridLine line : lines) {
			for (WB_IsoGridSegment segment : line.getSegments()) {
				home.line((float) (segment.getQ1() / 6.0 * s60 * size[0] + origin[0]),
						(float) ((segment.getR1() - segment.getQ1() * c60) / 6.0 * size[1] + origin[1]),
						(float) ((segment.getQ2() / 6.0 * s60 * size[0]) + origin[0]),
						(float) ((segment.getR2() - segment.getQ2() * c60) / 6.0 * size[1] + origin[1]));
			}
		}
	}

	private static boolean areSeparate(int label1, int label2, int colorIndex1, int colorIndex2, int z1, int z2) {
		return label1 != label2 || colorIndex1 != colorIndex2 || Math.abs(z1 - z2) > 1;
	}

	private static int color(final int color, int z, int zmin, int zmax) {
		int r = (color >> 16) & 0xff;
		int g = (color >> 8) & 0xff;
		int b = (color) & 0xff;
		double f = (z - zmin) / (double) (zmax - zmin);
		f = Math.min(Math.max(f, 0.0), 1.0);
		return 255 << 24 | ((int) Math.round(f * r)) << 16 | ((int) Math.round(f * g)) << 8 | ((int) Math.round(f * b));
	}

}
