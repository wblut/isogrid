package wblut.isogrid;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import processing.core.PApplet;
import processing.core.PConstants;

public class WB_IsoHexGrid {

	private double[] size;
	private double[] origin;
	private static final int[] next = new int[] { 1, 2, 3, 4, 5, 0 };
	private static final int[] triangleLabels = new int[] { 0, 1, 1, 2, 2, 0 };
	private static final int[] flippedTriangleLabels = new int[] { 2, 2, 0, 0, 1, 1 };
	private static final int[] neighborTriangles = new int[] { 3, 4, 5, 0, 1, 2 };
	private static double c60 = Math.cos(Math.PI / 3.0);
	private static double s60 = Math.sin(Math.PI / 3.0);
	private double[][] offsets;
	private Map<Long, WB_IsoGridCell> cells;
	private Map<Long, WB_IsoGridLine> linesMap;
	private List<WB_IsoGridLine> lines;
	private boolean flipped;

	public static final int[][] directions = new int[][] { { 1, 0 }, { 1, 1 }, { 0, 1 }, { -1, 0 }, { -1, -1 },
			{ 0, -1 } };

	public static final int[][] neighborHexes = new int[][] { { 2, 1 }, { 1, 2 }, { -1, 1 }, { -2, -1 }, { -1, -2 },
			{ 1, -1 } };

	public WB_IsoHexGrid(double originx, double originy, double sizex, double sizey) {
		size = new double[] { sizex, sizey };
		origin = new double[] { originx, originy };
		offsets = new double[6][2];
		for (int i = 0; i < 6; i++) {
			offsets[i][0] = directions[i][0] * s60 * size[0];
			offsets[i][1] = (directions[i][1] - directions[i][0] * c60) * size[1];
		}
		cells = new HashMap<Long, WB_IsoGridCell>();
		linesMap = new HashMap<Long, WB_IsoGridLine>();
		lines = new ArrayList<WB_IsoGridLine>();

	}

	// Rotate hexes by 180°
	public void setFlipped(boolean b) {
		flipped = b;
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
		return new int[] { i - k, j-k };
	}

	public void clear() {
		cells.clear();
		linesMap.clear();
		;
	}

	// "Set" is unconditional and overrides current values
	public void clearTriangle(int q, int r, int t) {
		long key = getCellHash(q, r);
		WB_IsoGridCell cell = cells.get(key);

		if (cell == null) {
			cell = new WB_IsoGridCell(q, r);
			cells.put(key, cell);

		}

		cell.labels[t] = -1;
		cell.z[t] = -Integer.MAX_VALUE;
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
		switch (layer) {
		case 0:
			for (int t = 0; t < 6; t++) {
				clearTriangle(q, r, t);
			}
			break;
		case 1:
			clearTriangle(q + 1, r + 1, 4);
			clearTriangle(q + 1, r + 1, 3);
			clearTriangle(q - 1, r, 0);
			clearTriangle(q - 1, r, 5);
			clearTriangle(q, r - 1, 2);
			clearTriangle(q, r - 1, 1);
			break;
		case -1:
			clearTriangle(q + 1, r, 2);
			clearTriangle(q, r + 1, 5);
			clearTriangle(q, r + 1, 4);
			clearTriangle(q - 1, r - 1, 1);
			clearTriangle(q - 1, r - 1, 0);
			clearTriangle(q + 1, r, 3);
			break;
		default:

		}
	}

	public void clearHex(int q, int r) {
		int[] ijk = hexToCube(q, r);
		clearCube(ijk[0], ijk[1], ijk[2]);
	}

	public void setTriangle(int q, int r, int t, int label) {
		long key = getCellHash(q, r);
		WB_IsoGridCell cell = cells.get(key);
		if (cell == null) {
			cell = new WB_IsoGridCell(q, r);
			cells.put(key, cell);
		}
		cell.labels[t] = label;
	}

	public void setHex(int q, int r) {
		int[] ijk = hexToCube(q, r);
		setCube(ijk[0], ijk[1], ijk[2]);
	}

