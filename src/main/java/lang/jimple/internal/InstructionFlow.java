package lang.jimple.internal;

import java.util.Collection;
import java.util.List;

import lang.jimple.internal.generated.Statement;

public abstract class InstructionFlow {

	Decompiler decompiler;

	public InstructionFlow(Decompiler decompiler) {
		this.decompiler = decompiler;
	}

	public abstract Collection<Statement> merge();
	public abstract boolean matchMergePoint(String label);
	public abstract List<Environment> environments();
	public abstract void nextBranch();
	public abstract void notifyGotoStmt(Statement stmt, String label);
	public abstract boolean isBranch();
	public abstract boolean readyToMerge(String label);
	public abstract boolean immediateMerge();

	public int getCurrentLineNumber() {
		return decompiler.getCurrentLineNumber();
	}
}
