module lang::jimple::toolkit::BasicMetrics

import lang::jimple::core::Syntax;
import lang::jimple::core::Context; 

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
