module lang::jimple::toolkit::Teste2

import IO;
import Map;
import Type;
import Set;
import List;
import String;
import vis::Render;

import lang::jimple::core::Context; 
import lang::jimple::Syntax; 
import lang::jimple::toolkit::GraphUtil;

data EntryPointsStrategy = full() 
						| context() 
						| given(list[str] methods) 
						| publicMethods() 
						| j2se();

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
			
						
public &T(ExecutionContext) executar(EntryPointsStrategy strategy){
	return CGModel(ExecutionContext ctx) { 
        return computeCallGraph(ctx, strategy);
    }; 
}			


CGModel computeCallGraph(ExecutionContext ctx, EntryPointsStrategy strategy) {
	println("aaaa=<strategy>");
	methods = selectEntryPoints(ctx, strategy);
	return computeCallGraph(ctx, methods);
}			

private list[MethodSignature] selectEntryPoints(ExecutionContext ctx, EntryPointsStrategy strategy) {
	list[MethodSignature] methods = []; 
	
	top-down visit(ctx) {
     	case classDecl(TObject(cn), _, _, _, _, mss): {
         	for(m: method(_,r,mn,args,_,_) <- mss){
         		if(isEntryPoint(cn, m, ctx, strategy)){
         			methods = methods + methodSignature(cn, r, mn, args);
         		}
            }             
      	}
  	} 
  	
  	return methods;
}

private bool isEntryPoint(Name cn, Method m, ExecutionContext ctx, full()){
	return true;
}
private bool isEntryPoint(Name cn, Method m: method(_,r,mn,args,_,_), ExecutionContext ctx, context()){
	sig = signature(cn, mn, args); 
	return ctx.mt[sig].entryPoint;
}
private bool isEntryPoint(Name cn, Method m: method(_,r,mn,args,_,_), ExecutionContext ctx, given(list[str] methods) ){
	sig = signature(cn, mn, args);
	return sig in methods;
}
private bool isEntryPoint(Name cn, Method m, ExecutionContext ctx, publicMethods()){
	return Public() in m.modifiers;
}
private bool isEntryPoint(Name cn, Method m, ExecutionContext ctx, j2se()){
	modifiers = sort([Public(),Static(),Final()]);
	switch(m){
		case method(ms, TVoid(), "main", [TArray(TString())], _, _):
			return modifiers == sort(ms);
	}
	return false;
}



/* Computes a call graph from an execution 
 * context, starting from the entry points 
 * passed as parameter.
 *
 */ 
private CGModel computeCallGraph(ExecutionContext ctx, list[MethodSignature] methods) {
   	cg = emptyModel;        
  	return computeCallGraph(methods, cg, ctx);
}

/* 
 * Computes the call graph for a specific method. 
 * This is a recursive implementation, using the 
 * second argument as an acummulator.  
 */
private CGModel computeCallGraph([], CGModel model, _) = model;
private CGModel computeCallGraph(list[MethodSignature] methods, CGModel model, ExecutionContext ctx) {
	MethodSignature currentMethod = head(methods);
  	
  	mm = model.methodMap; 
  	cg = model.cg; 
  
  	str from = signature(currentMethod.className, currentMethod.methodName, currentMethod.formals);  
  	
  	//do not follow external methods
  	//if current method exists in context's methods table
  	if(from in ctx.mt){
  	  	
  		if(! (from in mm)) {
  			//define a simple name for current method
  			//if it doesnt already exists
  			mm[from] = "M" + "<size(mm) + 1>"; 
  		}
    
    	//visit the current method body, searching for invoke expressions
	  	top-down visit(ctx.mt[from].method.body) {	 	
	  		case InvokeExp e:{
	  			tuple[CG c, MethodMap m, list[MethodSignature] ms] t = compute(from, e, methods, cg, mm, ctx);
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
private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, specialInvoke(_, ms, _), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx){
	return compute(from, ms, methods, cg, mm, ctx);
}

//virtualInvoke
private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, virtualInvoke(_, ms, _), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx){
	return compute(from, ms, methods, cg, mm, ctx);
}

//interfaceInvoke
private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, interfaceInvoke(_, ms, _), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx){
	return compute(from, ms, methods, cg, mm, ctx);
}

//staticMethodInvoke
private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, staticMethodInvoke(ms, _), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx){
	return compute(from, ms, methods, cg, mm, ctx);
	//TODO: infinite loop when testing SLF4J
	//return <cg,mm,methods>;
}

//dynamicInvoke
private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, dynamicInvoke(_,_,_,_), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx){
	//TODO implement dynamicInvoke
	return <cg,mm,methods>;
}

private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, methodSignature(cn, r, mn, args), list[MethodSignature] methods, CG cg, MethodMap mm, ExecutionContext ctx) {	
	to = signature(cn,mn,args); 
	//println("\ncomputeCallGraph .... <method>");
	//println("\tsig1="+from);
	//println("\t\tsig2_static="+to);	
	if(! (to in mm)) {
		mm[to] = "M" + "<size(mm) + 1>"; 
	}
	//define the new relation <from, to>
	newRelation = <mm[from], mm[to]>;
	//the relation already exists in the call graph?
	//this will be used later to avoid cycles
	alreadyExists = newRelation in cg;
	//insert the new relation in the call graph
	cg = cg + newRelation;   
	//do not follow external methods (not declared in the context)
	if(to in ctx.mt){
		//TODO update when decompiler replaces '/' for '.'
		sig = methodSignature(replaceAll(cn, "/", "."), r, mn, args);
  		if( !(sig in methods) && !alreadyExists){
  			//if method exists in the context add it to methods list, to be treated
  			//don't add the method if the relation already exists, to avoid cycles
  			methods = methods + sig;
  		}
	}
	return <cg,mm,methods>;
}


public void main(){
	files = [|project://JimpleFramework/target/test-classes/samples/callgraph/simple/SimpleCallGraph.class|];
    es = ["samples.callgraph.simple.SimpleCallGraph.A()"];
    //CGModel model = execute(files, es, Analysis(executar(full())));
    CGModel model = execute(files, es, Analysis(executar(context())));
    //CGModel model = execute(files, es, Analysis(executar(given(["samples.callgraph.simple.SimpleCallGraph.B()","samples.callgraph.simple.SimpleCallGraph.C()"]))));
    //TODO nao esta funcionando::::CGModel model = execute(files, es, Analysis(executar(publicMethods())));
    //CGModel model = execute(files, es, Analysis(executar(j2se())));
    
    CG cg = model.cg;
    mm = invertUnique(model.methodMap);
    
    //render(toFigure(cg));
    render(toFigure(cg,mm));   
}

