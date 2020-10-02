module TestCallGraph

import lang::jimple::core::Context;
import lang::jimple::toolkit::CallGraph;

import Map;
import Relation;
import Set;
import analysis::graphs::Graph;

CGModel executeSimpleCallGraph(list[str] entryPoints, Analysis[&T] analysis){
	files = [|project://JimpleFramework/target/test-classes/samples/callgraph/simple/SimpleCallGraph.class|];
	return execute(files, entryPoints, analysis);
}

test bool testSimpleCallGraphStatistics(){	 
    CGModel model = executeSimpleCallGraph([], Analysis(computeCallGraph));
    
    CG cg = model.cg;
    mm = invert(model.methodMap);
    
    bool numberOfCalls = (13 == size(model.cg));  
    bool numberOfProcedures = (12 == size(carrier(cg)));
    
    return numberOfCalls && numberOfProcedures;
}