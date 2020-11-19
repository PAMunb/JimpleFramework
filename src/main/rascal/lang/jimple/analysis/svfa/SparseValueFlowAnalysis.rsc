module lang::jimple::analysis::svfa::SparseValueFlowAnalysis


import lang::jimple::core::Context; 
import lang::jimple::core::Syntax; 
import lang::jimple::toolkit::ValueFlowGraph;
import lang::jimple::util::Converters; 

import List;
import IO;


data SVFAModel = SVFAModel(ValueFlowGraph cg);

data SVFARuntime = SVFARuntime(ExecutionContext ctx);

public void teste(){
	list[MethodSignature] entryPoints = [];
	
	
}


private void computeSVFGraph(list[MethodSignature] methodsList, SVFARuntime rt) {	
	while(!isEmpty(methodsList)){	
		MethodSignature currentMethodSig = head(methodsList);
		methodsList = drop(1,methodsList);	
		
		str currentMethod = signature(currentMethodSig.className, currentMethodSig.methodName, currentMethodSig.formals);
		
		top-down visit(rt.ctx.mt[currentMethod].method.body.stmts) {	 	
	  		case assign(Variable var, Expression expression): {
	  			println("assign ....");
	  		}  
	  		case invokeStmt(InvokeExp invokeExpression):{
	  			println("invoke ....");
	  		}	
	  		//TODO
	  		//case _ if(analyze(unit) == SinkNode) => traverseSinkStatement(v, method, defs)
        	//case _ =>	  		
  		}
	}
}