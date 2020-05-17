package samples;

public class WhileStmtSample {
	
	public static int factorial(int x) {
		int res = x; 
		while(x > 1) {
			res = res * (--x);
		}
		return res;
	}
	
}
