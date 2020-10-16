module lang::jimple::analysis::saa::DominanceFrontier

import Set;
import analysis::graphs::Graph;
import lang::jimple::analysis::FlowGraph;


public map[Node, set[Node]] createDominanceFrontier(FlowGraph flowGraph) {
	dominanceFrontiers = ();
	for(<origin, destination> <- flowGraph)
		dominanceFrontiers = calculateDominanceFrontier(flowGraph, origin, destination, dominanceFrontiers);
	
	return dominanceFrontiers;
}

public map[Node, set[Node]] calculateDominanceFrontier(FlowGraph flowGraph, Node origin, Node destination, map[Node, set[Node]] dominanceFrontier) {
	if(size(nodeFathers(flowGraph, destination)) < 2) return dominanceFrontier;

	originDominanceFrontierValue = if(dominanceFrontier[origin]?) dominanceFrontier[origin]; else {};
	dominanceFrontier[origin] = originDominanceFrontierValue + {destination}; 
	
	return dominanceFrontier;
}

public set[Node] nodeFathers(FlowGraph flowGraph, Node child) {
	return predecessors(flowGraph, child);
}