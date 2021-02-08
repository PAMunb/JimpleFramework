package lang.jimple.internal;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Stack;

import lang.jimple.internal.generated.Statement;

public class SingleInstructionFlow implements InstructionFlow {
	
	Environment environment;

	public SingleInstructionFlow() {
		environment = new Environment();
	}

	@Override
	public List<Environment> environments() {
		List<Environment> res = new ArrayList<>();
		res.add(environment);
		return res;
	}

	@Override
	public void nextBranch() { }

	@Override
	public void notifyGotoStmt(Statement stmt, String label) {
		environment.instructions.add(stmt);
	}

	@Override
	public boolean isBranch() {
		return false;
	}

	@Override
	public boolean readyToMerge(String label) {
		return true;
	}

	@Override
	public Collection<Statement> merge() {
		return new ArrayList<>(environment.instructions);
	}

	@Override
	public boolean matchMergePoint(String label) {
		return true;
	}

}
