module lang::jimple::analysis::svfa::SparseValueFlowAnalysis


import lang::jimple::core::Context; 
import lang::jimple::core::Syntax; 
import lang::jimple::analysis::dataflow::Framework;
import lang::jimple::analysis::dataflow::ReachDefinition;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::toolkit::ValueFlowGraph;
import lang::jimple::util::Converters; 
import lang::jimple::util::JPrettyPrinter;

import List;
import IO;
import Type;

data SVFAModel = SVFAModel(ValueFlowGraph cg);

data SVFARuntime = svfaRuntime(ExecutionContext ctx, ValueFlowNodeType (Statement) analyze);


public &T(ExecutionContext) generateSVFGraph(list[str] entrypoints, ValueFlowNodeType (Statement) analyze ){
	return SVFAModel(ExecutionContext ctx) { 		
        return computeSVFGraph(ctx, entrypoints, analyze);
    }; 
}




SVFAModel computeSVFGraph(ExecutionContext ctx, list[str] entrypoints, ValueFlowNodeType (Statement) analyze) {	
	println("entrou .....");
	
	list[MethodSignature] methods = []; 		
	 
	// nao usa os entrypoints passados como parametro ainda ... apenas os definidos no ExecutionContext
	top-down visit(ctx) {
     	case classDecl(TObject(cn), _, _, _, _, mss): {
         	for(m: method(_,r,mn,args,_,_) <- mss) {
         		sig = signature(cn, mn, args); 
         		// if the method is an entry point (depending on the strategy specified)         		
         		if(ctx.mt[sig].entryPoint) {
         			// add method to the entry points list
         			methods = methods + methodSignature(cn, r, mn, args);
         		}
            }             
      	}
  	} 

	SVFARuntime rt = svfaRuntime(ctx, analyze);
	
	return computeSVFGraph(methods, rt);
}

private SVFAModel computeSVFGraph(list[MethodSignature] methodsList, SVFARuntime rt) {
	println("computeSVFGraph");
		
	while(!isEmpty(methodsList)){	
		MethodSignature currentMethod = head(methodsList);
		methodsList = drop(1,methodsList);	
		
		traverse(currentMethod, rt);
	}
	
	return SVFAModel({});
}

private void traverse(method: methodSignature(Name className, _, Name methodName, list[Type] formals), SVFARuntime rt) {
	str currentMethod = signature(className, methodName, formals);
	//println("\n\ncurrentMethod=<currentMethod>");	
	//println(prettyPrint(rt.ctx.mt[currentMethod].method));	
	
	if(currentMethod in rt.ctx.mt){
		MethodBody b = rt.ctx.mt[currentMethod].method.body;
		
		top-down visit(b.stmts) {	 	
	  		case a: assign(Variable var, Expression expression): {
	  			println("* ASSIGN ==== var=<var> ... expr=<expression>");
	  			traverse(a, method, rt);
	  		}  
	  		case i: invokeStmt(InvokeExp invokeExpression):{
	  			println("* INVOKE ==== <invokeExpression>");
	  			traverse(i, method, rt);
	  			//TODO adicionar o metodo q eh chamado na lista de metodos
	  		}	
	  		//TODO
	  		//case _ if(analyze(unit) == SinkNode) => traverseSinkStatement(v, method, defs)
	    	//case _ =>	  		
		}
	} else{
		println("*** Don\'t visit foreign method: <currentMethod>");
	}	
	
}
//private void traverse(stmt: assign(_, a: newArray(Type baseType, list[ArrayDescriptor] dims)), MethodSignature method, SVFARuntime rt){
//	println("\tnewArray= <a>");		
//}
private void traverse(stmt: assign(_, immediate(Immediate i)), MethodSignature method, SVFARuntime rt){
	println("\timmediate= <i>");	
	copyRule(i, stmt, method, rt);
}
private void traverse(stmt: assign(_, invokeExp(expr)), MethodSignature method, SVFARuntime rt){
	println("\tinvokeExpr <expr>");
	traverse(invokeStmt(expr), method, rt);
}
private void traverse(stmt: assign(_, e: localFieldRef(Name local, _, _, _)), MethodSignature method, SVFARuntime rt){
	println("\tlocalFieldRef= <local>");	
	loadRule(e, stmt, method, rt);
}
private void traverse(stmt: assign(_, e: fieldRef(Name className, _, _)), MethodSignature method, SVFARuntime rt){
	println("\tfieldRef= <className>");	
	loadRule(e, stmt, method, rt);
}
private void traverse(stmt: assign(_, Expression expression), MethodSignature method, SVFARuntime rt) {
	switch(expression){		
		case arraySubscript(n, i):        println("\tarraySubscript <n>");
		case stringSubscript(n, i):       println("\tstringSubscript <n>");
		case newArray(t, _):              println("\tnewArray <t>");
		case newInstance(t):              println("\tnewInstance <t>");
		default: println("\t***** DEFAULT=<expression>");
	}
}

