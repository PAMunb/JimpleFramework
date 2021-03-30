package samples;

public class AdditionalLongValueSample {

	private double pi = 3.14;

	public long addLongValues(long factor) throws Exception {
		long x = 10L;
		long y = factor * 20L;

		String s0 = "" + (y * pi);

		System.out.println(s0);

		return x + y;
	}

}
