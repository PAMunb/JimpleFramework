package samples.controlStatements;

public class WhileStatement {
    public int execute() {
        int x = 0;
        int y = 0;
        while(x < 10) {
            y += x;
            x++;
        }
        return y;
    }
}
