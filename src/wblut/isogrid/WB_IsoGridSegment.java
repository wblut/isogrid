package wblut.isogrid;

import java.util.Comparator;

public class WB_IsoGridSegment {
	private int type;  // 0=q, 1=r, 2=-q+r, 3=q+r, 4=q-2r, 5=-2q+r 
	private int lineValue;
	private int sortValue;
	private int q1,r1,q2,r2;
	
	protected WB_IsoGridSegment(int q1, int r1,int q2, int r2) {
		this.q1=q1;
		this.r1=r1;
		this.q2=q2;
		this.r2=r2;
		type=-1;
		if(q1==q2) {
			type=0;
			lineValue=q1;
			this.r1=Math.min(r1, r2);
			this.r2=Math.max(r1, r2);
			sortValue=this.r1;
			
		}else if(r1==r2) {
			type=1;
			lineValue=r1;
			this.q1=Math.min(q1, q2);
			this.q2=Math.max(q1, q2);
			sortValue=this.q1;
		}else if(-q1+r1==-q2+r2) {
			type=2;
			lineValue=-q1+r1;
			if(q1>q2) {
				this.q2=q1;
				this.q1=q2;
				this.r2=r1;
				this.r1=r2;
			}
			sortValue=this.q1;
		}else if(q1+r1==q2+r2) {
			type=3;
			lineValue=q1+r1;
			if(r1>r2) {
				this.r2=r1;
				this.r1=r2;
				this.q2=q1;
				this.q1=q2;
			}
			sortValue=this.r1;
		}else if(q1-2*r1==q2-2*r2) {
			type=4;
			lineValue=q1-2*r1;
			if(r1>r2) {
				this.r2=r1;
				this.r1=r2;
				this.q2=q1;
				this.q1=q2;
			}
			sortValue=this.r1;
		}else if(-2*q1+r1==-2*q2+r2) {
			type=5;
			lineValue=-2*q1+r1;
			if(q1>q2) {
				this.q2=q1;
				this.q1=q2;
				this.r2=r1;
				this.r1=r2;
			}
			sortValue=this.q1;
		}
		if(type==-1) throw new IllegalArgumentException("Invalid segment: "+q1+", "+r1+", "+q2+", "+r2+".");	
	}
	
	

	public int getType() {
		return type;
	}

	public int getLineValue() {
		return lineValue;
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
	
	protected long getHash() {
		long A = (type >= 0 ? 2 * (long) type : -2 * (long) type - 1);
		long B = (lineValue >= 0 ? 2 * (long) lineValue : -2 * (long)lineValue - 1);
		long C = ((A >= B ? A * A + A + B : A + B * B) / 2);
		return type < 0 && lineValue < 0 || type >= 0 && lineValue >= 0 ? C : -C - 1;
	}

	static class HexSegmentSort implements Comparator<WB_IsoGridSegment>{
		@Override
		public int compare(WB_IsoGridSegment arg0, WB_IsoGridSegment arg1) {
			return Double.compare(arg0.getSortValue(), arg1.getSortValue());
		}
	}
	
}
