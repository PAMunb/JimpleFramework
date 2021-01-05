module lang::jimple::toolkit::ssa::VariableRenaming

import Set;
import Relation;
import analysis::graphs::Graph;
import Node;
import List;
import Type;
import lang::jimple::util::Stack;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;

public FlowGraph applyVariableRenaming(FlowGraph flowGraph, map[&T, set[&T]] dominanceTree) {
	FlowGraph newFlowGraph = { graphNode | graphNode <- flowGraph };
	variableList = { getStmtVariable(graphNode) | <graphNode, _> <- flowGraph, isVariable(graphNode) };
	map[Variable, Stack[int]] S = (); 
	map[Variable, int] C = ();

	for(Variable variable <- variableList) {
		for(<variableNode, childNode> <- blocksWithVariable(flowGraph, variable)) {
			if(isOrdinaryAssignment(variableNode)) {
				if(isRightHandSideVariable(variableNode)) {
					// rhsVariable =  getRightHandSideVariable(variableNode)
					// replaceVariableVersion(newFlowGraph, peek(S[rhsVariable]));
				};
				
				if(isLeftHandSideVariable(variableNode)) {
					Variable V = getStmtVariable(variableNode);
					int i = V in C ? C[V] : 0;
					// Replace V by Vi as LHS(A)
					replaceVariableVersion(newFlowGraph, variableNode, childNode);
					S[V] = V in S ? push(S[V], i) : push(i, emptyStack());
					C[V] = i + 1;
				};
			};
		};
	};

	return flowGraph;
}

public FlowGraph replaceVariableVersion(FlowGraph flowGraph, Node variableNode, Node childNode) {
	filteredFlowGraph = { <origin, destination> | <origin, destination> <- flowGraph, (origin != variableNode) && (destination != childNode) };
	Variable V = getStmtVariable(variableNode);
	
	// Replace use of V by use of Vi where i = Top(S(V))
	return newFlowGraph;
}

public bool isLeftHandSideVariable(Node variableNode) {
	stmtNode(assignStatement) = variableNode;
	assign(leftHandSide, _) = assignStatement;
	typeOfVariableArg = typeOf(leftHandSide);

	return size(typeOfVariableArg[..]) != 0 && typeOfVariableArg.name == "Variable";
}

public bool isRightHandSideVariable(Node variableNode) {
	stmtNode(assignStatement) = variableNode;
	assign(_, rightHandSide) = assignStatement;
	typeOfVariableArg = typeOf(rightHandSide);

	return size(typeOfVariableArg[..]) != 0 && typeOfVariableArg.name == "Variable";
}

public bool isOrdinaryAssignment(variableNode) {
	stmtNode(assignStatement) = variableNode;
	
	switch(assignStatement) {
		case assign(_, _): return true; 
		default: return false;
	}
}

public String renameVariable(Variable variable, int index) {
	
	return "";
}

// Duplicated code

public Variable getStmtVariable(Node graphNode) {
	stmtNode(assignStatement) = graphNode;
	temp = typeOf(assignStatement);
	variableArg = assignStatement[0];
	temp2 = typeOf(variableArg);
	
	switch(variableArg) {
		case Variable variable: return variable;
	}
}

public lrel[Node, Node] blocksWithVariable(FlowGraph flowGraph, Variable variable) {
	return [<fatherNode, childStmt> | <fatherNode, childStmt> <- flowGraph, isSameVariable(fatherNode, variable)];;
}

public bool isVariable(Node graphNode) {
	if (size(graphNode[..]) == 0) return false;
	
	stmtNode(assignStatement) = graphNode;
	variableArg = assignStatement[0];
	typeOfVariableArg = typeOf(variableArg);
	
	if (size(typeOfVariableArg[..]) == 0) return false;
	
	return typeOfVariableArg.name == "Variable";
}

public bool isSameVariable(Node graphNode, Variable variable) {
	if (size(graphNode[..]) == 0) return false;
	
	stmtNode(assignStatement) = graphNode;
	variableArg = assignStatement[0];
	typeOfVariableArg = typeOf(variableArg);
	
	if (size(typeOfVariableArg[..]) == 0) return false;
	
	return variableArg == variable;
}