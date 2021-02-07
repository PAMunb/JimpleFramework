package lang.jimple.internal;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import lang.jimple.internal.generated.Expression;
import lang.jimple.internal.generated.Statement;

public class BranchInstructionFlow implements InstructionFlow {

	private Environment left;
	private Environment right;

	private Expression condition;

	private String targetStatement;
	private String mergeStatement;

	private BranchState status;
	
	enum BranchState {
		LEFT,
		RIGHT,
		ReadyToMerge
	}
	
	public BranchInstructionFlow(Expression condition, String target) {
		this.condition = condition;
		this.targetStatement = target;
		left = new Environment();
		right = new Environment();
		status = BranchState.LEFT;
	}


	@Override
	public Collection<Statement> merge() {
		List<Statement> res = new ArrayList<>();
		
		res.add(Statement.ifStmt(condition, targetStatement));
		res.addAll(left.instructions);
		res.addAll(right.instructions);
		
		return res; 
	}

	@Override
	public boolean matchMergePoint(String label) {
		if(status.equals(BranchState.LEFT)) {
			return this.targetStatement.equals(label);
		}
		else if(status.equals(BranchState.RIGHT)) {
			return this.mergeStatement.equals(label);
		}
		return false;
	}

	@Override
	public List<Environment> environments() {
		List<Environment> res = new ArrayList<>();
		switch(status) {
			case LEFT: res.add(left); break;
			case RIGHT: res.add(right); break;
			case ReadyToMerge: res.add(left); res.add(right);
		}
		return res;
	}

	@Override
	public void notifyGotoStmt(String label) {
		if(status.equals(BranchState.LEFT)) {
			mergeStatement = label;
		}
	}

	@Override
	public void nextBranch() {
		switch(status) {
		 case LEFT: status = BranchState.RIGHT; break;
		 case RIGHT: status = BranchState.ReadyToMerge; break;
		 case ReadyToMerge: //
		}
	}
	
	@Override
	public boolean isBranch() {
		return true;
	}

	@Override
	public boolean readyToMerge(String label) {
		this.targetStatement = label;
		return status.equals(BranchState.ReadyToMerge);
	}
}