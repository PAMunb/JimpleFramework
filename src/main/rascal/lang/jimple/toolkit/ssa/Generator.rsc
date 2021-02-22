module lang::jimple::toolkit::ssa::Generator

import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;

import lang::jimple::toolkit::ssa::DominanceTree;
import lang::jimple::toolkit::ssa::PhiFunctionInsertion;
import lang::jimple::toolkit::ssa::DominanceFrontier;
import lang::jimple::toolkit::ssa::VariableRenaming;

public FlowGraph applySSATransformation(MethodBody methodBody) {
	FlowGraph flowGraph = forwardFlowGraph(methodBody);
	map[&T, set[&T]] dominanceTree = createDominanceTree(flowGraph);
	map[&T, set[&T]] dominanceFrontier = createDominanceFrontier(flowGraph, dominanceTree);
	FlowGraph phiFunctionFlowGraph = insertPhiFunctions(flowGraph, dominanceFrontier);
	result = applyVariableRenaming(phiFunctionFlowGraph);
	
	return result;
}