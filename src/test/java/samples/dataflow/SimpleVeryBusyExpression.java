package samples.dataflow;

public class SimpleVeryBusyExpression {

	public void veryBusy() {
		int a = 0;
		int b = 0;
		int x = 0;
		int y = 0;

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
