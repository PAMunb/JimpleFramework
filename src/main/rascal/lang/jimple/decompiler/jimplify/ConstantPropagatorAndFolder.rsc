module lang::jimple::decompiler::jimplify::ConstantPropagatorAndFolder

import lang::jimple::core::Syntax;
import lang::jimple::util::JPrettyPrinter;
import lang::jimple::analysis::dataflow::ReachDefinition;
import lang::jimple::toolkit::FlowGraph; 
import Prelude;


import Eval;
import Set;


public ClassOrInterfaceDeclaration processConstantPropagatorAndFolder(ClassOrInterfaceDeclaration c) { 
	  c = top-down visit(c) {
	    case methodBody(ls, ss, cs) => processConstants(methodBody(ls, ss, cs))   
	  }
	  return c;   
	}

private MethodBody processConstants(MethodBody mb) {
	
	AnalysisResult[Statement] reachDefs = execute(rd, mb);

	printlnExp("Quantidade de stmts ", size(mb.stmts)); 
	printlnExp("Quantidade de elementos no mapa reach ", size(reachDefs.outSet)); 

  map[str, int] consts = ();
  //compute constants
  for (n <- mb.stmts) {
    set[Statement] reachs = reachDefs.outSet[stmtNode(n)];
    for (r <- reachs) {
      switch (r) {
        case assign(localVariable(lhs), immediate(iValue(rhs))) : 
      }    
    }
  }
  //update values in expressions
  //remove local variable declaration
  
  for(v <- mb.localVariableDecls) {
    println(v);
    for (n <- mb.stmts) {
      set[Statement] reachs = reachDefs.outSet[stmtNode(n)];
      
    }
  }
  
  for (n <- mb.stmts) {
    println("--------------------");
    println(size(reachDefs.outSet[stmtNode(n)]));
  	println(reachDefs.outSet[stmtNode(n)]);
    println("--------------------");
  }
	
//	for (variable <- mb.localVariableDecls) {
//		println("var " + prettyPrint(variable));
//
//	}
	return  methodBody([], [], []);	
}
