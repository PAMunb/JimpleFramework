package samples.interfaces;

public class C implements I1, I2 {

	// implementing multiple interfaces
	@Override
	public void printI1() {
		System.out.println("Interface I1");
	}

	@Override
	public void printI2() {
		System.out.println("Interface I2");
	}
}
