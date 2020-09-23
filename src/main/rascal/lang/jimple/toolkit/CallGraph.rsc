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
 *
 * samples.callgraph.simple.SimpleCallGraph.execute(): M1
 */ 
alias MethodMap = map[str, str]; 

/*
 * The control flow graph is a 
 * set of pairs {<M1, M2>, <M1, M3>, <M2, M4>, ...} 
 * indicating that M1 calls M2, M1 call M3, M2 call M4, 
 * and so forth.
 *
 * This is the Rascal's approach for modelling graphs.  
 */ 
alias CG = rel[str from, str to];

/* 
 * The CGModel (call-graph model) is an algebraic 
 * data type with two components: a CG and a MethodMap. 
 */ 
data CGModel = CGModel(CG cg, MethodMap methodMap);

/* the empty call graph model */ 
CGModel emptyModel = CGModel({}, ()); 



//TODO: diferenciar os metodos:
// - que gera o grafo todo SEM levar em conta os entry points
// - que gera o grafo todo LEVANDO em conta os entry points



/* Computes a "full" call graph from an 
 * execution context. A better approach 
 * is to build a call graph starting from 
 * the entry points. 
 *
 * Let's fix this implementation latter. 
 */ 
CGModel computeCallGraph(ExecutionContext ctx) {
  	list[MethodSignature] methods = []; 
   
   	top-down visit(ctx) {
     	case classDecl(TObject(cn), _, _, _, _, mss): {
     		for(method(_,r,mn,args,_,_) <- mss){
            	methods = methods + methodSignature(cn, r, mn, args);                     
            }   
     	} 
   	}  	
   
   return computeCallGraph(ctx, methods);
}

/* Computes a call graph from an execution 
 * context, starting from the entry points 
 * defined in the execution context.
 *
 * TODO review/refactoring 
 */ 
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
   
  	return computeCallGraph(ctx, methods);
}

/* Computes a call graph from an execution 
 * context, starting from the entry points 
 * passed as parameter.
 *
 */ 
CGModel computeCallGraph(ExecutionContext ctx, list[MethodSignature] methods) {
   	cg = emptyModel;        
  	return computeCallGraph(methods, cg, ctx);
}

/* 
 * Computes the call graph for a specific method. 
 * This is a recursive implementation, using the 
 * second argument as an acummulator.  
 */
CGModel computeCallGraph([], CGModel model, _) = model;
CGModel computeCallGraph(list[MethodSignature] methods, CGModel model, ExecutionContext ctx) {
	MethodSignature method = head(methods);
  	
  	mm = model.methodMap; 
  	cg = model.cg; 
  
  	str sig1 = signature(method.className, method.methodName, method.formals);  
  	
  	//do not follow external methods
  	if(sig1 in ctx.mt){
  	  	
  		if(! (sig1 in mm)) {
  			mm[sig1] = "M" + "<size(mm) + 1>"; 
  		}
    
	  	top-down visit(ctx.mt[sig1].method.body) {
	  		case virtualInvoke(_, methodSignature(cn, r, mn, args), _): {
	      		sig2 = signature(cn,mn,args); 
	      		//println("\ncomputeCallGraph .... <method>");
	      		//println("\tsig1="+sig1);
	      		//println("\t\tsig2_virtual="+sig2);
	      		if(! (sig2 in mm)) {
	        		mm[sig2] = "M" + "<size(mm) + 1>"; 
	      		}
	      		cg = cg + <mm[sig1], mm[sig2]>;   
	      		//do not follow external methods
	  			if(sig2 in ctx.mt){
	  				sig = methodSignature(replaceAll(cn, "/", "."), r, mn, args);
		      		if(! (sig in methods)){
		      			methods = methods + sig;
		      		}
	  			}
	    	} 
	    	case specialInvoke(_, methodSignature(cn, r, mn, args), _): {
	      		sig2 = signature(cn,mn,args); 
	      		//println("\ncomputeCallGraph .... <method>");
	      		//println("\tsig1="+sig1);
	      		//println("\t\tsig2_special="+sig2);
	      		if(! (sig2 in mm)) {
	        		mm[sig2] = "M" + "<size(mm) + 1>"; 
	      		}
	      		cg = cg + <mm[sig1], mm[sig2]>;   
	      		//do not follow external methods
	  			if(sig2 in ctx.mt){
	  				sig = methodSignature(replaceAll(cn, "/", "."), r, mn, args);
		      		if(! (sig in methods)){
		      			methods = methods + sig;
		      		}
	  			}
	    	} 
	    	case staticMethodInvoke(methodSignature(cn, r, mn, args), _): {
	      		sig2 = signature(cn,mn,args); 
	      		//println("\ncomputeCallGraph .... <method>");
	      		//println("\tsig1="+sig1);
	      		//println("\t\tsig2_static="+sig2);
	      		if(! (sig2 in mm)) {
	        		mm[sig2] = "M" + "<size(mm) + 1>"; 
	      		}
	      		cg = cg + <mm[sig1], mm[sig2]>;   
	      		//do not follow external methods
	  			if(sig2 in ctx.mt){
	  				sig = methodSignature(replaceAll(cn, "/", "."), r, mn, args);
		      		if(! (sig in methods)){
		      			methods = methods + sig;
		      		}
	  			}
	    	} 
	  	}//END visit
  	}//END if(sig1 in ctx.mt)
  	
  	return computeCallGraph(tail(methods), CGModel(cg, mm), ctx);
}
