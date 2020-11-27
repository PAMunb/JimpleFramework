package lang.jimple.internal;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Stack;

import lang.jimple.internal.generated.Statement;

public class SingleInstructionFlow implements InstructionFlow {
	
	Stack<Operand> operands;
	List<Statement> instructions; 

	public SingleInstructionFlow() {
		operands = new Stack<>();
		instructions = new ArrayList<>();
	}
	
	public void push(Operand operand) {
		operands.push(operand);
	}
	
	public Operand pop() {
		return operands.pop();
	}
	
	public void addInstruction(Statement stmt) {
		instructions.add(stmt);
	}
	
	public void clearOperandStack() {
		operands.clear();
	}

	@Override
	public int sizeOfOperandStack() {
		return operands.size();
	}

	@Override
	public Collection<Statement> merge() {
		return new ArrayList<>(instructions); 
	}

}
