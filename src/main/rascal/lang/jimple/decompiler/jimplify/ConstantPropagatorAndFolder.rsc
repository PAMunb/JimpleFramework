module lang::jimple::decompiler::jimplify::ConstantPropagatorAndFolder

import lang::jimple::core::Syntax;

import Eval;
import Set;


public ClassOrInterfaceDeclaration processConstantPropagatorAndFolder(ClassOrInterfaceDeclaration c) { 
	  c = top-down visit(c) {
	    case methodBody(ls, ss, cs) => processConstants(methodBody(ls, ss, cs))   
	  }
	  return c;   
	}

private methodBody processConstants(MethodBody mb) {
	top-down visit(mb) {
		case localVariableDeclaration(t,l): if( evalType("t") == "int") processIntConstants(mb, l);
	}
	return methodBody(ls, ss, cs);
}

private bool processIntConstants(methodBody mb, str id){
	top-down visit(mb) {
		case assign(localVariable(v,e)): if( v == id) return true;
	}
	return false;
}

