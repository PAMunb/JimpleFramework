package test.java;

import java.io.IOException;

public interface InterfaceSample {
	public String foo() throws IOException;
	
	public default void bah() {
		System.out.println("abc");
	}
}
