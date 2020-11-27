package lang.jimple.internal;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import lang.jimple.internal.generated.Expression;
import lang.jimple.internal.generated.Statement;

public class BranchInstructionFlow implements InstructionFlow {

	private Expression condition; 
	private String target; 
	private InstructionFlow left;
	private InstructionFlow right; 
	private BranchState status; 
	
	enum BranchState {
		LEFT,
		RIGHT,
		ReadyToMerge;
	}
	
	public BranchInstructionFlow(Expression condition, String target) {
		this.condition = condition;
		this.target = target; 
		left = new SingleInstructionFlow();
		right = new SingleInstructionFlow();
		status = BranchState.LEFT;
	}
	
	public void push(Operand operand) {
		switch(status) {
		 case LEFT: left.push(operand); break;
		 case RIGHT: right.push(operand); break;
		 case ReadyToMerge: left.push(operand); right.push(operand);
		}
	}
	
	public Operand pop() {
		switch(status) {
		 case LEFT: return left.pop();
		 case RIGHT: return right.pop();
		 case ReadyToMerge: return null;
		}
		return null;
	}
	
	public void addInstruction(Statement stmt) {
		switch(status) {
		 case LEFT: left.addInstruction(stmt); break;
		 case RIGHT: right.addInstruction(stmt); break;
		 case ReadyToMerge: left.addInstruction(stmt); right.addInstruction(stmt);
		}
	}
	
	public void clearOperandStack() {
		left.clearOperandStack();
		right.clearOperandStack();
	}

	@Override
	public int sizeOfOperandStack() {
		switch(status) {
		 case LEFT: return left.sizeOfOperandStack();
		 case RIGHT: return right.sizeOfOperandStack();
		 case ReadyToMerge: return left.sizeOfOperandStack() + right.sizeOfOperandStack();
		}
		return 0; 
	}

	@Override
	public Collection<Statement> merge() {
		List<Statement> res = new ArrayList<>();
		
		res.add(Statement.ifStmt(condition, target));
		res.addAll(left.merge());
		res.addAll(right.merge());
		
		return res; 
	}

}
