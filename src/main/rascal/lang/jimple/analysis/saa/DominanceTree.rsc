module lang::jimple::analysis::saa::DominanceTree

import List;
import lang::jimple::analysis::FlowGraph;

public map[Node, Node] createDominanceTree(FlowGraph flowGraph) {
	result = (computeDominator(flowGraph, a): a | <a, _> <- flowGraph);
	return result;
}

public Node computeDominator(FlowGraph flowGraph, Node currentNode) {
	predecessorNodeList = [a | <a, b> <- flowGraph, b == currentNode];
	result = if(isEmpty(predecessorNodeList) == true) currentNode; else head(predecessorNodeList);
	return result;
}