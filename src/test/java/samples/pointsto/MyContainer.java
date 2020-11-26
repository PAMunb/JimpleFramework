package samples.pointsto;

public class MyContainer {
	public void go() {
		Container c1 = new Container();
		Item i1 = new Item();
		c1.setItem(i1);
		Container c2 = new Container();
		Item i2 = new Item();
		c2.setItem(i2);
		Container c3 = c2;
	}
}
