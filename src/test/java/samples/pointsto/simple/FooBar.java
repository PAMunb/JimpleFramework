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

/* JIMPLE
public class samples.pointsto.simple.FooBar extends java.lang.Object 
{
 
    public void <init>() 
    {
        samples.pointsto.simple.FooBar r0;
     
     
        r0 := @this: samples.pointsto.simple.FooBar;
     
        specialinvoke r0.<java.lang.Object: void <init>()>();
     
        return; 
    }
    
    public static void foo() 
    {
        samples.pointsto.simple.Node p;
        samples.pointsto.simple.Node q;
        samples.pointsto.simple.Node t;
        samples.pointsto.simple.Node r;
        samples.pointsto.simple.Node $r1;
        samples.pointsto.simple.Node $r2;
        samples.pointsto.simple.Node $r3;
     
     
        $r1 = new samples.pointsto.simple.Node;
     
        specialinvoke $r1.<samples.pointsto.simple.Node: void <init>()>();
     
        p = $r1;
     
        q = p;
     
        $r2 = new samples.pointsto.simple.Node;
     
        specialinvoke $r2.<samples.pointsto.simple.Node: void <init>()>();
     
        r = $r2;
     
        p.<samples.pointsto.simple.Node: samples.pointsto.simple.Node next> = r;
     
        $r3 = staticinvoke <samples.pointsto.simple.FooBar: samples.pointsto.simple.Node bar(samples.pointsto.simple.Node)>(q);
     
        t = $r3;
     
        return; 
    }
    
    private static samples.pointsto.simple.Node bar(samples.pointsto.simple.Node) 
    {
        samples.pointsto.simple.Node s;
        samples.pointsto.simple.Node $r1;
     
     
        i1 := @parameter0: samples.pointsto.simple.Node;
     
        $r1 = s.<samples.pointsto.simple.Node: samples.pointsto.simple.Node next>;
     
        return $r1; 
    }
    
}
public class samples.pointsto.simple.Node extends java.lang.Object 
{

    public int value;
    public samples.pointsto.simple.Node next;
         
    public void <init>() 
    {
        samples.pointsto.simple.Node r0;
     
     
        r0 := @this: samples.pointsto.simple.Node;
     
        specialinvoke r0.<java.lang.Object: void <init>()>();
     
        return; 
    }
    
}
abstract interface samples.pointsto.simple.package-info extends 
{ 
 
}
*/