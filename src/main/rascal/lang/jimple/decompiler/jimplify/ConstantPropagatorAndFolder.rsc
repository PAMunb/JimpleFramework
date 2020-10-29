module lang::jimple::decompiler::jimplify::ConstantPropagatorAndFolder

import lang::jimple::core::Syntax;
import lang::jimple::util::JPrettyPrinter;
import lang::jimple::analysis::dataflow::ReachDefinition;
import Prelude;


public ClassOrInterfaceDeclaration processConstantPropagatorAndFolder(ClassOrInterfaceDeclaration c) { 
	  c = top-down visit(c) {
	    case methodBody(ls, ss, cs) => processConstants(methodBody(ls, ss, cs))   
	  }
	  return c;   
	}

private MethodBody processConstants(MethodBody mb) {
	
	AnalysisResult[Statement] reachDefs = execute(rd, mb);
	for (v <- mb.localVariableDecls) {
		println("var " + prettyPrint(v));
	}
	return  methodBody([], [], []);	
}