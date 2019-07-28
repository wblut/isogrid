package wblut.isogrid;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class WB_IsoGridLine {
	private int type; // 0=q, 1=r, 2=-q+r, 3=q+r, 4=q-2r, 5=-2q+r 
	private int lineValue;
	private List<WB_IsoGridSegment> segments;
	
	protected WB_IsoGridLine(int type, int value) {
		this.type = type;
		this.lineValue = value;
		segments = new ArrayList<WB_IsoGridSegment>();
	}
	
	protected void add(WB_IsoGridSegment segment) {
		if(segment.getType()==type && segment.getLineValue()==lineValue) {
			segments.add(segment);
		}else {
			throw new IllegalArgumentException("Segment is type "+segment.getType()+" with value "+segment.getLineValue()+", and cannot be added to line of type "+type+" with value "+lineValue+".");
		}
	}
	

	
	protected void sort() {
		segments.sort(new WB_IsoGridSegment.HexSegmentSort());
	}
	
	protected void optimize() {
		 List<WB_IsoGridSegment> newSegments=new ArrayList<WB_IsoGridSegment>();
		 WB_IsoGridSegment segi,segj;
		 for(int i=0;i<segments.size();) {
			 segi=segments.get(i);
			 int j=0;
			 for(j=i+1;j<segments.size();j++) {
				 segj=segments.get(j);
				 if(segj.getQ1()==segi.getQ2() && segj.getR1()==segi.getR2()) {
					 segi.setQ2(segj.getQ2());
					 segi.setR2(segj.getR2()); 
				 }else {
					 break;
				 }
			 }
			 i=j;
			 newSegments.add(segi);
		 }
		 segments=newSegments;	 	 
	}

	public int getType() {
		return type;
	}

	public int getLineValue() {
		return lineValue;
	}

	public List<WB_IsoGridSegment> getSegments() {
		return segments;
	}
	
	public void reverse() {
		Collections.reverse(segments);
		for(WB_IsoGridSegment segment:segments) {
			int tmp=segment.getQ2();
			segment.setQ2(segment.getQ1());
			segment.setQ1(tmp);
			tmp=segment.getR2();
			segment.setR2(segment.getR1());
			segment.setR1(tmp);
		}
		
	}
	
	protected long getHash() {
		long A = (type >= 0 ? 2 * (long) type : -2 * (long) type - 1);
		long B = (lineValue >= 0 ? 2 * (long) lineValue : -2 * (long)lineValue - 1);
		long C = ((A >= B ? A * A + A + B : A + B * B) / 2);
		return type < 0 && lineValue < 0 || type >= 0 && lineValue >= 0 ? C : -C - 1;
	}
	

	
	static protected class HexLineSort implements Comparator<WB_IsoGridLine>{
		@Override
		public int compare(WB_IsoGridLine arg0, WB_IsoGridLine arg1) {
			if(arg0.type<arg1.type) {
				return -1;
			} else if(arg0.type>arg1.type) {
				return 1;
			}else if(arg0.lineValue<arg1.lineValue) {
				return -1;
			}else if(arg0.lineValue>arg1.lineValue) {
				return 1;
			}
			return 0;
		}
	}
	


}
