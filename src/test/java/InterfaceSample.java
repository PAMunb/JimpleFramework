package test.java;

public interface InterfaceSample {
	public String foo();
	public default void bah() {
		System.out.println("abc");
	}
}
