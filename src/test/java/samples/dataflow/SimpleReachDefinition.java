package samples.dataflow;

public class SimpleReachDefinition {

	public void factorial(int x) {
		int y = x;
		int z = 1;
		while (y > 1) {
			z = z * y;
			y = y - 1;
		}
		// System.out.println("Z="+z);
		y = 0;
	}

//	public static void main(String[] args) {
//		SimpleReachDefinition tmp = new SimpleReachDefinition();
//		tmp.factorial(6);
//	}

}