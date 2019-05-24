package wblut.isogrid;

import java.util.Comparator;

public class WB_IsoGridSegment {
	private int type; //0=q, 1=r, 2=-q+r
	private int groupValue;
	private int sortValue;
	private int q1,r1,q2,r2;
	
	public WB_IsoGridSegment(int q1, int r1, int q2, int r2) {
		this.q1=q1;
		this.r1=r1;
		this.q2=q2;
		this.r2=r2;
		type=-1;
		if(q1==q2) {
			type=0;
			groupValue=q1;
			this.r1=Math.min(r1, r2);
			this.r2=Math.max(r1, r2);
			sortValue=this.r1;
			
		}else if(r1==r2) {
			type=1;
			groupValue=r1;
			this.q1=Math.min(q1, q2);
			this.q2=Math.max(q1, q2);
			sortValue=this.q1;
		}else if(-q1+r1==-q2+r2) {
			type=2;
			groupValue=-q1+r1;
			if(q1>q2) {
				this.q2=q1;
				this.q1=q2;
				this.r2=r1;
				this.r1=r2;
			}
			sortValue=this.q1;
		}
		if(type==-1) throw new IllegalArgumentException("Invalid segment.");	
	}
	

	public int getType() {
		return type;
	}

	public int getGroupValue() {
		return groupValue;
	}

	public int getSortValue() {
		return sortValue;
	}

	public int getQ1() {
		return q1;
	}

	public int getR1() {
		return r1;
	}

	public int getQ2() {
		return q2;
	}

	public int getR2() {
		return r2;
	}
	
	public void setQ1(int q1) {
		this.q1 = q1;
	}


	public void setR1(int r1) {
		this.r1 = r1;
	}


	public void setQ2(int q2) {
		this.q2 = q2;
	}


	public void setR2(int r2) {
		this.r2 = r2;
	}

	static class HexSegmentSort implements Comparator<WB_IsoGridSegment>{
		@Override
		public int compare(WB_IsoGridSegment arg0, WB_IsoGridSegment arg1) {
			return Integer.compare(arg0.getSortValue(), arg1.getSortValue());
		}
	}
	
}
