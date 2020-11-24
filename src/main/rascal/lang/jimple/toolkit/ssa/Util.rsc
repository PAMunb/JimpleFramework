module lang::jimple::toolkit::ssa::Util

public &T getStmtVariable(Node graphNode) {
	stmtNode(assignStatement) = graphNode;
	variableArg = assignStatement[0];

	return variableArg;
}