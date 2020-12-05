module lang::jimple::analysis::svfa::SparseValueFlowAnalysis


import lang::jimple::core::Context; 
import lang::jimple::core::Syntax; 
import lang::jimple::analysis::dataflow::Framework;
import lang::jimple::analysis::dataflow::ReachDefinition;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::toolkit::ValueFlowGraph;
import lang::jimple::toolkit::DefUse;
import lang::jimple::util::Converters; 
import lang::jimple::util::JPrettyPrinter;

import List;
import IO;


data SVFAModel = SVFAModel(ValueFlowGraph cg);

data SVFARuntime = svfaRuntime(ExecutionContext ctx, ValueFlowNodeType (Statement) analyze);
//map[LocalVariable, set[Definition]] localDefs = (); 


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

private void traverse(MethodSignature method, SVFARuntime rt) {
	str currentMethod = signature(method.className, method.methodName, method.formals);
	println("\n\ncurrentMethod=<currentMethod>");	
	//println(prettyPrint(rt.ctx.mt[currentMethod].method));	
	
	MethodBody b = rt.ctx.mt[currentMethod].method.body;
	//localDefs = loadDefinitions(b.stmts);
	
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
}
private void traverse(stmt: assign(_, immediate(Immediate i)), MethodSignature method, SVFARuntime rt){
	println("\timmediate= <i>");	
	copyRule(i, stmt, method, rt);
}
private void traverse(stmt: assign(_, invokeExp(expr)), MethodSignature method, SVFARuntime rt){
	println("\tinvokeExpr <expr>");
	traverse(invokeStmt(expr), method, rt);
}
private void traverse(stmt: assign(_, localFieldRef(Name local, _, _, _)), MethodSignature method, SVFARuntime rt){
	println("\tlocalFieldRef= <local>");	
	loadRule();
}
private void traverse(stmt: assign(_, fieldRef(Name className, _, _)), MethodSignature method, SVFARuntime rt){
	println("\tfieldRef= <className>");	
	loadRule();
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

private void traverseSinkStatement(){
	println("\t **** traverseSinkStatement ...");
}



private void copyRule(local(String var) , Statement targetStmt, MethodSignature method, SVFARuntime rt){
	println("\t\t **** COPY_RULE ...");
	
	str sig = signature(method.className, method.methodName, method.formals);
	MethodBody b = rt.ctx.mt[sig].method.body;
	map[LocalVariable var, DefUse def] defUses = createDefUse(b);
	//DefUse def = null;
	
	//for(sourceStmt <- getDefsOfAt(local, targetStmt, method, rt)){
	for(sourceStmt <- defUses[var].uses){
		source = createNode(method, sourceStmt, rt);
      	target = createNode(method, targetStmt, rt);
      	println("\t\t ****** COPY_RULE: <source> TO <target>");
	}
}

private void loadRule(){	
	println("\t\t **** LOAD_RULE ...");
}

private void invokeRule(stmt: invokeStmt(InvokeExp expr), MethodSignature method, SVFARuntime rt){
	println("\t\t **** INVOKE_RULE ...");
	switch(rt.analyze(stmt)){
		case sourceNode(): println("\t\t ******* sourceNode");
		case sinkNode(): println("\t\t ******* sinkNode");
		case simpleNode(): println("\t\t ******* simpleNode");
		case callSiteNode(): println("\t\t ******* callSiteNode");
		default: println("********* ERRO *********");
	}
}

private ValueFlowNode createNode(MethodSignature method, Statement stmt, SVFARuntime rt) {	
	return valueFlowNode(method.className, method.methodName, stmt, rt.analyze(stmt));
}


private void createCSOpenLabel(){}

private void createCSCloseLabel(){}


//TODO implementar
// dummy impl
private list[Statement] getDefsOfAt(local(String l), a: assign(Variable var, Expression expression), MethodSignature method, SVFARuntime rt) {
	println("getDefsOfAt(<l>, <a>)");
	list[Statement] retorno = [];
	str sig = signature(method.className, method.methodName, method.formals); 
	AnalysisResult[Statement] reachDefs = execute(rd, rt.ctx.mt[sig].method.body);
	//print(reachDefs);
	println("SERA? <reachDefs.inSet[stmtNode(a)]>");
	println("DEFS::: <local> == <retorno>");
	return retorno;
}

private void getDefs(AnalysisResult[Statement] reachDefs){

}


private map[LocalVariable, set[Definition]] loadDefinitions([]) = (); 

private map[LocalVariable, set[Definition]] loadDefinitions([assign(localVariable(v), e), *Statement SS]) = defs + (v : (assign(localVariable(v), e) + defs[v]))
  when defs := loadDefinitions(SS)
     , v in defs
     ;

private map[LocalVariable, set[Definition]] loadDefinitions([assign(localVariable(v), e), *Statement SS]) = defs + (v : { (assign(localVariable(v), e)) } )
  when defs := loadDefinitions(SS)
     , v notin defs
     ; 
           
private map[LocalVariable, set[Definition]] loadDefinitions([_, *Statement SS]) = defs
   when defs := loadDefinitions(SS)
      ;



private void print(AnalysisResult[&T] result){
	println("RESULT:");
	for(n <- result.inSet){
		println("NODE: <toString(n)>");
		println("\t IN: <tmp(result.inSet[n])>");
		if(n in result.outSet){
			//tmp(result.outSet[n]);
			//println("\t OUT: <result.outSet[n]>");
			println("\t OUT: <tmp(result.outSet[n])>");
		}
	}
}
private str toString(entryNode()) = "ENTRY";
private str toString(exitNode()) = "EXIT";
private str toString(s:stmtNode(_)) = prettyPrint(s.s);
private set[str] tmp(set[&T] conjunto){
	set[str] retorno = {};
	for(c <- conjunto){
		retorno = retorno + prettyPrint(c);
	}
	return retorno;
}

private list[Statement] getDefsOfAt(Immediate local, Statement stmt, MethodSignature method, SVFARuntime rt) = [];

private list[ValueFlowNode] findAllocationSites() {
    return [];
}

private bool useVariable(Expression e, str v) = local(v) in localReferences(e); 

private list[Immediate] localReferences(Expression e) = [local(v) | /local(v) <- e];


