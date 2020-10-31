module lang::jimple::analysis::saa::DominanceFrontier

import Set;
import analysis::graphs::Graph;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::toolkit::ssa::DominanceTree;

public map[Node, set[Node]] createDominanceFrontier(FlowGraph flowGraph, map[&T, set[&T]] dominanceTree) {
	dominanceFrontiers = ();

	for(<origin, child> <- flowGraph) {
		if(true)
			dominanceFrontiers = calculateDominanceFrontier(origin, child, dominanceFrontiers, dominanceTree);
	};

	return dominanceFrontiers;
}

public map[Node, set[Node]] calculateDominanceFrontier(Node origin, Node destination, map[Node, set[Node]] dominanceFrontier, map[&T, set[&T]] dominanceTree) {
	temp = origin;

	while(temp != findIdom(dominanceTree, destination)) {
		originDominanceFrontierValue = if(dominanceFrontier[temp]?) dominanceFrontier[temp]; else {};
		dominanceFrontier[temp] = originDominanceFrontierValue + {destination};
		temp = findIdom(dominanceTree, temp);
	};

	return dominanceFrontier;
}

public bool isJoinNode(FlowGraph flowGraph, Node child) {
	return size(predecessors(flowGraph, child)) >= 2;
}
