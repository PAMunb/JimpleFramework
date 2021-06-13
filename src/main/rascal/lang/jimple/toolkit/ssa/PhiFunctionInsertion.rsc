module lang::jimple::toolkit::ssa::PhiFunctionInsertion

import demo::Dominators;
import Set;
import Relation;
import Type;
import IO;
import Node;
import List;

import analysis::graphs::Graph;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;
import lang::jimple::toolkit::ssa::Helpers;

public FlowGraph insertPhiFunctions(FlowGraph flowGraph, map[&T, set[&T]] dominanceFrontier) {
	newFlowGraph = { <origin, destination> | <origin, destination> <- flowGraph };
	variableList = { getStmtVariable(graphNode) | <graphNode, _> <- flowGraph, isVariable(graphNode) };

	for(Variable variable <- variableList) {
		phiBasicBlocks = {}; // "F" set of basic blocks where φ is added
		basicBlocksContainsVariable = {}; // "W" set of basic blocks that contain definitions of v

		for(variableNode <- blocksWithVariable(flowGraph, variable)) { // d ∈ Defs(v)
			tempVariableNode = variableNode;
			basicBlocksContainsVariable = basicBlocksContainsVariable + {tempVariableNode};
		};

		while(size(basicBlocksContainsVariable) != 0) {
			// remove a basic block X from W
			tuple[Node, set[Node]] elements = takeOneFrom(basicBlocksContainsVariable);
			X = elements[0];
			basicBlocksContainsVariable = elements[1];

			if(X in dominanceFrontier) { // Avoids NoSuchKey error
				frontierNodes = dominanceFrontier[X];
				for(frontierNode <- frontierNodes) { // Y : basic block ∈ DF(X )
					if(size({frontierNode} & phiBasicBlocks) == 0 && isJoinNode(flowGraph, frontierNode)) { // Y \notin F && Y is a join node
						newFlowGraph = insertPhiFunction(newFlowGraph, frontierNode, variable); // add v←φ(...) at entry of Y
						phiBasicBlocks = phiBasicBlocks + {frontierNode}; // F ← F ∪ {Y}
						if(size([frontierNode] & blocksWithVariable(flowGraph, variable)) == 0) { // Y \notin Defs(v)
							basicBlocksContainsVariable = basicBlocksContainsVariable + {frontierNode}; // W ←W ∪{Y}
						};
					};
				};
			};
		};
	};

	return newFlowGraph;
}

public bool isJoinNode(FlowGraph flowGraph, Node frontierNode) {
	int fathersSize = size([ fatherNode | <fatherNode, childNode> <- flowGraph, childNode == frontierNode ]);

	return fathersSize > 1;
}

public &T getStmtVariable(Node graphNode) {
	assignStatement = returnStmtNodeBody(graphNode);
	variableArg = assignStatement[0];

	return variableArg;
}

public list[Node] blocksWithVariable(FlowGraph flowGraph, Variable variable) {
	return [graphNode | <graphNode, _> <- flowGraph, isSameVariable(graphNode, variable)];;
}

public bool isVariable(Node graphNode) {
	if (size(graphNode[..]) == 0) return false;

	assignStatement = returnStmtNodeBody(graphNode);
	if (size(assignStatement[..]) == 0) return false;

	variableArg = assignStatement[0];
	typeOfVariableArg = typeOf(variableArg);

	if (size(typeOfVariableArg[..]) == 0) return false;

	return typeOfVariableArg.name == "Variable";
}

public bool isSameVariable(Node graphNode, Variable variable) {
	if (size(graphNode[..]) == 0) return false;

	assignStatement = returnStmtNodeBody(graphNode);
	if (size(assignStatement[..]) == 0) return false;

	variableArg = assignStatement[0];
	typeOfVariableArg = typeOf(variableArg);

	if (size(typeOfVariableArg[..]) == 0) return false;

	return variableArg == variable;
}

public FlowGraph insertPhiFunction(FlowGraph flowGraph, Node childNode, Variable variable) {
	fatherNodes = predecessors(flowGraph, childNode);
	phiFunctionStmt = stmtNode(assign(variable, phiFunction(variable, [])));

	phiFunctionRelations = { <fatherNode, phiFunctionStmt> | fatherNode <- fatherNodes };
	filteredFlowGraph = { <origin, destination> | <origin, destination> <- flowGraph, !(origin in fatherNodes) || !(childNode == destination) };

	flowGraphWithPhiFunction = phiFunctionRelations + filteredFlowGraph + {<phiFunctionStmt, childNode>};

	return flowGraphWithPhiFunction;
}
