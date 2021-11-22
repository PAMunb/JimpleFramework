module lang::jimple::analysis::pointsto::spark::PointerAssignmentGraphBuilder

import lang::jimple::core::Context;
import lang::jimple::core::Syntax;
import lang::jimple::util::Converters;

import lang::jimple::analysis::pointsto::spark::PointerAssignmentGraph;

import IO;
import List;
import Relation;
import Set;

import lang::jimple::util::JPrettyPrinter;


data PagRuntime = pagRuntime(ExecutionContext ctx);

int i = 0;
alias Nome = tuple[PointerAssignmentNodeType , PointerAssignmentEdgeType, PointerAssignmentNodeType];

PointerAssignGraph pag = {};
PagRuntime rt;

public PointerAssignGraph buildsPointsToGraph(ExecutionContext ctx, list[MethodSignature] methodsList) {
	rt = pagRuntime(ctx);
	pag = {};
	i = 0;
	
	// Loking for assigns, all kinds (pointer ones)
	// Still to go: return, identity, throw
	while(!isEmpty(methodsList)) {
		MethodSignature sig = head(methodsList);
		str methodSig = signature(sig.className, sig.methodName, sig.formals); 
		Method currentMethod = ctx.mt[methodSig].method;
		
		//TODO arrumar assinatura (nao tem o nome da classe)
		println("****** current method=<methodSig> ");
		methodsList = drop(1,methodsList);
		top-down visit(currentMethod.body.stmts) {	
		
			//TODO arrumar ...					
			// x = bar(something in our VarNode)			
			/*case assign(localVariable(lhs), invokeExp(exp)): {				
				println("******************** <currentMethod.name> An assign with invoke to other method = <exp>"); 
				//Creates a VarNode with AssignmentEdge to the parameter of method (another VarNode)
				//Looks for variable nodes that maybe arg in args list of invoke
				//args = getAllPagVars(pag) & exp.args;
				args = getAllPagVars(pag) & getArgs(exp);
				for (Immediate i <- args) {
					//var1 = VariableNode(methodSig, "<i.localName>", getVarType(currentMethod.body, i.localName));
					//var2 = VariableNode("INVOKE", "INVOKE_ARGS", getVarType(currentMethod.body, i.localName));
					var1 = VariableNode(methodSig, "<i.localName>", getVarType(currentMethod, i));
					var2 = VariableNode("INVOKE", "INVOKE_ARGS", getVarType(currentMethod, i));
					println("interno_var1=<var1>");
					println("interno_var2=<var2>");
					edge = AssignmentEdge();
					pag += <var1, edge, var2>;					
				}
				// We also create a relation to be resolved later when the invoked method is treated.				
				var1 = VariableNode(methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
				var2 = VariableNode("INVOKE", "INVOKE_ARGS", getVarType(currentMethod.body, lhs));
				println("var1=<var1>");
				println("var2=<var2>");
				edge = ToBeResolved();
				println("ToBeResolved");
				pag += <var1, edge, var2>;
			}*/
						
			case a: assign(_, _): {
				println("A=<a>");
				//TODO trocar nome do metodo
				//println("retorno=<build(currentMethod, methodSig, a)>");
				//pag += build(currentMethod, methodSig, a);
				build(currentMethod, methodSig, a);
			}
			
			//case Statement s => println("=========== <s>")
			case Statement s: println("=========== <s>");
			
			//default: println("======== DEFAULT ...");			
		}		
	}			
	return pag;
}


void build(Method currentMethod, str methodSig, assign(localVariable(lhs), inv: invokeExp(s: staticMethodInvoke(sig, args)))){
	println("%%%%%%%%%%%%%%%%%%%% STATIC: <sig>"); 
	println("ARGS=<args>");	
	println("LHS=<lhs>");
	println("currentMethod=<currentMethod.formals>");
	println("sig=<sig>");
	str destmethod = signature(sig);
	println("destmethod=<destmethod>");
	println("destMethod=<rt.ctx.mt[destmethod].method.formals>");
	println("destMethod=<rt.ctx.mt[destmethod].method.body>");
	//println("destMethod=<prettyPrint(rt.ctx.mt[destmethod].method.body)>");
	println("args=<getArgs(s)>");
	//alloc = VariableNode("", "<i>", TUnknown());
	//var = VariableNode("", "<lhs>", TUnknown());
	//edge = AssignmentEdge();
	//pag = pag + <alloc, edge, var>;
}

