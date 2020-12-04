package samples.svfa;

public class ArraySample {

	public static void main(String args[]) {
		int x[] = new int[3];

		x[0] = 1;
		x[1] = source();
		x[2] = 2;

		sink(x[0]);
		sink(x[1]);
		sink(x[2]);
	}

	private static int source() {
		return 1;
	}

	private static void sink(int v) {
		System.out.println(v);
	}
}
