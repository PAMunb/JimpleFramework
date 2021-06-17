module lang::jimple::toolkit::ssa::DominanceFrontier

import Set;
import analysis::graphs::Graph;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::toolkit::ssa::DominanceTree;

public map[Node, set[Node]] calculateDomFrontier(FlowGraph flowGraph) {
	cfgNodes = { origin | <origin, _> <- flowGraph } + { destination | <_, destination> <- flowGraph } ;

	map[Node, set[Node]] domFrontier = ();

	for(X <- cfgNodes) {
		domFrontier[X] = {};

		for(Y <- cfgNodes) {
			nodePredecessors = predecessors(flowGraph, Y);
			result = { predecessor | predecessor <- nodePredecessors, isDominated(flowGraph, X, predecessor) && !isDominated(flowGraph, X, Y) };
			
			if(size(result) != 0) {
				domFrontier[X] = domFrontier[X] + {Y}; 
			}
		};
	};

	return domFrontier;
}

public bool isDominated(FlowGraph flowGraph, Node X, Node predecessor) {
	result = { <origin, destination> | <origin, destination> <- flowGraph, origin == X && destination == predecessor };

	return size(result) != 0;
}

public bool isJoinNode(FlowGraph flowGraph, Node child) {
	return size(predecessors(flowGraph, child)) >= 2;
}
