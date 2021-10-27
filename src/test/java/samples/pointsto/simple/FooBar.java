package samples.pointsto.simple;

/**
 * Example from SPARK: A FLEXIBLE POINTS-TO ANALYSIS FRAMEWORK FOR JAVA
 * page 33
 *
 */
public class FooBar {

	public static void foo() {
		Node p = new Node();
		Node q = p;
		Node r = new Node();
		p.next = r;
		Node t = bar(q);
	}

	private static Node bar(Node s) {		
		return s.next;
	}
	
}
