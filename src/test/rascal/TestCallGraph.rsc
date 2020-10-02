module TestCallGraph

import lang::jimple::core::Context;
import lang::jimple::toolkit::CallGraph;
import lang::jimple::toolkit::GraphUtil;

import Map;
 
//compile test classes before running this test:
//mvn test -DskipTest

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

test bool testSimpleGraphWithEntryPointsBandC(){
	files = [|project://JimpleFramework/target/test-classes/samples/callgraph/simple/SimpleCallGraph.class|];
	es = ["samples.callgraph.simple.SimpleCallGraph.B()","samples.callgraph.simple.SimpleCallGraph.C()"];
	CGModel model = execute(files, es, Analysis(computeCallGraphConditional));
		
	cg = transformToFullNames(model);	
	
	prefix = "samples.callgraph.simple.SimpleCallGraph.";
	
	calls = [prefix+"B()",prefix+"E()",prefix+"G()"];	
	validPath = existPath(cg, calls);
	
	validPath2 = existPath(cg, [prefix+"B()",prefix+"D()"]);
	validPath3 = existPath(cg, [prefix+"C()",prefix+"E()",prefix+"G()"]);
	validPath4 = existPath(cg, [prefix+"C()",prefix+"F()",prefix+"G()"]);
	
	invalidPath = existPath(cg, [prefix+"execute()",prefix+"A()",prefix+"B()"]);
	invalidPath2 = existPath(cg, [prefix+"B()",prefix+"H()"]);
	
	return validPath && validPath2 && validPath3 && validPath4 && !invalidPath && !invalidPath2;
}

//the nodes in original CG have simple name.
//return a new graph (CG) with method's full names. 
//TODO move this method to CallGraph module???
private CG transformToFullNames(CGModel model){
	mm = invertUnique(model.methodMap);	
	cg = {<mm[call.from], mm[call.to]> | call <- model.cg};	
	return cg;
}


/* TODO atualizar esse metodo depois de decidir como (e se) tratar construtores
test bool testSimpleCallGraphStatistics(){	 
    CGModel model = executeSimpleCallGraph([], Analysis(computeCallGraphConditional));
    
    CG cg = model.cg;
    mm = invert(model.methodMap);
    
    bool numberOfCalls = (13 == size(model.cg));  
    bool numberOfProcedures = (12 == size(carrier(cg)));
    
    return numberOfCalls && numberOfProcedures;
}*/