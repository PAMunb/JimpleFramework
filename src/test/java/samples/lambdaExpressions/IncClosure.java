package samples.lambdaExpressions;

interface Incrementable {
	int inc(int a);
}

public class IncClosure {
	public static void main(String[] args) {
		int i = 1;
		
		Incrementable incBy = (a) -> (a+i);
		
		System.out.println(incBy.inc(1));
	}
}
