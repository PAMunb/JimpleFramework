module TestCallGraph

import lang::jimple::core::Context;
import lang::jimple::toolkit::CallGraph;
import lang::jimple::toolkit::GraphUtil;

import Map;
import Relation;
import Set;
import analysis::graphs::Graph;
import IO;
import Type;
 

//CGModel executeSimpleCallGraph(list[str] entryPoints, Analysis[&T] analysis){
//	files = [|project://JimpleFramework/target/test-classes/samples/callgraph/simple/SimpleCallGraph.class|];
//	return execute(files, entryPoints, analysis);
//}

test bool testSimpleGraph(){
	files = [|project://JimpleFramework/target/test-classes/samples/callgraph/simple/SimpleCallGraph.class|];
	es = [];
	CGModel model = execute(files, es, Analysis(computeCallGraphConditional));
		
	cg = transformToFullNames(model);	
	
	prefix = "samples.callgraph.simple.SimpleCallGraph.";
	
	calls = [prefix+"execute()",prefix+"A()",prefix+"B()",prefix+"D()"];	
	validPath = existPath(cg, calls);
	
	validPath2 = existPath(cg, [prefix+"B()",prefix+"E()",prefix+"G()"]);
	validPath3 = existPath(cg, [prefix+"A()",prefix+"C()",prefix+"F()"]);
	
	invalidPath = existPath(cg, [prefix+"A()",prefix+"B()",prefix+"G()"]);
	
	return validPath && validPath2 && validPath3 && !invalidPath;
}

test bool testSimpleGraphWithEntryPointA(){
	files = [|project://JimpleFramework/target/test-classes/samples/callgraph/simple/SimpleCallGraph.class|];
	es = ["samples.callgraph.simple.SimpleCallGraph.A()"];
	CGModel model = execute(files, es, Analysis(computeCallGraphConditional));
		
	cg = transformToFullNames(model);	
	
	prefix = "samples.callgraph.simple.SimpleCallGraph.";
	
	calls = [prefix+"A()",prefix+"B()",prefix+"D()"];	
	validPath = existPath(cg, calls);
	
	validPath2 = existPath(cg, [prefix+"B()",prefix+"E()",prefix+"G()"]);
	validPath3 = existPath(cg, [prefix+"A()",prefix+"C()",prefix+"F()"]);
	
	invalidPath = existPath(cg, [prefix+"execute()",prefix+"A()",prefix+"B()"]);
	invalidPath2 = existPath(cg, [prefix+"A()",prefix+"B()",prefix+"H()"]);
	
	return validPath && validPath2 && validPath3 && !invalidPath && !invalidPath2;
}


private CG transformToFullNames(CGModel model){
	mm = invertUnique(model.methodMap);	
	cg = {<mm[call.from], mm[call.to]> | call <- model.cg};	
	return cg;
}


/*
test bool testSimpleCallGraphStatistics(){	 
    CGModel model = executeSimpleCallGraph([], Analysis(computeCallGraphConditional));
    
    CG cg = model.cg;
    mm = invert(model.methodMap);
    
    bool numberOfCalls = (13 == size(model.cg));  
    bool numberOfProcedures = (12 == size(carrier(cg)));
    
    return numberOfCalls && numberOfProcedures;
}*/