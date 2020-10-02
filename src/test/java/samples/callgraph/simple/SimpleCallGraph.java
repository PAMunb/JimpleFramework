package samples.callgraph.simple;

import java.util.Arrays;
import java.util.List;

public class SimpleCallGraph {

	public void execute() {
		A();
	}

	void A() {
		B();
		C();
	}

	protected void B() {
		D();
		E();
	}

	protected void C() {
		E();
		F();
	}

	private void D() {	
//		List<String> list = Arrays.asList("a","b","c","d");
//		for(int i=0; i < list.size(); i++) {
//			log("Executing D: "+list.get(i));
//			//System.out.println("aa");
//		}
		log("Executing D");
	}

	private synchronized void E() {
		G();
	}

	private void F() {
		G();
	}

	private void G() {
		log("Executing G");
	}
	
	static void log(String message) {
		System.out.println(message);
	}

}
