package wblut.isogrid;

import java.util.Comparator;

public class WB_IsoGridCell {
	private int q, r; // center of the grid hex;

	int[] z;
	int[] labels;
    int[] colorIndices;
	public WB_IsoGridCell(int q, int r) {
		this.q = q;
		this.r = r;
		labels = new int[] { -1, -1, -1, -1, -1, -1 };
		colorIndices = new int[] {0,0,0,0,0,0 };
		
		z = new int[] { -Integer.MAX_VALUE, -Integer.MAX_VALUE, -Integer.MAX_VALUE, -Integer.MAX_VALUE,
				-Integer.MAX_VALUE, -Integer.MAX_VALUE };
		
	}
	public int getLabel(int i) {
		return labels[i];
	}
	public int getColorIndex(int i) {
		return colorIndices[i];
	}
	public int getZ(int i) {
		return z[i];
	}
	
	public int getQ() {
		return q;
	}
	
	public int getR() {
		return r;
	}
	
	public boolean isEmpty() {
		for(int i=0;i<6;i++) {
			if(labels[i]>-1) return false;
		}
		return true;
		
	}
	
	static class HexCellSort implements Comparator<WB_IsoGridCell>{
		@Override
		public int compare(WB_IsoGridCell arg0, WB_IsoGridCell arg1) {
			if(arg0.q<arg1.q) {
				return -1;
			} else if(arg0.q>arg1.q) {
				return 1;
			}else if(arg0.r<arg1.r) {
				return -1;
			}else if(arg0.r>arg1.r) {
				return 1;
			}
			return 0;
		}
	}
	

}
