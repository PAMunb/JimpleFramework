package samples.pointsto.simple;

/**
 * Example from SPARK: A FLEXIBLE POINTS-TO ANALYSIS FRAMEWORK FOR JAVA
 * page 33
 *
 */
public class FooBar {

	public void foo() {
		Node p = new Node();
		Node q = p;
		Node r = new Node();
		p.next = r;
		Node t = bar(q);
	}

	private Node bar(Node s) {		
		return s.next;
	}
	
}

/* JIMPLE (SOOT)
public class FooBar extends java.lang.Object
{

    public void <init>()
    {
        FooBar r0;

        r0 := @this: FooBar;

        specialinvoke r0.<java.lang.Object: void <init>()>();

        return;
    }

    public void foo()
    {
        Node $r0, $r3;
        FooBar r5;

        r5 := @this: FooBar;

        $r0 = new Node;

        specialinvoke $r0.<Node: void <init>()>();

        $r3 = new Node;

        specialinvoke $r3.<Node: void <init>()>();

        $r0.<Node: Node next> = $r3;

        specialinvoke r5.<FooBar: Node bar(Node)>($r0);

        return;
    }

    private Node bar(Node)
    {
        Node r0, $r1;
        FooBar r2;

        r2 := @this: FooBar;

        r0 := @parameter0: Node;

        $r1 = r0.<Node: Node next>;

        return $r1;
    }
}


public class Node extends java.lang.Object
{
    public int value;
    public Node next;

    public void <init>()
    {
        Node r0;

        r0 := @this: Node;

        specialinvoke r0.<java.lang.Object: void <init>()>();

        return;
    }
}
*/