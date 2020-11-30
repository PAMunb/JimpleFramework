package samples.pointsto.ex2;

class O {
	public O f;
}

public class FooBar {

	public static void main(String[] args) {
		O p = new O();
		O q = p;
		O r = new O();
		p.f = r;
		O t = bar(q);
	}

	static O bar(O s) {
		return s.f;
	}

}
