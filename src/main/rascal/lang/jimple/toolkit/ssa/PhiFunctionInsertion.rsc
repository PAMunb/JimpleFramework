module lang::jimple::toolkit::ssa::PhiFunctionInsertion

import demo::Dominators;
import Set;
import Relation;
import analysis::graphs::Graph;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;
import Type;
import IO;
import Node;
import List;

public list[Variable] insertPhiFunctions(FlowGraph flowGraph, map[&T, set[&T]] dominanceFrontier) {
	assignVariableStmts = {graphNode | <graphNode, _> <- flowGraph, isVariable(graphNode)};
	variableList = [getStmtVariable(graphNode) | <graphNode, _> <- flowGraph, isVariable(graphNode)];
	
	for(Variable variable <- variableList) {
		F = {}; // set of basic blocks where φ is added
		W = {}; // set of basic blocks that contain definitions of v
		
		for(variableNode <- blocksWithVariable(flowGraph, variable)) { // d ∈ Defs(v)
			B = variableNode;
			W = W + {B};
		};
		
		while(size(W) != 0) {
			// remove a basic block X from W
			tuple[Node, set[Node]] elements = takeOneFrom(W);
			X = elements[0];
			W = elements[1];
			
			if(X in dominanceFrontier) { // Avoids NoSuchKey error
				frontierNodes = dominanceFrontier[X];
				for(Y <- frontierNodes) { // Y : basic block ∈ DF(X )
					if(size({Y} & F) == 0) { // Y \notin F
						flowGraph = insertPhiFunction(flowGraph, Y, variable); // add v←φ(...) at entry of Y
						F = F + {Y}; // F ← F ∪ {Y}
						if(size({Y} & assignVariableStmts) ) { // Y \notin Defs(v)
							W = W + {Y}; // W ←W ∪{Y}
						};
					};
				};
			};
		};
	};

	return [];
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

public &T getStmtVariable(Node graphNode) {
	stmtNode(assignStatement) = graphNode;
	variableArg = assignStatement[0];

	return variableArg;
}

public bool isSameVariable(Node graphNode, Variable variable) {
	if (size(graphNode[..]) == 0) return false;
	
	stmtNode(assignStatement) = graphNode;
	variableArg = assignStatement[0];
	typeOfVariableArg = typeOf(variableArg);
	
	if (size(typeOfVariableArg[..]) == 0) return false;
	
	return variableArg == variable;
}

public FlowGraph insertPhiFunction(FlowGraph flowGraph, Node childNode, Variable variable) {
	fatherNodes = predecessors(flowGraph, childNode);
	phiFunctionStmt = stmtNode(phiFunction(variable));
	
	phiFunctionRelations = { <fatherNode, phiFunctionStmt> | fatherNode <- fatherNodes };
	filteredFlowGraph = { <origin, destination> | <origin, destination> <- flowGraph, !(origin in fatherNodes) || !(childNode == destination) };
	
	flowGraphWithPhiFunction = phiFunctionRelations + filteredFlowGraph + {<phiFunctionStmt, childNode>};
	
	return flowGraphWithPhiFunction;
}