	public void setCube(int i, int j, int k) {
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
		switch (layer) {
		case 0:
			for (int t = 0; t < 6; t++) {
				setTriangle(q, r, t, flipped ? flippedTriangleLabels[t] : triangleLabels[t]);
			}
			break;
		case 1:
			setTriangle(q + 1, r + 1, 4, flipped ? flippedTriangleLabels[0] : triangleLabels[0]);
			setTriangle(q + 1, r + 1, 3, flipped ? flippedTriangleLabels[1] : triangleLabels[1]);
			setTriangle(q - 1, r, 0, flipped ? flippedTriangleLabels[2] : triangleLabels[2]);
			setTriangle(q - 1, r, 5, flipped ? flippedTriangleLabels[3] : triangleLabels[3]);
			setTriangle(q, r - 1, 2, flipped ? flippedTriangleLabels[4] : triangleLabels[4]);
			setTriangle(q, r - 1, 1, flipped ? flippedTriangleLabels[5] : triangleLabels[5]);
			break;
		case -1:
			setTriangle(q + 1, r, 2, flipped ? flippedTriangleLabels[0] : triangleLabels[0]);
			setTriangle(q, r + 1, 5, flipped ? flippedTriangleLabels[1] : triangleLabels[1]);
			setTriangle(q, r + 1, 4, flipped ? flippedTriangleLabels[2] : triangleLabels[2]);
			setTriangle(q - 1, r - 1, 1, flipped ? flippedTriangleLabels[3] : triangleLabels[3]);
			setTriangle(q - 1, r - 1, 0, flipped ? flippedTriangleLabels[4] : triangleLabels[4]);
			setTriangle(q + 1, r, 3, flipped ? flippedTriangleLabels[5] : triangleLabels[5]);
			break;
		default:

		}
	}

	// "Add" is conditional and only overwrites if its z-value is higher than
	// current values
	public void addTriangle(int q, int r, int t, int z, int label) {
		long key = getCellHash(q, r);
		WB_IsoGridCell cell = cells.get(key);

		if (cell == null) {
			cell = new WB_IsoGridCell(q, r);
			cells.put(key, cell);

		}
		if (z > cell.z[t]) {
			cell.labels[t] = label;
			cell.z[t] = z;
		}

	}

	public void addHex(int q, int r) {
		int[] ijk = hexToCube(q, r);
		addCube(ijk[0], ijk[1], ijk[2]);
	}

	public void addCube(int i, int j, int k) {

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
		switch (layer) {
		case 0:
			for (int t = 0; t < 6; t++) {
				addTriangle(q, r, t, z, flipped ? flippedTriangleLabels[t] : triangleLabels[t]);
			}
			break;
		case 1:
			addTriangle(q + 1, r + 1, 4, z, flipped ? flippedTriangleLabels[0] : triangleLabels[0]);
			addTriangle(q + 1, r + 1, 3, z, flipped ? flippedTriangleLabels[1] : triangleLabels[1]);
			addTriangle(q - 1, r, 0, z, flipped ? flippedTriangleLabels[2] : triangleLabels[2]);
			addTriangle(q - 1, r, 5, z, flipped ? flippedTriangleLabels[3] : triangleLabels[3]);
			addTriangle(q, r - 1, 2, z, flipped ? flippedTriangleLabels[4] : triangleLabels[4]);
			addTriangle(q, r - 1, 1, z, flipped ? flippedTriangleLabels[5] : triangleLabels[5]);
			break;
		case -1:
			addTriangle(q + 1, r, 2, z, flipped ? flippedTriangleLabels[0] : triangleLabels[0]);
			addTriangle(q, r + 1, 5, z, flipped ? flippedTriangleLabels[1] : triangleLabels[1]);
			addTriangle(q, r + 1, 4, z, flipped ? flippedTriangleLabels[2] : triangleLabels[2]);
			addTriangle(q - 1, r - 1, 1, z, flipped ? flippedTriangleLabels[3] : triangleLabels[3]);
			addTriangle(q - 1, r - 1, 0, z, flipped ? flippedTriangleLabels[4] : triangleLabels[4]);
			addTriangle(q + 1, r, 3, z, flipped ? flippedTriangleLabels[5] : triangleLabels[5]);
			break;
		default:

		}
	}

	public void addGrid(WB_IsoCubeGrid grid) {
		cells.clear();
		for (int i = 0; i < grid.getI(); i++) {
			for (int j = 0; j < grid.getJ(); j++) {
				for (int k = 0; k < grid.getK(); k++) {
					if (grid.get(i, j, k))
						addCube(i, j, k);
				}
			}
		}
	}

