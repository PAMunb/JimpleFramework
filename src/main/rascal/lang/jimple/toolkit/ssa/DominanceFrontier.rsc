module lang::jimple::toolkit::ssa::DominanceFrontier

import Set;
import analysis::graphs::Graph;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::toolkit::ssa::DominanceTree;

public map[Node, set[Node]] createDominanceFrontier(FlowGraph flowGraph, map[&T, set[&T]] dominanceTree) {
	dominanceFrontiers = ();

	for(X <- dominanceTree) {
		dominanceFrontiers[X] = {};
		
		for(Y <- flowGraph[X]){
			if(findIdom(dominanceTree, Y) != X) {
				dominanceFrontiers[X] = dominanceFrontiers[X] + {Y};		
			};
		};
		
		for(Z <- dominanceTree[X]) {
			for(Y <- dominanceTree[Z]) {
				if(findIdom(dominanceTree, Y) != Z) {
					dominanceFrontiers[X] = dominanceFrontiers[X] + {Y};
				};
			};
		};
	};

	return dominanceFrontiers;
}

public bool isJoinNode(FlowGraph flowGraph, Node child) {
	return size(predecessors(flowGraph, child)) >= 2;
}
