package samples.svfa.basic;

public class BasicDouble {

	public static void main(String args[]) {
		double s1 = source();
		double s2 = 51.001;
		double s3 = s1 + 0;
		double s4 = s2 + 0; // not context sensitive.

		sink(s3); /* BAD */
		sink(s1 + 1); /* BAD */
		sink(s4); /* OK */
	}

	public static double source() {
		return 0.007;
	}

	public static void sink(double s) {

	}

}
