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

//TODO redefinir nomes ...
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

//hierarchy class/type's graph
alias HT = rel[str parent, str child];

//data used at runtime
data CallGraphRuntime = callGraphRuntime(ExecutionContext ctx, CallGraphType cgType, EntryPointsStrategy strategy, HT ht);

/* 
 * The CGModel (call-graph model) is an algebraic 
 * data type with two components: a CG and a MethodMap. 
 */ 
data CGModel = CGModel(CG cg, MethodMap methodMap);


						
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
	println("strategy=<strategy>");
	methods = selectEntryPoints(ctx, strategy);
	println("entrypoints=<methods>");
	rt = callGraphRuntime(ctx, cgType, strategy, createHT(ctx));
	return computeCallGraphNovo(methods, rt);
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



private CGModel computeCallGraphNovo(list[MethodSignature] methodsList, CallGraphRuntime rt) {
	mm = (); 
  	cg = {}; 
	
	while(!isEmpty(methodsList)){		
		MethodSignature currentMethod = head(methodsList);
		methodsList = drop(1,methodsList);	
		//MethodSignature currentMethod = head(1,methodsList);
		//delete(1,methodsList,currentMethod);
		
		str from = signature(currentMethod.className, currentMethod.methodName, currentMethod.formals);  

	  	if(from in rt.ctx.mt){	  	  		  	
	  		if(! (from in mm)) {
	  			mm[from] = "M" + "<size(mm) + 1>"; 
	  		}
	    
	    	invokedMethods = getInvokedMethods(from, rt);
	    	for(methodSignature(cn, r, mn, args) <- invokedMethods){
	    		to = signature(cn,mn,args); 
	    		if(! (to in mm)) {
					mm[to] = "M" + "<size(mm) + 1>"; 
				}
				newRelation = <mm[from], mm[to]>;
				alreadyExists = newRelation in cg;
				cg = cg + newRelation;  
				
				if(to in rt.ctx.mt){
					//TODO update when decompiler replaces '/' for '.'
					sig = methodSignature(replaceAll(cn, "/", "."), r, mn, args);
					//TODO rever .....							
			  		if( !(sig in methodsList) && !alreadyExists){// && (!(to in mm))){  			
			  			methodsList = methodsList + sig;
			  		}
	
					//TODO nao eh a assinatura do 'to' ... eh do 'from'
					hierarchyMethods = computeClasses(sig, rt);
					println("\t\t\thierarchyMethods=<hierarchyMethods>");
					for(hm <- hierarchyMethods){
						println("\t\t\t\thm=<hm>");
						if(! (hm in mm)) {
							mm[hm] = "M" + "<size(mm) + 1>"; 
						}
						cg = cg + <mm[from], mm[hm]>;
					}			  	
				} 
	    	}
	  	}		
	}

	return CGModel(cg, mm);
}


private list[MethodSignature] getInvokedMethods(str from, CallGraphRuntime rt){
	methods = [];
	top-down visit(rt.ctx.mt[from].method.body) {	 	
  		case InvokeExp e:{
  			methods = methods + getMethodSignature(e);
  		}  			  		
  	}
  	return methods;
}
private MethodSignature getMethodSignature(specialInvoke(_, ms, _)) { return ms; }
private MethodSignature getMethodSignature(virtualInvoke(_, ms, _)) { return ms; }
private MethodSignature getMethodSignature(interfaceInvoke(_, ms, _)) { return ms; }
private MethodSignature getMethodSignature(staticMethodInvoke(ms, _)) { return ms; }
private MethodSignature getMethodSignature(dynamicInvoke(_,_,ms,_)) { return ms; }



private list[str] computeClasses(MethodSignature ms, callGraphRuntime(_,RA(),_,_)){
	println("RA()");
	return [];
}
private list[str] computeClasses(methodSignature(cn, r, mn, args), rt: callGraphRuntime(ctx,CHA(),_,ht)){
	methodsList = [];
	classList = hierarchy_types(ht, cn);
	classList = classList - cn;
	for(c <- classList){
		m = signature(c,mn,args);
		//TODO verificar se o metodo existe no contexto???
		//if(method in ctx.mt){
			methodsList = methodsList + signature(c,mn,args);
			//println("CHA().6=<methodsList>");
		//}
	}
	return methodsList;
}
private list[str] computeClasses(ms: methodSignature(cn, r, mn, args), rt: callGraphRuntime(ctx,RTA(),_,ht)){
	//TODO implement RTA: hierarchy_types - instantiated_types
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
    //es = ["samples.callgraph.polymorphism.Main.execute2()"];
    es = ["samples.callgraph.polymorphism.Main.execute(TObject(\"samples.callgraph.polymorphism.service.factory.ServiceFactory\"))"];
    //es = ["samples.callgraph.polymorphism.Main.execute3(TObject(\"samples.callgraph.polymorphism.service.factory.ServiceFactory\"))"];
    
    //CGModel model = execute(files, es, Analysis(executar(full())));
    //CGModel model = execute(files, es, Analysis(executar(context(), RA())));
    CGModel model = execute(files, es, Analysis(executar(context(), CHA())));
    //CGModel model = execute(files, es, Analysis(executar(context(), RTA())));
    //CGModel model = execute(files, es, Analysis(executar(given(["samples.callgraph.simple.SimpleCallGraph.B()","samples.callgraph.simple.SimpleCallGraph.C()"]))));
    //TODO nao esta funcionando::::CGModel model = execute(files, es, Analysis(executar(publicMethods())));
    //CGModel model = execute(files, es, Analysis(executar(j2se())));
    
    CG cg = model.cg;
    mm = invertUnique(model.methodMap);

    mm = (simpleName : replaceAll(mm[simpleName],"samples.callgraph.polymorphism.","s.c.p.") | simpleName <- mm);

    //render(toFigure(cg));
    render(toFigure(cg,mm));   
    
    println("DOT:");
    println(toDot(cg,mm));
}
