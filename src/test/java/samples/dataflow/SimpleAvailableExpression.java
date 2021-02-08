package samples.dataflow;

public class SimpleAvailableExpression {

	public void available(int a, int b) {
		int x = a - b;
		int y = a * b;
		if (y != (a - b)) {
			a = a - 1;
			x = a - b;
		}
	}

}
