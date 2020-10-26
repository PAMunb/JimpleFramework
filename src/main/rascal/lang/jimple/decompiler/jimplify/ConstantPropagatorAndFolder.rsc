module lang::jimple::decompiler::jimplify::ConstantPropagatorAndFolder

import lang::jimple::core::Syntax;

public ClassOrInterfaceDeclaration processConstantPropagatorAndFolder(ClassOrInterfaceDeclaration c) { 
	  c = top-down visit(c) {
	    case methodBody(ls, ss, cs) => processConstants(methodBody(ls, ss, cs))   
	  }
	  return c;   
	}

private MethodBody processConstants(MethodBody mb) {	
	return  methodBody([], [], []);	
}