private void traverse(stmt: invokeStmt(_), MethodSignature method, SVFARuntime rt) = invokeRule(stmt, method, rt);

private void traverse(Statement stmt, MethodSignature method, SVFARuntime rt){
	if(sinkNode() == rt.analyze(stmt)){
		traverseSinkStatement();
	}
}

private void traverse(specialInvoke(_, MethodSignature sig, _), SVFARuntime rt) = traverse(sig, rt);
private void traverse(virtualInvoke(_, MethodSignature sig, _), SVFARuntime rt) = traverse(sig, rt);
private void traverse(interfaceInvoke(_, MethodSignature sig, _), SVFARuntime rt) = traverse(sig, rt);
private void traverse(staticMethodInvoke(MethodSignature sig, _), SVFARuntime rt) = traverse(sig, rt);
//TODO dynamicInvoke


private void traverseSinkStatement(){
	println("\t **** traverseSinkStatement ...");
}



private void copyRule(l: local(String var), Statement targetStmt, MethodSignature method, SVFARuntime rt){
	println("\t\t **** COPY_RULE ...");
	
	str sig = signature(method.className, method.methodName, method.formals);
	MethodBody b = rt.ctx.mt[sig].method.body;

	for(sourceStmt <- getDefsOfAt(l, targetStmt, b)){
		source = createNode(method, sourceStmt, rt);
      	target = createNode(method, targetStmt, rt);
      	println("\t\t ****** COPY_RULE: <source.stmt> TO <target.stmt>");
	}
}

private void copyRule(l: iValue(Value v), Statement targetStmt, MethodSignature method, SVFARuntime rt){
	println("\t\t **** COPY_RULE ... iValue");	
}

private void loadRule(e: localFieldRef(Name local, Name className, TString(), Name fieldName), Statement targetStmt, MethodSignature method, SVFARuntime rt){	
	println("\t\t **** LOAD_RULE ... instance field STRING");
}

private void loadRule(e: localFieldRef(_, _, _, _), Statement targetStmt, MethodSignature method, SVFARuntime rt){	
	println("\t\t **** LOAD_RULE ... instance field DEFAULT");
}

private void loadRule(Expression expression, Statement targetStmt, MethodSignature method, SVFARuntime rt){	
	println("\t\t **** LOAD_RULE ...");
}

private void invokeRule(stmt: invokeStmt(InvokeExp expr), MethodSignature method, SVFARuntime rt){
	println("\t\t **** INVOKE_RULE ...");
	switch(rt.analyze(stmt)){
		case sourceNode(): {
			println("\t\t ******* sourceNode");
			source = createNode(method, stmt, rt);
			//TODO add node to graph
		}
		case sinkNode(): defsToCallOfSinkMethod(stmt, method);
		case simpleNode(): println("\t\t ******* simpleNode");
		case callSiteNode(): println("\t\t ******* callSiteNode");
		default: println("********* ERROR *********");
	}
	
	//TODO terminar logica
	
	//visit callee method
	println("\t\t ********* visiting: <expr>");
	traverse(expr, rt);	
}


private void defsToCallOfSinkMethod(stmt: invokeStmt(InvokeExp expr), MethodSignature method) {
	println("\t\t ******* sinkNode ... defsToCallOfSinkMethod");
}

private void defsToCallSite(){
	println("\t\t ******* defsToCallSite");
}

private void defsToThisObject(){
	println("\t\t ******* defsToThisObject");
}

private void defsToFormalArgs(){
	println("\t\t ******* defsToFormalArgs");
}




private ValueFlowNode createNode(MethodSignature method, Statement stmt, SVFARuntime rt) {	
	return valueFlowNode(method.className, method.methodName, stmt, rt.analyze(stmt));
}

private void createCSOpenLabel(){}

private void createCSCloseLabel(){}



//TODO implementar
// dummy impl
private list[Statement] getDefsOfAt(local(String l), a: assign(_, _), MethodBody methodBody) {
	AnalysisResult[Statement] reachDefs = execute(rd, methodBody);		
	return [def | def:assign(localVariable(v), _) <- reachDefs.inSet[stmtNode(a)], v == l];
}
private list[Statement] getDefsOfAt(Immediate local, Statement stmt, MethodBody methodBody) = [];



private list[ValueFlowNode] findAllocationSites() {
    return [];
}


