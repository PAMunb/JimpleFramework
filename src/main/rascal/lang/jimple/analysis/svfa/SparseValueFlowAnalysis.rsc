module lang::jimple::analysis::svfa::SparseValueFlowAnalysis


import lang::jimple::core::Context; 
import lang::jimple::core::Syntax; 
import lang::jimple::toolkit::ValueFlowGraph;
import lang::jimple::util::Converters; 

import List;
import IO;


data SVFAModel = SVFAModel(ValueFlowGraph cg);

data SVFARuntime = svfaRuntime(ExecutionContext ctx);

public &T(ExecutionContext) generateSVFGraph(list[str] entrypoints){
	return SVFAModel(ExecutionContext ctx) { 
		println("cts");
        return computeSVFGraph(ctx, entrypoints);
    }; 
}

SVFAModel computeSVFGraph(ExecutionContext ctx, list[str] entrypoints) {	
	println("entrou .....");
	
	list[MethodSignature] methods = []; 		
	//for(m <- entrypoints){
	//	if(m in ctx.mt && ctx.mt[m].entryPoint){
	//		methods = methods + toMethodSignature(m,ctx);
	//	}
	//}	  
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

	SVFARuntime rt = svfaRuntime(ctx);
	
	return computeSVFGraph(methods, rt);
}

private SVFAModel computeSVFGraph(list[MethodSignature] methodsList, SVFARuntime rt) {
	println("aaaa");
		
	while(!isEmpty(methodsList)){	
		MethodSignature currentMethodSig = head(methodsList);
		methodsList = drop(1,methodsList);	
		
		str currentMethod = signature(currentMethodSig.className, currentMethodSig.methodName, currentMethodSig.formals);
		println("currentMethod=<currentMethod>");
		
		top-down visit(rt.ctx.mt[currentMethod].method.body.stmts) {	 	
	  		case a: assign(Variable var, Expression expression): {
	  			println("* ASSIGN ==== var=<var> ... expr=<expression>");
	  			traverse(a);
	  		}  
	  		case i: invokeStmt(InvokeExp invokeExpression):{
	  			println("* INVOKE ==== <invokeExpression>");
	  			traverse(i);
	  		}	
	  		//TODO
	  		//case _ if(analyze(unit) == SinkNode) => traverseSinkStatement(v, method, defs)
        	//case _ =>	  		
  		}
	}
	return SVFAModel({});
}

private ValueFlowNode analyze(Statement stmt) {
	//TODO implementar
	return sourceNode();	
}

private void traverse(assign(Variable var, Expression expression)) {
	switch(expression){
		case immediate(Immediate i):      println("\timmediate= <i>");
		case invokeExp(expr):             println("\tinvokeExpr <expr>");
		case localFieldRef(l, cn,ft, fn): println("\tlocalFieldRef <l>");
		case fieldRef(cn, ft, fn):        println("\tfieldRef <cn>");		
		case arraySubscript(n, i):        println("\tarraySubscript <n>");
		case stringSubscript(n, i):       println("\tstringSubscript <n>");
		case newArray(t, _):              println("\tnewArray <t>");
		case newInstance(t):              println("\tnewInstance <t>");
		default: println("\t***** DEFAULT=<expression>");
	}
}

private void traverse(stmt: invokeStmt(InvokeExp invokeExpression)){
	switch(analyze(stmt)){
		case sourceNode(): println("\t sourceNode");
		case sinkNode(): println("\t sinkNode");
	}
}

private void traverseSinkStatement(){
}



private void copyRule(){
}

private void loadRule(){
}

private void invokeRule(){
}



private void createNode(MethodBody mb){	
}

private void createCSOpenLabel(){}

private void createCSCloseLabel(){}

