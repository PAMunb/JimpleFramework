package samples.dataflow;

public class SimpleVeryBusyExpression {
	
	public void veryBusy(int a, int b, int x, int y) {
		
		if (a != b) {
			x = b - a;
			y = a - b;
		} else {
			y = b - a;
			a = 0;
			x = a - b;
		}
	}

}
