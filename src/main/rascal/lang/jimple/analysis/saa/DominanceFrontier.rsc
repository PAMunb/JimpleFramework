module lang::jimple::analysis::saa::DominanceFrontier

import Set;
import analysis::graphs::Graph;
import lang::jimple::analysis::FlowGraph;
import lang::jimple::analysis::saa::DominanceTree;

public map[Node, set[Node]] createDominanceFrontier(FlowGraph flowGraph, rel[&T, set[&T]] dominanceTree) {
	dominanceFrontiers = ();
	
	for(<origin, child> <- flowGraph) {
		if(isJoinNode(flowGraph, child))
			dominanceFrontiers = calculateDominanceFrontier(origin, child, flowGraph, dominanceFrontiers, dominanceTree);
	};
	
	return dominanceFrontiers;
}

public map[Node, set[Node]] calculateDominanceFrontier(Node origin, Node destination, FlowGraph flowGraph, map[Node, set[Node]] dominanceFrontier, rel[&T, set[&T]] dominanceTree) {
	temp = origin;
	
	while(temp != findIdom(flowGraph, dominanceTree, destination)) {
		originDominanceFrontierValue = if(dominanceFrontier[temp]?) dominanceFrontier[temp]; else {};
		dominanceFrontier[temp] = originDominanceFrontierValue + {destination};
		temp = findIdom(flowGraph, dominanceTree, temp);
	};

	return dominanceFrontier;
}

public bool isJoinNode(FlowGraph flowGraph, Node child) {
	return size(predecessors(flowGraph, child)) > 2;
}