package lang.jimple.internal;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import lang.jimple.internal.generated.Expression;
import lang.jimple.internal.generated.Statement;
import lang.jimple.internal.generated.StmtContext;

public class BranchInstructionFlow extends InstructionFlow {

	private Environment left;
	private Environment right;

	private Expression condition;

	private String targetStatement;
	private String mergeStatement;

	private BranchState status;

	private Statement gotoMergeStmt;

	private boolean immediateMerge = false;

	private int stmtId;
	private String methodSignature;
	private int branchLineNumber;
	private int targetLineNumber;
	private int mergeLineNumber;

	enum BranchState {
		LEFT,
		RIGHT,
		ReadyToMerge
	}
	
	public BranchInstructionFlow(Decompiler decompiler, Expression condition, String target, int stmtId, String methodSignature) {
		super(decompiler);
		this.condition = condition;
		this.targetStatement = target;
		this.methodSignature = methodSignature;
		this.branchLineNumber = decompiler.getCurrentLineNumber();
		left = new Environment();
		right = new Environment();
		status = BranchState.LEFT;
	}


	@Override
	public Collection<Statement> merge() {
		List<Statement> res = new ArrayList<>();
		
		res.add(Statement.ifStmt(condition, targetStatement, StmtContext.stmtContext(decompiler.computeStmtId(), methodSignature, branchLineNumber)));
		res.addAll(left.instructions);

		if(gotoMergeStmt != null) {
			res.add(gotoMergeStmt);
		}

		res.add(Statement.label(targetStatement, StmtContext.stmtContext(decompiler.computeStmtId(), methodSignature, targetLineNumber)));
		res.addAll(right.instructions);

		if(mergeStatement != null) {
			res.add(Statement.label(mergeStatement, StmtContext.stmtContext(decompiler.computeStmtId(), methodSignature, mergeLineNumber)));
		}
		
		return res; 
	}

	@Override
	public boolean matchMergePoint(String label) {
		if(status.equals(BranchState.LEFT)) {
			targetLineNumber = decompiler.getCurrentLineNumber();
			return this.targetStatement.equals(label);
		}
		else if(status.equals(BranchState.RIGHT)) {
			mergeLineNumber = decompiler.getCurrentLineNumber();
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
			case ReadyToMerge:
				if(mergeStatement != null) {
					res.add(left);
					res.add(right);
				}
				else {
					res.add(left);
				}
		}
		return res;
	}

	@Override
	public void notifyGotoStmt(Statement stmt, String label) {
		if(status.equals(BranchState.LEFT)) {
			mergeStatement = label;
			gotoMergeStmt = stmt;
		}
		else if(status.equals(BranchState.RIGHT)) {
			right.instructions.add(stmt);
		}
		else if(status.equals(BranchState.ReadyToMerge)) {
			left.instructions.add(stmt);
			right.instructions.add(stmt);
		}
	}

	@Override
	public void nextBranch() {
		switch(status) {
		 case LEFT:
		    if(mergeStatement != null) {
				status = BranchState.RIGHT;
			}
		    else {
		    	status = BranchState.ReadyToMerge;
		    	immediateMerge = true;
			}
		    break;
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
		return status.equals(BranchState.ReadyToMerge);
	}

	@Override
	public boolean immediateMerge() {
		return immediateMerge;
	}
}