	public double[] gridCoordinates(int q, int r) {
		return new double[] { q * s60 * size[0] + origin[0], (r - q * c60) * size[1] + origin[1] };
	}

	public void collectLines() {
		linesMap.clear();
		collectOuterLines();
		collectInnerLines();
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

	public void drawPoint(PApplet home, int q, int r) {
		double[] point = gridCoordinates(q, r);
		home.point((float) point[0], (float) point[1]);
	}
	
	public void drawLabel(PApplet home, int q, int r, double dx, double dy) {
		double[] point = gridCoordinates(q, r);
		home.text("("+q+", "+r+")",(float) (point[0]+dx), (float) (point[1]+dy));
	}

	public void drawHex(PApplet home, int q, int r) {
		double[] center = gridCoordinates(q, r);
		home.beginShape();
		for (int i = 0; i < 6; i++) {
			vertex(home, center[0] + offsets[i][0], center[1] + offsets[i][1]);
		}
		home.endShape();
	}
	
	public void drawTriangle(PApplet home, int q, int r,int t) {
		double[] center = gridCoordinates(q, r);
		home.beginShape(PConstants.TRIANGLE);
		vertex(home, center[0], center[1]);
		vertex(home,center[0] + offsets[t][0], center[1] + offsets[t][1]);
		vertex(home, center[0] + offsets[next[t]][0], center[1] + offsets[next[t]][1]);
		home.endShape();
	}
	

	public void drawHexGrid(PApplet home) {
		for (WB_IsoGridCell cell : cells.values()) {
			drawHex(home,cell.getQ(),cell.getR());
		}
	}

	public void drawHexCenters(PApplet home) {
		for (WB_IsoGridCell cell : cells.values()) {
			drawPoint(home,cell.getQ(),cell.getR());
		}
	}
	
	public void drawTriangles(PApplet home) {
		double[] center;
		for (WB_IsoGridCell cell : cells.values()) {
			center = gridCoordinates(cell.getQ(), cell.getR());
			for (int i = 0; i < 6; i++) {
				
				if (cell.labels[i] > -1) {
					home.beginShape(PConstants.TRIANGLES);
					vertex(home, center[0], center[1]);
					vertex(home, center[0] + offsets[i][0], center[1] + offsets[i][1]);
					vertex(home, center[0] + offsets[next[i]][0], center[1] + offsets[next[i]][1]);
					home.endShape();
				}
			}
		}
	}

	public void drawTriangles(PApplet home, int[] colors) {
		double[] center;
		for (WB_IsoGridCell cell : cells.values()) {
			center = gridCoordinates(cell.getQ(), cell.getR());
			for (int i = 0; i < 6; i++) {
				
				if (cell.labels[i] > -1) {
					home.fill(colors[cell.labels[i]]);
					home.beginShape(PConstants.TRIANGLES);
					vertex(home, center[0], center[1]);
					vertex(home, center[0] + offsets[i][0], center[1] + offsets[i][1]);
					vertex(home, center[0] + offsets[next[i]][0], center[1] + offsets[next[i]][1]);
					home.endShape();
				}
			}
		}
	}

	public void drawLines(PApplet home) {
		for (WB_IsoGridLine line : lines) {
			for (WB_IsoGridSegment segment : line.getSegments()) {
				home.line((float) (segment.getQ1() * s60 * size[0] + origin[0]),
						(float) ((segment.getR1() - segment.getQ1() * c60) * size[1] + origin[1]),
						(float) ((segment.getQ2() * s60 * size[0]) + origin[0]),
						(float) ((segment.getR2() - segment.getQ2() * c60) * size[1] + origin[1]));
			}
		}
	}

	public List<WB_IsoGridCell> getCells() {
		List<WB_IsoGridCell> cellsList = new ArrayList<WB_IsoGridCell>();
		cellsList.addAll(cells.values());
		cellsList.sort(new WB_IsoGridCell.HexCellSort());
		return cellsList;
	}

	public List<WB_IsoGridLine> getLines() {
		return lines;
	}

	private boolean checkNeighborLabel(int q, int r, int i, int label, int z) {
		long nhash = getCellHash(q + neighborHexes[i][0], r + neighborHexes[i][1]);
		WB_IsoGridCell neighbor = cells.get(nhash);
		if (neighbor == null) {
			// No neighbor, draw line
			return true;
		}
		if (neighbor.labels[neighborTriangles[i]] == -1) {
			// Neighbor triangle is empty, dra line
			return true;
		}
		// Two triangles neighboring, only process this once per pair.
		if ((getCellHash(q, r) < nhash))
			return false;

		// If triangles have different label or arent't part of neighboring faces, draw
		// line
		return neighbor.labels[neighborTriangles[i]] != label || Math.abs(neighbor.z[neighborTriangles[i]] - z) > 1;
	}

	private boolean hasNeighbor(int q, int r, int i) {
		WB_IsoGridCell neighbor = cells.get(getCellHash(q + neighborHexes[i][0], r + neighborHexes[i][1]));
		if (neighbor == null)
			return false;
		return true;
	}

	private static long getCellHash(int q, int r) {
		long A = (q >= 0 ? 2 * (long) q : -2 * (long) q - 1);
		long B = (r >= 0 ? 2 * (long) r : -2 * (long) r - 1);
		long C = ((A >= B ? A * A + A + B : A + B * B) / 2);
		return q < 0 && r < 0 || q >= 0 && r >= 0 ? C : -C - 1;
	}

	private static long getLineHash(int type, int lineValue) {
		long A = (type >= 0 ? 2 * (long) type : -2 * (long) type - 1);
		long B = (lineValue >= 0 ? 2 * (long) lineValue : -2 * (long) lineValue - 1);
		long C = ((A >= B ? A * A + A + B : A + B * B) / 2);
		return type < 0 && lineValue < 0 || type >= 0 && lineValue >= 0 ? C : -C - 1;
	}

	private void collectOuterLines() {
		for (WB_IsoGridCell cell : cells.values()) {
			for (int i = 0; i < 6; i++) {
				if (cell.labels[i] > -1) {
					if (!hasNeighbor(cell.getQ(), cell.getR(), i)
							|| checkNeighborLabel(cell.getQ(), cell.getR(), i, cell.labels[i], cell.z[i])) {
						WB_IsoGridSegment segment = new WB_IsoGridSegment(cell.getQ() + directions[i][0],
								cell.getR() + directions[i][1], cell.getQ() + directions[(i + 1) % 6][0],
								cell.getR() + directions[(i + 1) % 6][1]);
						long key = getLineHash(segment.getType(), segment.getGroupValue());
						WB_IsoGridLine line = linesMap.get(key);
						if (line == null) {
							line = new WB_IsoGridLine(segment.getType(), segment.getGroupValue());
							linesMap.put(key, line);
						}
						line.add(segment);

					}
				}
			}

		}

	}

	private void collectInnerLines() {

		for (WB_IsoGridCell cell : cells.values()) {
			for (int i = 0, j = 5; i < 6; j = i, i++) {
				if (cell.labels[i] != cell.labels[j]) {
					WB_IsoGridSegment segment = new WB_IsoGridSegment(cell.getQ(), cell.getR(), cell.getQ() + directions[i][0],
							cell.getR() + directions[i][1]);
					long key = getLineHash(segment.getType(), segment.getGroupValue());
					WB_IsoGridLine line = linesMap.get(key);
					if (line == null) {
						line = new WB_IsoGridLine(segment.getType(), segment.getGroupValue());
						linesMap.put(key, line);
					}
					line.add(segment);
				} else if (cell.labels[i] > -1) {
					if (Math.abs(cell.z[i] - cell.z[j]) > 1) {
						WB_IsoGridSegment segment = new WB_IsoGridSegment(cell.getQ(), cell.getR(), cell.getQ() + directions[i][0],
								cell.getR() + directions[i][1]);
						long key = getLineHash(segment.getType(), segment.getGroupValue());
						WB_IsoGridLine line = linesMap.get(key);
						if (line == null) {
							line = new WB_IsoGridLine(segment.getType(), segment.getGroupValue());
							linesMap.put(key, line);
						}
						line.add(segment);
					}
				}
			}

		}

	}


	private void vertex(PApplet home, final double px, double py) {
		home.vertex((float) px, (float) py);
	}

}
