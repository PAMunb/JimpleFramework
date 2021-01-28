module lang::jimple::toolkit::ssa::DominanceTree

import demo::Dominators;
import Set;
import Relation;
import lang::jimple::toolkit::FlowGraph;
import analysis::graphs::Graph;

/*
	This tree returned is a set of dominance subtrees for each node, the ideal tree would be a one
	that contains the the immediate childs for each leaf instead all the dominated ones.

	Once done, the findIdom function will be far more simple, because we would only need
	to find for leaf that contains a given child. So that leaf would be the immediate domminator.
*/

public map[&T, set[&T]] createDominanceTree(Graph[&T] graph) {
	PRED = graph;
	ROOT = entryNode();

	set[&T] rootDominators = reachX(PRED, {ROOT}, {});
	set[&T] VERTICES = carrier(PRED);

	temp = dominators(PRED, ROOT);

	return (V: (rootDominators - reachX(removeNodeFromGraph(graph, V), {ROOT}, {V}) - {V}) | &T V <- VERTICES );
}

public Graph[&T] removeNodeFromGraph(Graph[&T] graph, &T nodeToRemove) {
 return { <father, graphChild> | <father, graphChild> <- graph, nodeToRemove != father || nodeToRemove == entryNode() };
}


public Node findIdom(map[&T, set[&T]] dominanceTree, Node child) {
	ROOT = entryNode();
	idom = entryNode();

	possibleIdoms = [ father | father <- dominanceTree, child in dominanceTree[father] ];

	for(possibleIdom <- possibleIdoms) {
		if(size(dominanceTree[possibleIdom]) < size(dominanceTree[idom])) {
			idom = possibleIdom;
		};
	};

	return idom;
}

public map[Node, list[Node]] createFlowGraphBlockTree(FlowGraph flowGraph) {
	blockTree = ( origin: [] | <origin, _> <- flowGraph);

	for(<origin, destination> <- flowGraph) {
		blockTree[origin] = blockTree[origin] + [destination];
	};

	return blockTree;
}
