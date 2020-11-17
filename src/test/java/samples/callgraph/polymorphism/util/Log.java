package samples.callgraph.polymorphism.util;

public interface Log {

	default void log(String msg) {
		System.out.println(msg);
	}	
	
}
