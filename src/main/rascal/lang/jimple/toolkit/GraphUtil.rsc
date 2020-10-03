module lang::jimple::toolkit::GraphUtil

import Set;
import List;
import analysis::graphs::Graph;

@doc{
Check if the (exact) path exists in the graph. 
}
public bool existPath(Graph[&T] graph, list[&T] path) {	
	calls = toRel(path);
	for(call <- calls) {
		if( !(call in graph) ){
			return false;
		}
	}
	return true;	
}