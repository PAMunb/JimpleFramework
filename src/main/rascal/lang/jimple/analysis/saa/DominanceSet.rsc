module lang::jimple::analysis::saa::DominanceSet

import List;
import lang::jimple::analysis::FlowGraph;

public map[Node, set[Node]] createDominanceSet(FlowGraph flowGraph) {
	dominanceSetMap = initializeDominanceSetMap(flowGraph);
	
	solve(dominanceSetMap) {
		dominanceSetMap = (currentNode: computeDominanceSet(flowGraph, dominanceSetMap, currentNode) | currentNode <- dominanceSetMap); 
	};
 	
	return dominanceSetMap;
}

public set[Node] computeDominanceSet(FlowGraph flowGraph, map[Node, set[Node]] dominanceSetMap, Node currentNode) {
	predecessorNode = findPredecessorNode(flowGraph, currentNode);
	predecessorNodeDomSet = dominanceSetMap[predecessorNode];
	currentNodeDomSet = dominanceSetMap[currentNode];

	return {currentNode, *intersectionBetweenDominanceSets(currentNodeDomSet, predecessorNodeDomSet)};
}

public Node findPredecessorNode(FlowGraph flowGraph, Node currentNode) {
	predecessorNodeList = [a | <a, b> <- flowGraph, b == currentNode];
	return if(isEmpty(predecessorNodeList) == true) currentNode; else head(predecessorNodeList);; 
}

public set[Node] intersectionBetweenDominanceSets(set[Node] currentNodeDomSet, set[Node] predecessorNodeDomSet) {
	return currentNodeDomSet & predecessorNodeDomSet;
}

public map[Node, set[Node]] initializeDominanceSetMap(FlowGraph flowGraph) {
	allNodes = { a | <a, _> <- flowGraph };
	entryNodeDominanceSetMap = (entryNode(): {entryNode()});
	remainingNodesDominanceSetMap = (a: allNodes | <a, _> <- flowGraph, a != entryNode());
	
	return entryNodeDominanceSetMap + remainingNodesDominanceSetMap;
}