package samples.controlStatements;

public class DoWhileStatement {
    public int execute() {
        int x = 0;
        int y = 0;
        do {
            y += x;
            x++;
        } while(x < 10);
        return y;
    }
}
