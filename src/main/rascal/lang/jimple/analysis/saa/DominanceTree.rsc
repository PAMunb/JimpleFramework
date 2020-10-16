module lang::jimple::analysis::saa::DominanceTree

import demo::Dominators;

import lang::jimple::analysis::FlowGraph;
import analysis::graphs::Graph;

public rel[&T, set[&T]] createDominanceTree(Graph[&T] graph) {
	return dominators(graph, entryNode());
}