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

//TODO: Check Arrays.java (twoDimensions has a bug)
private MethodBody processConstants(MethodBody mb) {
	
	AnalysisResult[Statement] reachDefs = execute(rd, mb);
	
  list[str] const_deleted = [];
  map[str, Value] const_final = ();
  
  //compute constants (TODO: this logic is not good.)
  for (n <- mb.stmts) {
    set[Statement] reachs = reachDefs.outSet[stmtNode(n)];
    for (r <- reachs) {
      switch (r) {
        case assign(localVariable(lhs), immediate(iValue(rhs))) : {
          //Not yet deleted or new var
          if (!(lhs in const_deleted)) {          
          	if (!(lhs in const_final)) {
              const_final[lhs] = rhs;
          	} else {
          	   if (const_final[lhs] != rhs) {
          	     const_final = delete(const_final, lhs); //Remove from Value store
          	     const_deleted += lhs; //Put it on deleteted list (never more const)
          	   }
          	}
          }
        }
        default: { 
          if (assign(localVariable(lhs),exp) := r) {
            //If the is a Expression (not iValue one) that kills a constant, remove it value store and put on deleted          
            if (lhs in const_final) {
              const_final = delete(const_final, lhs);
              const_deleted += lhs;
            }
          }
        }
      }
    }
  }
    
  //update values in expressions
  mb.stmts = top-down visit(mb.stmts) {
    case local(name) => iValue(const_final[name])
        when name in const_final
  }
      
  //remove local variable declaration and definition
  mb.localVariableDecls = [s | s <- mb.localVariableDecls, filterUsedVariables(s, const_final)];  
  mb.stmts = [s | s <- mb.stmts, filterUsedAssignment(s, const_final)];
      
	return  mb;	
}

private bool filterUsedVariables(LocalVariableDeclaration local, map[str, Value] used) {
  switch(local) {
    case localVariableDeclaration(_, name): return !(name in used);
    default: return true;
  }
}

private bool filterUsedAssignment(Statement stmt, map[str, Value] used) {
  switch(stmt) {
    case assign(localVariable(name), _): return !(name in used);
    default: return true;
  }
}
