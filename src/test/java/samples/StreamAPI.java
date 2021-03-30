package samples;

import java.util.Arrays;
import java.util.List;

public class StreamAPI {

	public static void main(String args[]) {
		List<Integer> values = Arrays.asList(1, 2, 3, 4, 5);

		int z = 10;

		Integer total1 = values.stream().reduce(0, (a, b) -> a + b + z);

		System.out.println(total1);
	}

}
