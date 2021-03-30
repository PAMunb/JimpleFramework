package samples;

interface MyInterfaceA {
	void display();
}

class NestedInterface implements MyInterfaceA {
	@Override
	public void display() {
		System.out.println("Nested interface method");
	}

	public static void main(String args[]) {
		MyInterfaceA obj = new NestedInterface();
		obj.display();
	}
}