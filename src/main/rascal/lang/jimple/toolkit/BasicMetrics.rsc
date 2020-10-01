module lang::jimple::toolkit::BasicMetrics

import lang::jimple::Syntax;
import lang::jimple::core::Context; 
import List;
import lang::jimple::toolkit::CallGraph;

/**
 * Computes the number of classes from 
 * an ExecutionContext. 
 */ 
public int numberOfClasses(ExecutionContext ctx) {
  int total = 0;
  top-down visit(ctx) {
    case classDecl(_, _, _, _, _, _): total = total + 1;  

  }	
  return total;
}

public list[str] classIdentification(ExecutionContext ctx) {
  list[str] cl = [];
  top-down visit(ctx) {
    
    case classDecl(_, _, _, _, _, list[Method] methods): cl = cl + ["classDecl(_, _, _, _, _, <methods>)"];
   
  }
  return cl; 
}

public list[Method] methodsIdentification(ExecutionContext ctx) {
  list[Method] lm = [];
  top-down visit(ctx) {
    
    case classDecl(_, _, _, _, _, list[Method] methods): lm = lm + methods;
   
  }
  return lm; 
}
public Method firstMethod(ExecutionContext ctx){
	list[Method] lm = methodsIdentification(ctx);
	Method m = head(lm);
	return m;
}

public list[str] methodsName(ExecutionContext ctx){
	list[str] name = [];
	top-down visit(ctx) {
    	
    	case method(_, _, nm, _, _, _): name = name+nm;
     	
    }
    return name;
}
public list[str] methodSignatureList(ExecutionContext ctx){
	list[str] mS = [];
	top-down visit(ctx) {
    	
    	case invokeStmt(specialInvoke(_,methodS,_)): mS = mS+methodSignature(methodS);
    	case invokeStmt(virtualInvoke(_,methodS,_)): mS = mS+methodSignature(methodS);
    	case invokeStmt(interfaceInvoke(_,methodS,_)): mS = mS+methodSignature(methodS);
    	case invokeStmt(staticMethodInvoke(methodS,_)): mS = mS+methodSignature(methodS);
    	case invokeStmt(dynamicInvoke(methodS,_,_,_)): mS = mS+methodSignature(methodS);
     	
    }
    return mS;
}



/**
 * Computes the number of public methods from an 
 * execution context. 
 */ 
public int numberOfPublicMethods(ExecutionContext ctx) {
  int total = 0;
  top-down visit(ctx) {
    case method(ms, _, _, _, _, _): { 
     if(Public() in ms) {
       total = total + 1;
     }
    }
  }	
  return total; 
}

