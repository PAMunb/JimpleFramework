package samples.svfa;

class A {
    B field;
}

class B {
    int x;

    B(int x) { this.x = x; }
}

public class IfElseScenario {

    private static B source() {
        return new B(20);
    }

    private static void sink(B b) {

    }
    public static void main(String args[]) {
        A a = new A();

        if(args.length > 6) {
            a.field = source();
        }
        else {
            a.field = new B(20);
        }

        sink(a.field);
    }
}
