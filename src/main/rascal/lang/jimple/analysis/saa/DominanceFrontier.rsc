module lang::jimple::analysis::saa::DominanceFrontier

import Set;
import List;
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
	
	possibleIdoms = findNearstIdom(flowGraph, origin);
	imdom = if(isEmpty(possibleIdoms)) return dominanceFrontier; else last(possibleIdoms);
	
	return calculateDominanceFrontier(flowGraph, imdom, origin, dominanceFrontier);
}

public list[Node] findNearstIdom(FlowGraph flowGraph, Node origin) {	
	fathers = nodeFathers(flowGraph, origin);
	if(isEmpty(fathers)) return [];
	
	possibleIdoms = [fatherNode | fatherNode <- fathers, size(fathers) < 2 ]; 
	
	if(isEmpty(possibleIdoms)) return last([findNearstIdom(flowGraph, father) | Node father <- fathers]);
	
	return possibleIdoms;
}

public set[Node] nodeFathers(FlowGraph flowGraph, Node child) {
	return predecessors(flowGraph, child);
}