package samples;

public class NewStatementSample {

	public static void main(String args[]) {
		NewStatementSample instance = new NewStatementSample();

		System.out.println(instance.sum(3, 4));
	}

	public int sum(int x, int y) {
		return x + y;
	}

}
