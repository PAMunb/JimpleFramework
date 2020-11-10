module lang::jimple::toolkit::CallGraph

import lang::jimple::core::Context; 
import lang::jimple::core::Syntax; 
import lang::jimple::toolkit::GraphUtil;
import lang::jimple::util::Converters; 
import Map;
import Set;
import List;
import String;
import analysis::graphs::Graph;
import Exception;

//TODO remover qdo remover o metodo usado para teste (testePolimorfismo)
import Type;
import IO;
import vis::Render;

//TODO redefinir nomes ...
data EntryPointsStrategy = full() 
						| context() 
						| given(list[str] methods) 
						| publicMethods() 
						| j2se();

// the algorithm used to build the call graph
// - 
// - Class Hierarychy Analysis
// - Rapid Type Analysis				
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

//TODO criar modulo especifico para hierarquia de classes? sera usado em algum outro lugar?
//hierarchy class/type's graph
alias HT = rel[str parent, str child];

//data used at runtime
data CallGraphRuntime = callGraphRuntime(ExecutionContext ctx, CallGraphType cgType, EntryPointsStrategy strategy, HT ht);

/* 
 * The CGModel (call-graph model) is an algebraic 
 * data type with two components: a CG and a MethodMap. 
 */ 
data CGModel = CGModel(CG cg, MethodMap methodMap);




/*
 * Method used to create the call graph. Receives:
 * - the entry points selection strategy
 * - the algorithm to be used to generate the call graph 
 */						
public &T(ExecutionContext) generateCallGraph(EntryPointsStrategy strategy, CallGraphType cgType){
	return CGModel(ExecutionContext ctx) { 
        return computeCallGraph(ctx, strategy, cgType);
    }; 
}			



/* 
 * Computes a call graph from an execution 
 * context, starting from the entry points 
 * passed as parameter.
 */ 
CGModel computeCallGraph(ExecutionContext ctx, EntryPointsStrategy strategy, CallGraphType cgType) {
	// select the entry points
	entrypoints = selectEntryPoints(ctx, strategy);
	// init the parameters to be used at runtime (generation time)
	rt = callGraphRuntime(ctx, cgType, strategy, createHT(ctx));
	// generate and return the call graph
	return computeCallGraph(entrypoints, rt);
}			

/*
 * Returns the entry points list based on the "given methods" strategy
 */
private list[MethodSignature] selectEntryPoints(ExecutionContext ctx, given(list[str] givenMethods)) {
	list[MethodSignature] methods = []; 
		
	for(m <- givenMethods){
		if(m in ctx.mt){
			methods = methods + toMethodSignature(m,ctx);
		}
	}
	
  	return methods;
}
/*
 * Returns the entry points list based on the defined strategy
 */
private list[MethodSignature] selectEntryPoints(ExecutionContext ctx, EntryPointsStrategy strategy) {
	list[MethodSignature] methods = []; 
		
	//visit all methods of all classes
	top-down visit(ctx) {
     	case classDecl(TObject(cn), _, _, _, _, mss): {
         	for(m: method(_,r,mn,args,_,_) <- mss) {
         		// if the method is an entry point (depending on the strategy specified)         		
         		if(isEntryPoint(cn, m, ctx, strategy)) {
         			// add method to the entry points list
         			methods = methods + methodSignature(cn, r, mn, args);
         		}
            }             
      	}
  	} 
  	
  	return methods;
}


/*
 * Returns if a method (identified by a method name and class name) is a
 * entrypoint based on the chosen entrypoint strategy.
 */
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
 * Computes a call graph from runtime parameters, 
 * starting from the entry points list.
 */ 
