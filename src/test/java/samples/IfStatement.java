package samples;

public class IfStatement {

	public static void foo(int x) {
		if (x > 0) {
			x = x + 1;
		}
		System.out.println(x);
	}

	public static void blah(int x, int y) {
		if (x < 0) {
			return;
		}
		System.out.println(x + y);
	}

	public static void ugly(int x, int y) {
		int z = 0;
		if (x < 0) {
			z = y > 10 ? x + y : x;
		}
		System.out.println(z);
	}

}
