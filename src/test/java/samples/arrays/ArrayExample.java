package samples.arrays;

import java.util.Arrays;
import java.util.List;

public class ArrayExample {

	public static void main(String[] args) throws Exception {
		List<Integer> nums = Arrays.asList(-3, 0, 1, 8);

		Runnable r = () -> nums.forEach(n -> {

			if (n < 0)
				System.out.println("Negative: " + n);

			else
				System.out.println("Positive: " + n);

		});

		Thread t = new Thread(r);

		t.start();

		t.join();

	}

}
