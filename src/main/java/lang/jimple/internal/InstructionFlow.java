package lang.jimple.internal;

import java.util.Collection;

import lang.jimple.internal.generated.Statement;

public interface InstructionFlow {
	
	public void push(Operand operand);
	public Operand pop();
	public void addInstruction(Statement stmt);
	public void clearOperandStack();
	public int sizeOfOperandStack();
	public Collection<Statement> merge();

}
