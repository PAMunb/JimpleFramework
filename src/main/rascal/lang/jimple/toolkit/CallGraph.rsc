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

// Computes a call graph by looking for all
// methods in the program or by starting by
// the program's entrypoints. This execution depends
// on the entrypoints inside the ExecutionContext data.
CGModel computeCallGraphConditional(ExecutionContext ctx) {
	MethodTable entryPoints = (s: ctx.mt[s] | s <- ctx.mt, ctx.mt[s].entryPoint == true);
	if (size(entryPoints) == 0) {
		return computeCallGraphFull(ctx);
	}
	return computeCallGraphFromEntryPoints(ctx);
}

/* Computes a "full" call graph from an 
 * execution context. A better approach 
 * is to build a call graph starting from 
 * the entry points. 
 *
 * Let's fix this implementation latter. 
 */ 
CGModel computeCallGraphFull(ExecutionContext ctx) {
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
CGModel computeCallGraphFromEntryPoints(ExecutionContext ctx) {   
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
	MethodSignature currentMethod = head(methods);
  	
  	mm = model.methodMap; 
  	cg = model.cg; 
  
  	str sig1 = signature(currentMethod.className, currentMethod.methodName, currentMethod.formals);  
  	
  	//do not follow external methods
  	//if current method exists in context's methods table
  	if(sig1 in ctx.mt){
  	  	
  		if(! (sig1 in mm)) {
  			//define a simple name for current method
  			//if it doesnt already exists
  			mm[sig1] = "M" + "<size(mm) + 1>"; 
  		}
    
    	//visit the current method body, searching for invoke expressions
	  	top-down visit(ctx.mt[sig1].method.body) {	 	
	  		case InvokeExp e:{
	  			tuple[CG c, MethodMap m, list[MethodSignature] ms] t = compute(sig1, e, methods, cg, mm, ctx);
	      		cg = t.c;
	      		mm = t.m;
	      		methods = t.ms;	  
	  		}  			  		
	  	}
  	}
  	
  	//recursive call to deal with the rest (tail) of the methods
  	return computeCallGraph(tail(methods), CGModel(cg, mm), ctx);
}

//specialInvoke
public tuple[CG cg, MethodMap mm, list[MethodSignature] methods] compute(str sig1, specialInvoke(_, methodSignature(cn, r, mn, args), _), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx){
	return compute(sig1,methodSignature(cn, r, mn, args), methods, cg, mm, ctx);
}

//virtualInvoke
public tuple[CG, MethodMap, list[MethodSignature]] compute(str sig1, virtualInvoke(_, methodSignature(cn, r, mn, args), _), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx){
	return compute(sig1,methodSignature(cn, r, mn, args), methods, cg, mm, ctx);
}

//interfaceInvoke
public tuple[CG, MethodMap, list[MethodSignature]] compute(str sig1, interfaceInvoke(_, methodSignature(cn, r, mn, args), _), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx){
	return compute(sig1,methodSignature(cn, r, mn, args), methods, cg, mm, ctx);
}

//staticMethodInvoke
public tuple[CG, MethodMap, list[MethodSignature]] compute(str sig1, staticMethodInvoke(methodSignature(cn, r, mn, args), _), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx){
	return compute(sig1,methodSignature(cn, r, mn, args), methods, cg, mm, ctx);
	//TODO: infinite loop when testing SLF4J
	//return <cg,mm,methods>;
}

//dynamicInvoke
public tuple[CG, MethodMap, list[MethodSignature]] compute(str sig1, dynamicInvoke(_,_,_,_), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx){
	//TODO implement dynamicInvoke
	return <cg,mm,methods>;
}

public tuple[CG, MethodMap, list[MethodSignature]] compute(str from, methodSignature(cn, r, mn, args), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx) {	
	to = signature(cn,mn,args); 
	//println("\ncomputeCallGraph .... <method>");
	//println("\tsig1="+sig1);
	//println("\t\tsig2_static="+sig2);
	if(! (to in mm)) {
		mm[to] = "M" + "<size(mm) + 1>"; 
	}
	//insert a new relation in the call graph
	cg = cg + <mm[from], mm[to]>;   
	//do not follow external methods
	if(to in ctx.mt){
		sig = methodSignature(replaceAll(cn, "/", "."), r, mn, args);
  		if(! (sig in methods)){
  			//if method exists in the context add it to methods list, to be treated
  			methods = methods + sig;
  		}
	}
	return <cg,mm,methods>;
}

