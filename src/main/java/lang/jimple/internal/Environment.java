package lang.jimple.internal;

import lang.jimple.internal.generated.Statement;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

public class Environment {
	Stack<Operand> operands;
	List<Statement> instructions;

	public Environment() {
		operands = new Stack<>();
		instructions = new ArrayList<>();
	}
}
