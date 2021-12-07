package samples.controlStatements;

public class StaticBlock {

    private static int x;

    static {
        x = 100;
    }

    public static int sum() {
        int y = 100;
        int z = x + y;
        return z;
    }
}
