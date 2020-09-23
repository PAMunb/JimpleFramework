package samples.callgraph.simple;

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
