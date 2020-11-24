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

public FlowGraph applyVariableRenaming(FlowGraph flowGraph, map[&T, set[&T]] dominanceTree) {
	variableList = { getStmtVariable(graphNode) | <graphNode, _> <- flowGraph, isVariable(graphNode) };
	map(Variable, Stack) S = (); 
	map(Variable, list[int]) C = ();

	for(Variable variable <- variableList) {
	
	};

	return flowGrap;
}