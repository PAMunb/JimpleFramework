module lang::jimple::decompiler::jimplify::ConstantPropagatorAndFolder

import lang::jimple::core::Syntax;
import lang::jimple::util::JPrettyPrinter;
import lang::jimple::analysis::dataflow::ReachDefinition;
import lang::jimple::toolkit::FlowGraph; 
import Prelude;

public ClassOrInterfaceDeclaration processConstantPropagatorAndFolder(ClassOrInterfaceDeclaration c) { 
	  c = top-down visit(c) {
	    case methodBody(ls, ss, cs) => processConstants(methodBody(ls, ss, cs))   
	  }
	  return c;   
	}

private MethodBody processConstants(MethodBody mb) {
	
	AnalysisResult[Statement] reachDefs = execute(rd, mb);
	
	//printlnExp("Quantidade de stmts ", size(mb.stmts)); 
	//printlnExp("Quantidade de elementos no mapa reach ", size(reachDefs.outSet)); 


  list[str] const_deleted = [];
  map[str, Value] const_eval = ();
  
  //compute constants
  for (n <- mb.stmts) {
    set[Statement] reachs = reachDefs.outSet[stmtNode(n)];
    for (r <- reachs) {
      switch (r) {
        case assign(localVariable(lhs), immediate(iValue(rhs))) : {
        	if (!(lhs in const_eval) && !(lhs in const_deleted)) {
            const_eval[lhs] = rhs;
        	} else { 
        	   if (const_eval[lhs] != rhs) {
        	     delete(const_eval, lhs);
        	     const_deleted += lhs;
        	   }
        	}
        }
      }
    }
  }
    
  //update values in expressions
  mb.stmts = top-down visit(mb.stmts) {
    case local(name) => iValue(const_eval[name])
        when name in const_eval
  }
      
  //remove local variable declaration and definition
  mb.localVariableDecls = [s | s <- mb.localVariableDecls, filterUsedVariables(s, const_eval)];  
    
	return  mb;	
}


private bool filterUsedVariables(LocalVariableDeclaration local, map[str, Value] used) {
  switch(local) {
    case localVariableDeclaration(_, name): return !(name in used);
    default: return true;
  }
}
