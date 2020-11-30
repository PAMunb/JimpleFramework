module lang::jimple::toolkit::ssa::VariableRenaming

import Set;
import Relation;
import analysis::graphs::Graph;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;
import lang::jimple::toolkit::ssa::Util;
import Node;
import List;
import lang::jimple::util::Stack;
import Type;

public FlowGraph applyVariableRenaming(FlowGraph flowGraph, map[&T, set[&T]] dominanceTree) {
	variableList = { getStmtVariable(graphNode) | <graphNode, _> <- flowGraph, isVariable(graphNode) };
	map[Variable, Stack[Variable]] S = (); 
	map[Variable, list[int]] C = ();

	for(Variable variable <- variableList) {
		for(variableNode <- blocksWithVariable(flowGraph, variable)) {
			if(isOrdinaryAssignment(variableNode)) {
				
			};
		};
	};

	return flowGrap;
}

public bool isOrdinaryAssignment(variableNode) {
	stmtNode(assignStatement) = variableNode;
	temp = typeOf(assignStatement);
	return true;
}

public String renameVariable(Variable variable, int index) {
	
	return "";
}

// Duplicated code

public &T getStmtVariable(Node graphNode) {
	stmtNode(assignStatement) = graphNode;
	variableArg = assignStatement[0];

	return variableArg;
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