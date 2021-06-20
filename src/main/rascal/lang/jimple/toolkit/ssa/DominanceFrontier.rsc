module lang::jimple::toolkit::ssa::DominanceFrontier

import Set;
import analysis::graphs::Graph;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::toolkit::ssa::DominanceTree;

public map[Node, set[Node]] createDominanceFrontier(Node X, map[&T, set[&T]] dominanceFrontiers, FlowGraph flowGraph, map[&T, set[&T]] dominanceTree) {
	
	for(child <- dominanceTree[X]) {
		dominanceFrontiers = createDominanceFrontier(child, dominanceFrontiers, flowGraph, dominanceTree);
	};

	dominanceFrontiers[X] = {};
	
	for(Y <- flowGraph[X]){
		if(findIdom(dominanceTree, Y) != X && isJoinNode(flowGraph, Y)) {
			dominanceFrontiers[X] = dominanceFrontiers[X] + {Y};		
		};
	};
	
	for(Z <- dominanceTree[X]) {
		for(Y <- dominanceTree[Z]) {
			if(findIdom(dominanceTree, Y) != Z && isJoinNode(flowGraph, Y)) {
				dominanceFrontiers[X] = dominanceFrontiers[X] + {Y};
			};
		};
	};

	return dominanceFrontiers;
}

public bool isJoinNode(FlowGraph flowGraph, Node child) {
	return size(predecessors(flowGraph, child)) >= 2;
}
