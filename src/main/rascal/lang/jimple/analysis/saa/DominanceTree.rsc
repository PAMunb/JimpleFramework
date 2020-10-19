module lang::jimple::analysis::saa::DominanceTree

import demo::Dominators;
import lang::jimple::analysis::FlowGraph;
import analysis::graphs::Graph;

/*
	This tree returned is a set of dominance subtrees for each node, the ideal tree would be a one
	that contains the the immediate childs for each leaf instead all the dominated ones.
	
	Once done, the findIdom function will be far more simple, because we would only need
	to find for leaf that contains a given child. So that leaf would be the immediate domminator.
*/

public rel[&T, set[&T]] createDominanceTree(Graph[&T] graph) {
	return dominators(graph, entryNode());
}

public Node findIdom(FlowGraph flowGraph, rel[&T, set[&T]] dominanceTree, Node child) {
	ROOT = entryNode();
	idom = entryNode();
	
	possibleIdoms = [ idom | <idom, childs> <- dominanceTree, child in childs];

	for(possibleIdom <- possibleIdoms) {
		tempGraph = { <father, child> | <father, child> <- flowGraph, father != possibleIdom };
		reachableNodes = reachX(tempGraph, {ROOT}, {});
		idom = child in reachableNodes ? idom : possibleIdom;
	};
	
	return idom;
}