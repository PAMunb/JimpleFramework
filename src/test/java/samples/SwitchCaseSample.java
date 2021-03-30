package samples;

public class SwitchCaseSample {

	public static void main(String args[]) {
		int x = 10;
		switch (random()) {
		case 1:
			x++;
		case 2:
			x--;
		default:
			System.out.print("do nothing");
		}

		System.out.println(x);
	}

	// not a trully random...
	private static int random() {
		return 1;
	}

}
