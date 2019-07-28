package wblut.isogrid;

import java.util.Comparator;

public class WB_IsoGridCell {
	private int q, r; 
	protected int[] z;
	protected int[] labels;
	protected int[] colorIndices;
	protected int[] cubei;
	protected int[] cubej;
	protected int[] cubek;
	
	protected WB_IsoGridCell(int q, int r) {
		this.q = q;
		this.r = r;
		labels = new int[36];
		colorIndices = new int[36];
		z = new int[36];
		cubei = new int[36];
		cubej = new int[36];
		cubek = new int[36];
		for (int f = 0; f < 36; f++) {
			labels[f] = -1;
			colorIndices[f] = 0;
			z[f] = -Integer.MAX_VALUE;
			cubei[f]=-Integer.MAX_VALUE;
			cubej[f]=-Integer.MAX_VALUE;
			cubek[f]=-Integer.MAX_VALUE;
		}
		
	

	}

	public int getLabel(int f) {
		return labels[f];
	}

	public int getColorIndex(int f) {
		return colorIndices[f];
	}

	public int getZ(int f) {
		return z[f];
	}
	
	
	public int[] getCube(int f) {
		if(cubei[f]==-Integer.MAX_VALUE) return null;
		return new int[] {cubei[f],cubej[f],cubek[f]};
		
	}

	public int getQ() {
		return q;
	}

	public int getR() {
		return r;
	}
	
	public boolean isEmpty() {
		for (int f = 0; f < 36; f++) {
			if (labels[f] > -1)
				return false;
		}
		return true;

	}

	static protected class HexCellSort implements Comparator<WB_IsoGridCell> {
		@Override
		public int compare(WB_IsoGridCell arg0, WB_IsoGridCell arg1) {
			if (arg0.q < arg1.q) {
				return -1;
			} else if (arg0.q > arg1.q) {
				return 1;
			} else if (arg0.r < arg1.r) {
				return -1;
			} else if (arg0.r > arg1.r) {
				return 1;
			}
			return 0;
		}
	}

}
