module lang::jimple::toolkit::CallGraph

import lang::jimple::core::Context; 
import lang::jimple::Syntax; 

import List; 
import Map; 

/* ISSUES:
 * - #3: A new call graph analysis that starts from the entry points.
 *
 */

/* 
 * a map from method signatures 
 * to simple names (e.g., M1, M2, ...)
 */ 
alias MethodMap = map[str, str]; 

/*
 * The control flow graph is a 
 * set of pairs {<M1, M2>, <M1, M3>, <M2, M4>, ...} 
 * indicating that M1 calls M2, M1 call M3, M2 call M4, 
 * and so forth.
 *
 * This is the Rascal's approach for modelling 
 * graphs.  
 */ 
alias CG = rel[str, str];

/* 
 * The CGModel (call-graph model) is an algebraic 
 * data type with two components: a CG and a MethodMap. 
 */ 
data CGModel = CGModel(CG cg, MethodMap methodMap);

/* the empty call graph model */ 
CGModel emptyModel = CGModel({}, ()); 

/* Computes a "full" call graph from an 
 * execution context. A better approach 
 * is to build a call graph starting from 
 * the entry points. 
 *
 * Let's fix this implementation latter. 
 */ 
CGModel computeCallGraph(ExecutionContext ctx) {
   cg = emptyModel; 
   
   map[Type, list[Method]] methods = (); 
   
   top-down visit(ctx) {
     case classDecl(n, _, _, _, _, mss): methods[n] = mss; 
   }  
   
   for(c <- methods) {
     cg = computeCallGraph(c, methods[c], cg);
   }  	
   
   return cg;
}

/* 
 * Computes the call graph for a specific class, 
 * given its list of methods. This is a recursive 
 * implementation, using the third argument as an 
 * acummulator.  
 */ 
CGModel computeCallGraph(_, [], CGModel model) = model;
CGModel computeCallGraph(TObject(cn), [method(_, _, mn, args, _, body), *ms], CGModel model) {
  mm = model.methodMap; 
  cg = model.cg; 
  
  str sig1 = methodSignature(cn, mn, args);
  
  if(! (sig1 in mm)) {
  	mm[sig1] = "M" + "<size(mm) + 1>"; 
  }
  
  top-down visit(body) {
    case virtualInvoke(_, sig, _): {
      sig2 = methodSignature(sig); 
      if(! (sig2 in mm)) {
        mm[sig2] = "M" + "<size(mm) + 1>"; 
      }
      cg = cg + <mm[sig1], mm[sig2]>;     
    } 
  }
  
  return computeCallGraph(TObject(cn), ms, CGModel(cg, mm)); 
}

str methodSignature(methodSignature(cn, _, mn, args)) = methodSignature(cn, mn, args); 
str methodSignature(Name cn, Name mn, args) =  "<cn>.<mn>(<intercalate(",", args)>)";