private CGModel computeCallGraph(list[MethodSignature] methodsList, CallGraphRuntime rt) {
	map[str, str] mm = (); 
  	rel[str from, str to] cg = {};
		
	// as long as there are methods to be visited
	while(!isEmpty(methodsList)){		
		//TODO rever isso: um pop() resolveria com um comando apenas?	 	
		MethodSignature currentMethod = head(methodsList);
		methodsList = drop(1,methodsList);	
		
		str from = signature(currentMethod.className, currentMethod.methodName, currentMethod.formals);  

	  	if(from in rt.ctx.mt){	  	  		  	
	  		if(! (from in mm)) {
	  			//define a simple name for current method
  				//if it doesnt already exists
	  			mm[from] = "M" + "<size(mm) + 1>"; 
	  		}
	    
	    	invokedMethods = getInvokedMethods(from, rt);
	    	
	    	for(methodSignature(cn, r, mn, args) <- invokedMethods){
	    		str to = signature(cn,mn,args); 
	    		if(! (to in mm)) {
	    			//TODO fazer sem concat
					mm[to] = "M" + "<size(mm) + 1>"; 
				}
				
				newRelation = <mm[from], mm[to]>;
				alreadyExists = newRelation in cg;
				cg = cg + newRelation;
				
				if(to in rt.ctx.mt){
					//TODO update when decompiler replaces '/' for '.'
					sig = methodSignature(replaceAll(cn, "/", "."), r, mn, args);
					
			  		if( !(sig in methodsList) && !alreadyExists){			
			  			methodsList = methodsList + sig;
			  		}
					
					hierarchyMethods = computeClasses(sig, rt);
					for(hm <- hierarchyMethods){
						if(! (hm in mm)) {
							//TODO fazer sem concat
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
	//visit the method body, searching for invoke expressions
	//and add each method signature to the list of methods called 
	//from the method received as parameter (from) 
	top-down visit(rt.ctx.mt[from].method.body) {	 	
  		case InvokeExp e:{
  			methods = methods + getMethodSignature(e);
  		}  			  		
  	}
  	return methods;
}

/*
 * Retrieves the method signature from the method invocation info.
 */
private MethodSignature getMethodSignature(specialInvoke(_, ms, _)) = ms; 
private MethodSignature getMethodSignature(virtualInvoke(_, ms, _)) = ms; 
private MethodSignature getMethodSignature(interfaceInvoke(_, ms, _)) = ms;
private MethodSignature getMethodSignature(staticMethodInvoke(ms, _)) = ms; 
//TODO verificar se eh o segundo methodSignature mesmo (acho q o primeiro eh o bootstrap method)
private MethodSignature getMethodSignature(dynamicInvoke(_,_,ms,_)) = ms; 

private list[str] computeClasses(MethodSignature ms, callGraphRuntime(_,RA(),_,_)) = [];
private list[str] computeClasses(methodSignature(cn, r, mn, args), rt: callGraphRuntime(ctx,CHA(),_,ht)){
	methodsList = [];	
	classList = hierarchy_types(ht, cn);
	//removes the class (cn) because it has already been handled
	classList = classList - cn;
	
	for(c <- classList){
		m = signature(c,mn,args);
		//TODO verificar se o metodo existe no contexto???
		//if(method in ctx.mt){
			methodsList = methodsList + signature(c,mn,args);
		//}
	}
	return methodsList;
}
private list[str] computeClasses(ms: methodSignature(cn, r, mn, args), rt: callGraphRuntime(ctx, RTA(), _, ht)) {
	methodsList = [];
	classList = hierarchy_types(ht, cn);
	
	for (c <- classList) {
		instanciations = getProgramInstanciations(ctx);
		print("instances: ");
		println(instanciations);
		if (TObject(c) in instanciations) {
			methodsList = methodsList + signature(c, mn, args);
		}
	}
	
	print("methodList: ");
	println(methodsList);
	return methodsList;
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

//TODO rever a questao de performance:
// - do jeito atual em toda chamada vai gastar O(log n) +-
// - criar um mapa global no modulo: mapa = (k.parent : hierarchy_types(ht,k.parent) | k <- ht); ... mas assim chamaria o hierarchy_types zilhoes de vezes
// - criar o mapa dinamicamente ... o mapa seria global mas seria criada uma entrada sob demanda ... tipo memoizacao
// - ver o uso de @memo ... como funciona isso?
private list[str] hierarchy_types(HT ht, str name) {
	hierarquia = [name];
	
	types = successors(ht,name);
	for(t <- types){
		hierarquia = hierarquia + hierarchy_types(ht, t);
	}

	return hierarquia;
}



//TODO mover para algum local???
public str getClassName(str methodSignature) {
	if(contains(methodSignature,"(") && contains(methodSignature,".")){
		untilMethodName = substring(methodSignature,0,findFirst(methodSignature,"("));	
		return substring(untilMethodName,0,findLast(untilMethodName,"."));
	}
	return "";
}
public MethodSignature toMethodSignature(str ms, ExecutionContext ctx) {
	Name className = getClassName(ms);
	if(className != ""){
		m = ctx.mt[ms].method;		
		return methodSignature(className, m.returnType, m.name, m.formals);
	}
	throw IllegalArgument(methodSignature, "The method does not exist in the execution context.");
}

private list[Type] getProgramInstanciations(ExecutionContext ctx) {
	instanciations = [];
	top-down visit(ctx) {
		case newInstance(Type instanceType): {
			instanciations = instanciations	+ instanceType;
		}
	}
	return instanciations;
}


//TODO remover metodos abaixo
public void testePolimorfismo(){
	//polymorphism
    files = findClassFiles(|project://JimpleFramework/target/test-classes/samples/callgraph/polymorphism|);
    //es = ["samples.callgraph.polymorphism.Main.execute2()"];
    es = ["samples.callgraph.polymorphism.Main.execute(TObject(\"samples.callgraph.polymorphism.service.factory.ServiceFactory\"))"];
    //es = ["samples.callgraph.polymorphism.Main.execute3(TObject(\"samples.callgraph.polymorphism.service.factory.ServiceFactory\"))"];
    
    //CGModel model = execute(files, es, Analysis(generateCallGraph(full())));
    CGModel model = execute(files, es, Analysis(generateCallGraph(context(), RA())));
    //CGModel model = execute(files, es, Analysis(generateCallGraph(context(), CHA())));
    //CGModel model = execute(files, es, Analysis(generateCallGraph(context(), RTA())));
    //CGModel model = execute(files, es, Analysis(generateCallGraph(given(["samples.callgraph.simple.SimpleCallGraph.B()","samples.callgraph.simple.SimpleCallGraph.C()"]))));
    //TODO nao esta funcionando::::CGModel model = execute(files, es, Analysis(generateCallGraph(publicMethods())));
    //CGModel model = execute(files, es, Analysis(generateCallGraph(j2se())));
    
    CG cg = model.cg;
    mm = invertUnique(model.methodMap);

    mm = (simpleName : replaceAll(mm[simpleName],"samples.callgraph.polymorphism.","s.c.p.") | simpleName <- mm);

    //render(toFigure(cg));
    //render(toFigure(cg,mm));   
    
    //println("DOT:");
    //println(toDot(cg,mm));
}

public void testeNomeClasse(){
	//nome = "samples.callgraph.simple.SimpleCallGraph.A()";
	nome = "samples.callgraph.simple.SimpleCallGraph.log(TObject(\"java.lang.String\"))";
	
	
	untilMethodName = substring(nome,0,findFirst(nome,"("));
	
	println(substring(untilMethodName,0,findLast(untilMethodName,".")));
}