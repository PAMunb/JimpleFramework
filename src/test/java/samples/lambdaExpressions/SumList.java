package samples.lambdaExpressions;

import java.util.Arrays;
import java.util.List;

public class SumList {
	public static void main(String[] args) throws Exception {

		List<Integer> nums = Arrays.asList(1, 2, 3, 4);

		System.out.println(nums.stream().mapToInt(n -> n.intValue()).sum());
	}
}