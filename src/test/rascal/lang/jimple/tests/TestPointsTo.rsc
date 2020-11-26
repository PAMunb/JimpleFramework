module lang::jimple::tests::TestPointsTo

import lang::jimple::analysis::pointsto::Framework;
import lang::jimple::toolkit::CallGraph;
import lang::jimple::core::Context;
import lang::jimple::toolkit::GraphUtil;

import Map;
import Set;
import IO;

private CG transformToFullNames(CGModel model){
  mm = invertUnique(model.methodMap); 
  cg = {<mm[call.from], mm[call.to]> | call <- model.cg}; 
  return cg;
}


test bool testInitial() {
	files = [|project://JimpleFramework/target/test-classes/samples/pointsto/MyContainer.class|];
	es = [];
	CGModel model = execute(files, es, Analysis(generateCallGraph(given(["samples.pointsto.MyContainer.go()"]), CHA())));
		
	cg = transformToFullNames(model);	
	
	println("CG=<cg>");
	
	return true;
}