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
	for(m <- entrypoints){
		if(m in ctx.mt){
			methods = methods + toMethodSignature(m,ctx);
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
	  		case assign(Variable var, Expression expression): {
	  			println("assign .... var=<var> ... expr=<expression>");
	  		}  
	  		case invokeStmt(InvokeExp invokeExpression):{
	  			println("invoke .... <invokeExpression>");
	  		}	
	  		//TODO
	  		//case _ if(analyze(unit) == SinkNode) => traverseSinkStatement(v, method, defs)
        	//case _ =>	  		
  		}
	}
	return SVFAModel({});
}


public MethodSignature toMethodSignature(str ms, ExecutionContext ctx) {
	Name className = getClassName(ms);
	if(className != ""){
		m = ctx.mt[ms].method;		
		return methodSignature(className, m.returnType, m.name, m.formals);
	}
	throw IllegalArgument(methodSignature, "The method does not exist in the execution context.");
}
