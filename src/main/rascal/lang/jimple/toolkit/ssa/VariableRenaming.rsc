module lang::jimple::toolkit::ssa::VariableRenaming

import Set;
import Relation;
import analysis::graphs::Graph;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;
import lang::jimple::toolkit::ssa::Util;
import Node;
import List;
import Type;
import lang::jimple::util::Stack;

public FlowGraph applyVariableRenaming(FlowGraph flowGraph, map[&T, set[&T]] dominanceTree) {
	newFlowGraph = { <origin, destination> | <origin, destination> <- flowGraph };
	variableList = { getStmtVariable(graphNode) | <graphNode, _> <- flowGraph, isVariable(graphNode) };
	map[Variable, Stack[int]] S = (); 
	map[Variable, int] C = ();

	for(Variable variable <- variableList) {
		for(variableNode <- blocksWithVariable(flowGraph, variable)) {
			if(isOrdinaryAssignment(variableNode)) {
				if(isRightHandSideVariable(variableNode)) {
					// rhsVariable =  getRightHandSideVariable(variableNode)
					// replaceVariableVersion(newFlowGraph, peek(S[rhsVariable]));
				};
				
				if(isLeftHandSideVariable(variableNode)) {
					Variable V = getStmtVariable(variableNode);
					int i = V in C ? C[V] : 0;
					// Replace C by Ci as LHS(A)
					S[V] = V in S ? push(S[V], i) : push(i, emptyStack());
					C[V] = i + 1;
				};
			};
		};
	};

	return flowGraph;
}

public FlowGraph replaceVariableVersion(FlowGraph newFlowGraph, Variable version) {
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

public list[Node] blocksWithVariable(FlowGraph flowGraph, Variable variable) {
	return [graphNode | <graphNode, _> <- flowGraph, isSameVariable(graphNode, variable)];;
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