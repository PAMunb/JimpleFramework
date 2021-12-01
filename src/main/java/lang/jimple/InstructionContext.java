package lang.jimple;

public class InstructionContext {

    private int stmtId;
    private int lineNumber;

    private static InstructionContext instance;

    public static InstructionContext instance() {
        if(instance == null) {
            instance = new InstructionContext();
        }
        return instance;
    }

    private InstructionContext() {
        stmtId = 0;
        lineNumber = -1;
    }

    public void reset() {
        stmtId = 0;
        lineNumber = -1;
    }

    public int generateStmtId() {
        return ++stmtId;
    }

    public void setLineNumber(int lineNumber) {
        this.lineNumber = lineNumber;
    }

    public int getLineNumber() {
        return lineNumber;
    }
}
