module ssa::TestSSAIntegration

import List;
import Type;

import analysis::graphs::Graph;

import lang::jimple::decompiler::Decompiler;
import lang::jimple::core::Context;

import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;

import lang::jimple::toolkit::ssa::DominanceTree;
import lang::jimple::toolkit::ssa::PhiFunctionInsertion;
import lang::jimple::toolkit::ssa::DominanceFrontier;
import lang::jimple::toolkit::ssa::VariableRenaming;

test bool testSimpleExceptionDeclaration() {
	loc simpleExceptionPath = |project://JimpleFramework/target/test-classes/samples/ssa/SimpleException.class|;
	ClassOrInterfaceDeclaration simpleExceptionDeclaration = decompile(simpleExceptionPath);
	list[Method] methodList = castMethodList(simpleExceptionDeclaration);
	
	MethodBody methodBody = castMethodBody(methodList[0]);
	FlowGraph flowGraph = forwardFlowGraph(methodBody);
	map[&T, set[&T]] dominanceTree = createDominanceTree(flowGraph);
	map[&T, set[&T]] dominanceFrontier = createDominanceFrontier(flowGraph, dominanceTree);
	FlowGraph phiFunctionFlowGraph = insertPhiFunctions(flowGraph, dominanceFrontier);
	map[Node, list[Node]] blockTree = createFlowGraphBlockTree(phiFunctionFlowGraph);
	result = applyVariableRenaming(phiFunctionFlowGraph, blockTree);

	return result == flowGraph;
}

private list[Method] castMethodList(ClassOrInterfaceDeclaration declaration) {
	switch(declaration[5]) {
		case list[Method] methodList : return methodList;
	}
}

private MethodBody castMethodBody(Method method) {
	switch(method[5]) {
		case MethodBody methodBody : return methodBody;
	}
}