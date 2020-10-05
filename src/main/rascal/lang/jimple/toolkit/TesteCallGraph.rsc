module lang::jimple::toolkit::TesteCallGraph

import IO;
import Map;
import Type;
import Set;
import List;
import String;
import analysis::graphs::Graph;
import vis::Render;

import lang::jimple::core::Context; 
import lang::jimple::Syntax; 
import lang::jimple::toolkit::GraphUtil;

//TODO redefinir nomes das estrategias ...
data EntryPointsStrategy = full() 
						| context() 
						| given(list[str] methods) 
						| publicMethods() 
						| j2se();
						
data CallGraphType = RA()
					| CHA()
					| RTA();						

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

//hierarchy type's graph
alias HT = rel[str from, str to];

//data used at runtime
data CallGraphRuntime = callGraphRuntime(ExecutionContext ctx, CallGraphType cgType, EntryPointsStrategy strategy, HT ht);

/* 
 * The CGModel (call-graph model) is an algebraic 
 * data type with two components: a CG and a MethodMap. 
 */ 
data CGModel = CGModel(CG cg, MethodMap methodMap);

/* the empty call graph model */ 
CGModel emptyModel = CGModel({}, ()); 						
			
						
public &T(ExecutionContext) executar(EntryPointsStrategy strategy, CallGraphType cgType){
	return CGModel(ExecutionContext ctx) { 
        return computeCallGraph(ctx, strategy, cgType);
    }; 
}			

/* Computes a call graph from an execution 
 * context, starting from the entry points 
 * passed as parameter.
 *
 */ 
CGModel computeCallGraph(ExecutionContext ctx, EntryPointsStrategy strategy, CallGraphType cgType) {
	methods = selectEntryPoints(ctx, strategy);
	rt = callGraphRuntime(ctx, cgType, strategy, createHT(ctx));
	return computeCallGraph(methods, emptyModel, rt);
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





/* 
 * Computes the call graph for a specific method. 
 * This is a recursive implementation, using the 
 * second argument as an acummulator.  
 */
private CGModel computeCallGraph([], CGModel model, _) = model;
private CGModel computeCallGraph(list[MethodSignature] methods, CGModel model, CallGraphRuntime rt) {
	MethodSignature currentMethod = head(methods);
  	
  	mm = model.methodMap; 
  	cg = model.cg; 
  
  	str from = signature(currentMethod.className, currentMethod.methodName, currentMethod.formals);  
  	
  	//do not follow external methods
  	//if current method exists in context's methods table
  	if(from in rt.ctx.mt){
  	  	
  		if(! (from in mm)) {
  			//define a simple name for current method
  			//if it doesnt already exists
  			mm[from] = "M" + "<size(mm) + 1>"; 
  		}
    
    	println("\nFROM=<from> ...... <rt.ctx.mt[from]>");
    	//visit the current method body, searching for invoke expressions
	  	top-down visit(rt.ctx.mt[from].method.body) {	 	
	  		case InvokeExp e:{
	  			tuple[CG c, MethodMap m, list[MethodSignature] ms] t = compute(from, e, methods, cg, mm, rt);
	      		cg = t.c;
	      		mm = t.m;
	      		methods = t.ms;	  
	  		}  			  		
	  	}
  	}
  	
  	//recursive call to deal with the rest (tail) of the methods
  	return computeCallGraph(tail(methods), CGModel(cg, mm), rt);
}

//specialInvoke
private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, specialInvoke(_, ms, _), list[MethodSignature] methods, CG cg, MethodMap mm, CallGraphRuntime rt){
	return compute(from, ms, methods, cg, mm, rt);
}

//virtualInvoke
private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, virtualInvoke(_, ms, _), list[MethodSignature] methods, CG cg, MethodMap mm, CallGraphRuntime rt){
	return compute(from, ms, methods, cg, mm, rt);
}

//interfaceInvoke
private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, interfaceInvoke(_, ms, _), list[MethodSignature] methods, CG cg, MethodMap mm, CallGraphRuntime rt){
	return compute(from, ms, methods, cg, mm, rt);
}

//staticMethodInvoke
private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, staticMethodInvoke(ms, _), list[MethodSignature] methods, CG cg, MethodMap mm, CallGraphRuntime rt){
	return compute(from, ms, methods, cg, mm, rt);
}

//dynamicInvoke
private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, dynamicInvoke(_,_,_,_), list[MethodSignature] methods, CG cg, MethodMap mm, CallGraphRuntime rt){
	//TODO implement dynamicInvoke
	return <cg,mm,methods>;
}

private tuple[CG, MethodMap, list[MethodSignature]] compute(str from, methodSignature(cn, r, mn, args), list[MethodSignature] methods, CG cg, MethodMap mm, CallGraphRuntime rt) {	
	to = signature(cn,mn,args); 
	println("\ncomputeCallGraph .... <method>");
	println("\tfrom="+from);
	println("\tfrom_head=<head(methods)>");
	println("\t\tto="+to);	
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
	if(to in rt.ctx.mt){
		//TODO update when decompiler replaces '/' for '.'
		sig = methodSignature(replaceAll(cn, "/", "."), r, mn, args);		
		//if method exists in the context add it to methods list, to be treated
  		//don't add the method if the relation already exists, to avoid cycles
  		if( !(sig in methods) && !alreadyExists){  			
  			methods = methods + sig;
  		}
  		
  		//TODO refatorar ....................
		//compute additional classes (hierarchy)
		//TODO nao eh a assinatura do 'to' ... eh do 'from'
		println("\t\t\thead=<head(methods)> ................. type=<typeOf(head(methods))>");
		hierarchyMethods = computeClasses(head(methods), rt);
		println("\t\t\thierarchyMethods=<hierarchyMethods>");
		for(hm <- hierarchyMethods){
			println("\t\t\t\thm=<hm>");
			if(! (hm in mm)) {
				mm[hm] = "M" + "<size(mm) + 1>"; 
			}
			cg = cg + <mm[from], mm[hm]>;
		}
  		
	}
	return <cg,mm,methods>;
}