// x = new A 
// a: new A --> x			
void build(Method currentMethod, str methodSig, assign(localVariable(lhs), newInstance(\type))){
	println("<currentMethod.name> Creates AllocNode and VariableNode and AllocationEdge"); 
	i += 1;
	alloc = AllocationNode(methodSig, "<i>", newInstance(\type));
	var = VariableNode(methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
	edge = AllocationEdge();
	pag = pag + <alloc, edge, var>;
}

// x = new A[][]	
void build(Method currentMethod, str methodSig,	assign(localVariable(lhs), newArray(\type, _))){	
	println("<currentMethod.name> Creates NewArray AllocNode and VariableNode and AllocationEdge");
	i += 1;
	//TODO rever
	alloc = AllocationNode(methodSig, "<i>", immediate(iValue(stringValue(_))));
	var = VariableNode(methodSig, "Global<lhs>", \type);
	edge = AllocationEdge();
	pag = pag + <alloc, edge, var>;
}

// x = "Hello"		
//TODO botar a expressao toda
void build(Method currentMethod, str methodSig,	assign(localVariable(lhs), immediate(iValue(stringValue(_))))){				
	println("<currentMethod.name> Creates String AllocNode and VariableNode and AllocationEdge");
	i += 1;
	alloc = AllocationNode(methodSig, "<i>", immediate(iValue(stringValue(_))));
	var = VariableNode(methodSig, "Global<lhs>", TObject("java.lang.String"));
	edge = AllocationEdge();
	pag = pag + <alloc, edge, var>;
}			

// y = x	
// x --> y	
void build(Method currentMethod, str methodSig, assign(localVariable(lhs), immediate(local(rhs)))){
	println("<currentMethod.name> Creates VariableNode and VariableNode and AssignmentEdge"); 
	to = VariableNode(methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
	from = VariableNode(methodSig, "<rhs>", getVarType(currentMethod.body, rhs));
	edge = AssignmentEdge();
	pag = pag + <from, edge, to>;
}

// z = x.f	
// x.f --> z	
void build(Method currentMethod, str methodSig,	a: assign(localVariable(lhs), localFieldRef(rhs, class, \type, fieldName))){
	println("<currentMethod.name> Creates VariableNode and FieldRefNode and LoadEdge = <a>");
	ref = FieldRefNode(methodSig, "<lhs>",  "<rhs>.<fieldName>", \type); 
	var = VariableNode(methodSig, "<lhs>", getVarType(currentMethod.body, lhs));	
	edge = LoadEdge();
	pag = pag + <ref, edge, var>;
}

// x.f = z	
// z --> x.f
void build(Method currentMethod, str methodSig,	a: assign(fieldRef(lhs,fieldSignature(class, \type, fieldName)),immediate(local(rhs)))){
	println("<currentMethod.name> Creates FieldRefNode and VariableNode and StoreEdge = <a>");
	var = VariableNode(methodSig, "<rhs>", getVarType(currentMethod.body, rhs));  
	ref = FieldRefNode(methodSig, "<rhs>", "<lhs>.<fieldName>", \type);	
	edge = StoreEdge();
	pag = pag + <var, edge, ref>;
}	


////////////////////////////////////////////	
/*
 * Retrieves the method signature from the method invocation info.
 */
private MethodSignature getMethodSignature(specialInvoke(_, ms, _)) = ms; 
private MethodSignature getMethodSignature(virtualInvoke(_, ms, _)) = ms; 
private MethodSignature getMethodSignature(interfaceInvoke(_, ms, _)) = ms;
private MethodSignature getMethodSignature(staticMethodInvoke(ms, _)) = ms; 
//TODO verificar se eh o segundo methodSignature mesmo (acho q o primeiro eh o bootstrap method)
private MethodSignature getMethodSignature(dynamicInvoke(_,_,ms,_)) = ms; 

private list[Immediate] getArgs(specialInvoke(_, _, args)) = args;
private list[Immediate] getArgs(virtualInvoke(_, _, args)) = args;
private list[Immediate] getArgs(interfaceInvoke(_, _, args)) = args;
private list[Immediate] getArgs(staticMethodInvoke(_, args)) = args;
private list[Immediate] getArgs(dynamicInvoke(_, _, _, args)) = args;

private list[Immediate] getAllPagVars(PointerAssignGraph pag) {
	list[Immediate] vars = [];
	top-down visit(carrier(pag)) {
    	case VariableNode(_, name, _): vars += local(name);
	}
	return vars;
}

/*
private str buildMethodSignatureFromMethod(Method m) {
	return signature(methodSignature("", m.returnType, m.name, m.formals)); 	
}

private AllocationSite AllocSiteFromAllocNode(PointerAssignmentNodeType n) {
	return allocsite(n.methodSig, n.name, n.exp);	
}
*/
