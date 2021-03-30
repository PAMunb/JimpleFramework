package lang.jimple.internal;

import java.util.Collection;
import java.util.List;

import lang.jimple.internal.generated.Statement;

public interface InstructionFlow {
	Collection<Statement> merge();

	boolean matchMergePoint(String label);

	List<Environment> environments();

	void nextBranch();

	void notifyGotoStmt(Statement stmt, String label);

	boolean isBranch();

	boolean readyToMerge(String label);
}