private list[str] computeClasses(MethodSignature ms, callGraphRuntime(_,RA(),_,_)){
	println("RA()");
	return [];
}
private list[str] computeClasses(methodSignature(cn, r, mn, args), rt: callGraphRuntime(ctx,CHA(),_,ht)){
	println("CHA()");
	methodsList = [];
	println("CHA().1");
	classList = hierarchy_types(ht, cn);
	println("CHA().2");
	classList = classList - cn;
	println("CHA().3=<classList>");
	for(c <- classList){
		println("CHA().4=<c> .... <mn>(<intercalate(",", args)>)");
		m = signature(c,mn,args);
		//m = "<c>.<mn>(<intercalate(",", args)>)";
		println("CHA().5=<m>");
		//TODO verificar se o metodo existe no contexto???
		//if(method in ctx.mt){
			methodsList = methodsList + signature(c,mn,args);
			println("CHA().6=<methodsList>");
		//}
	}
	println("CHA().7=<methodsList>");
	return methodsList;
}
private list[str] computeClasses(ms: methodSignature(cn, r, mn, args), rt: callGraphRuntime(ctx,RTA(),_,ht)){
	//TODO implement
	return [];
}


private HT createHT(ExecutionContext ctx){
	HT ht = {};
	
	top-down visit(ctx) {
     	case classDecl(TObject(t), _, TObject(superClass), interfaces, _, _ ): {
     		ht = ht + <superClass, t>;     		
     		names = [name | TObject(name) <- interfaces];
     		for(n <- names){
     			ht = ht + <n, t>;	
     		}
     	}  
     	case interfaceDecl(TObject(t), _, interfaces, _, _ ): {
     		names = [name | TObject(name) <- interfaces];
     		for(n <- names){
     			ht = ht + <n, t>;	
     		}
     	} 
	}
	
	return ht;
}

private list[str] hierarchy_types(HT ht, str name) {
	hierarquia = [name];
	
	types = successors(ht,name);
	for(t <- types){
		hierarquia = hierarquia + hierarchy_types(ht, t);
	}

	return hierarquia;
}

public void testePolimorfismo(){
	//polymorphism
    files = findClassFiles(|project://JimpleFramework/target/test-classes/samples/callgraph/polymorphism|);
    es = ["samples.callgraph.polymorphism.Main.execute()"];
    
    //CGModel model = execute(files, es, Analysis(executar(full())));
    CGModel model = execute(files, es, Analysis(executar(context(), RA())));
    //CGModel model = execute(files, es, Analysis(executar(context(), CHA())));
    //CGModel model = execute(files, es, Analysis(executar(context(), RTA())));
    //CGModel model = execute(files, es, Analysis(executar(given(["samples.callgraph.simple.SimpleCallGraph.B()","samples.callgraph.simple.SimpleCallGraph.C()"]))));
    //TODO nao esta funcionando::::CGModel model = execute(files, es, Analysis(executar(publicMethods())));
    //CGModel model = execute(files, es, Analysis(executar(j2se())));
    
    CG cg = model.cg;
    mm = invertUnique(model.methodMap);
    
    //println(mm);
    
    mm = (simpleName : replaceAll(mm[simpleName],"samples.callgraph.polymorphism.","") | simpleName <- mm);
    
    //fruits = ("pear" : 1, "apple" : 3, "banana" : 0, "berry" : 25, "orange": 35);
	//(fruit : fruits[fruit] | fruit <- fruits, size(fruit) <= 5);
    //replaceAll("abracadabra", "a", "A");
    
    //render(toFigure(cg));
    render(toFigure(cg,mm));   
    
    println("DOT:");
    println(toDot(cg,mm));
}

public void main(){
	//simplegraph
	//files = [|project://JimpleFramework/target/test-classes/samples/callgraph/simple/SimpleCallGraph.class|];
    //es = ["samples.callgraph.simple.SimpleCallGraph.A()"];
    
    //polymorphism
    files = findClassFiles(|project://JimpleFramework/target/test-classes/samples/callgraph/polymorphism|);
    es = ["samples.callgraph.polymorphism.Main.execute()"];
    
    //CGModel model = execute(files, es, Analysis(executar(full())));
    //CGModel model = execute(files, es, Analysis(executar(context(), RA())));
    CGModel model = execute(files, es, Analysis(executar(context(), CHA())));
    //CGModel model = execute(files, es, Analysis(executar(context(), RTA())));
    //CGModel model = execute(files, es, Analysis(executar(given(["samples.callgraph.simple.SimpleCallGraph.B()","samples.callgraph.simple.SimpleCallGraph.C()"]))));
    //TODO nao esta funcionando::::CGModel model = execute(files, es, Analysis(executar(publicMethods())));
    //CGModel model = execute(files, es, Analysis(executar(j2se())));
    
    CG cg = model.cg;
    mm = invertUnique(model.methodMap);
    
    //render(toFigure(cg));
    render(toFigure(cg,mm));   
    
    println("DOT:");
    println(toDot(cg,mm));
}

