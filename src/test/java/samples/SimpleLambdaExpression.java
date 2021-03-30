package samples;

import java.util.Comparator;

public class SimpleLambdaExpression {

	public static void main(String args[]) {
		Comparator<String> c = (String l, String r) -> l.compareTo(r);

		System.out.println(c.compare("hello", "world"));
	}

}
