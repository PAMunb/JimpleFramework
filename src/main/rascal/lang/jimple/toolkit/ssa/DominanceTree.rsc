module lang::jimple::toolkit::ssa::DominanceTree

import demo::Dominators;
import Set;
import Relation;
import lang::jimple::toolkit::FlowGraph;
import analysis::graphs::Graph;

public map[&T, set[&T]] createDominanceTree(Graph[&T] graph) {
	PRED = graph;
	ROOT = entryNode();

	set[&T] rootDominators = reachX(PRED, {ROOT}, {});
	set[&T] VERTICES = carrier(PRED);

	temp = dominators(PRED, ROOT);

	return (V: (rootDominators - reachX(removeNodeFromGraph(graph, V), {ROOT}, {V}) - {V}) | &T V <- VERTICES );
}

public map[Node, list[Node]] createAdjacenciesMatrix(FlowGraph flowGraph) {
	blockTree = ( origin: [] | <origin, _> <- flowGraph);

	for(<origin, destination> <- flowGraph) {
		blockTree[origin] = blockTree[origin] + [destination];
	};

	return blockTree;
}

public map[Node, list[Node]] createIdomTree(map[&T, set[&T]] dominanceTree) {
	blockTree = ( treeKey: [] | treeKey <- dominanceTree);

	for(treeKey <- dominanceTree) {
		idom = findIdom(dominanceTree, treeKey);
		
		if(treeKey != entryNode())
			blockTree[idom] = blockTree[idom] + [treeKey];
	};

	return blockTree;
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