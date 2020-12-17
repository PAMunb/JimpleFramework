package samples.dataflow;

public class SimpleLiveVariable {

	public void live() {
		int z = 0;
		int y = 4;
		int x = 2;

		if (x != y) {
			z = y;
		} else {
			z = y * y;
		}

		x = z;
	}

}
