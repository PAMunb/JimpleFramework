module lang::jimple::toolkit::CallGraph

import lang::jimple::core::Context; 
import lang::jimple::Syntax; 

import List; 
import Map; 

import String;
import IO;

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
alias CG = rel[str from, str to];

/* 
 * The CGModel (call-graph model) is an algebraic 
 * data type with two components: a CG and a MethodMap. 
 */ 
data CGModel = CGModel(CG cg, MethodMap methodMap);

/* the empty call graph model */ 
CGModel emptyModel = CGModel({}, ()); 



CGModel computeCallGraph(ExecutionContext ctx) {
  	list[MethodSignature] methods = []; 
   
   	top-down visit(ctx) {
     	case classDecl(TObject(cn), _, _, _, _, mss): {
     		for(method(_,r,mn,args,_,_) <- mss){
            	methods = methods + methodSignature(cn, r, mn, args);                     
            }   
     	} 
   	}  	
   
   return computeCallGraphNovo(ctx, methods);
}

//TODO review
CGModel computeCallGraphNovo(ExecutionContext ctx) {   
   	list[MethodSignature] methods = []; 
   
	top-down visit(ctx) {
     	case classDecl(TObject(cn), _, _, _, _, mss): {
            //methods = methods + [methodSignature(cn, r,n,f) | /Method(method(m,r,n,f,e,b),true) <- ctx];
            //methods = methods + [methodSignature(cn, r, n, f) | /Method(method(m,r,n,f,e,b),true) <- ctx, method(m,r,n,f,e,b) in mss];
         	for(method(_,r,mn,args,_,_) <- mss){
            	sig = signature(cn, mn, args);            	
            	if(ctx.mt[sig].entryPoint){
            		methods = methods + methodSignature(cn, r, mn, args);
            	}            	
            }             
      	}
  	}  
   
  	return computeCallGraphNovo(ctx, methods);
}

CGModel computeCallGraphNovo(ExecutionContext ctx, list[MethodSignature] methods) {
   	cg = emptyModel;        
  	return computeCallGraph(methods, cg, ctx);
}

CGModel computeCallGraph([], CGModel model, _) = model;
CGModel computeCallGraph(list[MethodSignature] methods, CGModel model, ExecutionContext ctx) {
	MethodSignature method = head(methods);
	//println("\n\ncomputeCallGrapha .... <method>");	
  	mm = model.methodMap; 
  	cg = model.cg; 
  
  	str sig1 = signature(method.className, method.methodName, method.formals);  
  	//print("\tsig1=");println(sig1);
  	if(! (sig1 in mm)) {
  		mm[sig1] = "M" + "<size(mm) + 1>"; 
  	}
    
  	top-down visit(ctx.mt[sig1].method.body) {
    	case virtualInvoke(_, methodSignature(cn, r, mn, args), _): {
      		sig2 = signature(cn,mn,args); 
      		//print("\t\tsig2="+sig2);
      		if(! (sig2 in mm)) {
        		mm[sig2] = "M" + "<size(mm) + 1>"; 
      		}
      		cg = cg + <mm[sig1], mm[sig2]>;   
      		methods = methods + methodSignature(replaceAll(cn, "/", "."), r, mn, args);
    	} 
  	}
  	
  	return computeCallGraph(tail(methods), CGModel(cg, mm), ctx);
}





/////////////////////////////////// ORIGINAL
/* Computes a "full" call graph from an 
 * execution context. A better approach 
 * is to build a call graph starting from 
 * the entry points. 
 *
 * Let's fix this implementation latter. 
 */ 
CGModel computeCallGraphOriginal(ExecutionContext ctx) {
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
  
  str sig1 = signature(cn, mn, args);
  
  if(! (sig1 in mm)) {
  	mm[sig1] = "M" + "<size(mm) + 1>"; 
  }
  
  top-down visit(body) {
    case virtualInvoke(_, sig, _): {
      sig2 = signature(sig); 
      if(! (sig2 in mm)) {
        mm[sig2] = "M" + "<size(mm) + 1>"; 
      }
      cg = cg + <mm[sig1], mm[sig2]>;     
    } 
  }
  
  return computeCallGraph(TObject(cn), ms, CGModel(cg, mm)); 
}
