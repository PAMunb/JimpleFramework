module lang::jimple::analysis::pointsto::spark::PointerAssignmentGraphBuilder

import lang::jimple::core::Context;
import lang::jimple::core::Syntax;
import lang::jimple::util::Converters;

import lang::jimple::analysis::pointsto::spark::PointerAssignmentGraph;

import IO;
import List;
import Relation;
import Set;


int i = 0;
alias Nome = tuple[PointerAssignmentNodeType , PointerAssignmentEdgeType, PointerAssignmentNodeType];


public PointerAssignGraph buildsPointsToGraph(ExecutionContext ctx, list[MethodSignature] methodsList) {
	PointerAssignGraph pag = {};
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
			case assign(localVariable(lhs), invokeExp(exp)): {				
				println("<currentMethod.name> An assign with invoke to other method = <exp>"); 
				//Creates a VarNode with AssignmentEdge to the parameter of method (another VarNode)
				//Looks for variable nodes that maybe arg in args list of invoke
				//args = getAllPagVars(pag) & exp.args;
				args = getAllPagVars(pag) & getArgs(exp);
				for (Immediate i <- args) {
					//var1 = VariableNode(methodSig, "<i.localName>", getVarType(currentMethod.body, i.localName));
					//var2 = VariableNode("INVOKE", "INVOKE_ARGS", getVarType(currentMethod.body, i.localName));
					var1 = VariableNode(methodSig, "<i.localName>", getVarType(currentMethod, i));
					var2 = VariableNode("INVOKE", "INVOKE_ARGS", getVarType(currentMethod, i));
					edge = AssignmentEdge();
					pag += <var1, edge, var2>;					
				}
				// We also create a relation to be resolved later when the invoked method is treated.				
				var1 = VariableNode(methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
				var2 = VariableNode("INVOKE", "INVOKE_ARGS", getVarType(currentMethod.body, lhs));
				edge = ToBeResolved();
				println("ToBeResolved");
				pag += <var1, edge, var2>;
			}
						
			case a: assign(_, _): {
				println("A=<a>");
				//TODO trocar nome do metodo
				//println("retorno=<build(currentMethod, methodSig, a)>");
				pag += build(currentMethod, methodSig, a);
			}
			
			//case Statement s => println("=========== <s>")
			case Statement s: println("=========== <s>");
			
			//default: println("======== DEFAULT ...");			
		}		
	}			
	return pag;
}

// x = new A 
// a: new A --> x			
private Nome build(Method currentMethod, str methodSig, assign(localVariable(lhs), newInstance(\type))){
	println("<currentMethod.name> Creates AllocNode and VariableNode and AllocationEdge"); 
	i += 1;
	alloc = AllocationNode(methodSig, "<i>", newInstance(\type));
	var = VariableNode(methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
	edge = AllocationEdge();
	return <alloc, edge, var>;
}

// x = new A[][]	
private Nome build(Method currentMethod, str methodSig,	assign(localVariable(lhs), newArray(\type, _))){	
	println("<currentMethod.name> Creates NewArray AllocNode and VariableNode and AllocationEdge");
	i += 1;
	//TODO rever
	alloc = AllocationNode(methodSig, "<i>", immediate(iValue(stringValue(_))));
	var = VariableNode(methodSig, "Global<lhs>", \type);
	edge = AllocationEdge();
	return <alloc, edge, var>;
}

// x = "Hello"		
//TODO botar a expressao toda
private Nome build(Method currentMethod, str methodSig,	assign(localVariable(lhs), immediate(iValue(stringValue(_))))){				
	println("<currentMethod.name> Creates String AllocNode and VariableNode and AllocationEdge");
	i += 1;
	alloc = AllocationNode(methodSig, "<i>", immediate(iValue(stringValue(_))));
	var = VariableNode(methodSig, "Global<lhs>", TObject("java.lang.String"));
	edge = AllocationEdge();
	return <alloc, edge, var>;
}			

// y = x	
// x --> y	
private Nome build(Method currentMethod, str methodSig, assign(localVariable(lhs), immediate(local(rhs)))){
	println("<currentMethod.name> Creates VariableNode and VariableNode and AssignmentEdge"); 
	to = VariableNode(methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
	from = VariableNode(methodSig, "<rhs>", getVarType(currentMethod.body, rhs));
	edge = AssignmentEdge();
	return <from, edge, to>;
}

// z = x.f	
// x.f --> z	
private Nome build(Method currentMethod, str methodSig,	a: assign(localVariable(lhs), localFieldRef(rhs, class, \type, fieldName))){
	println("<currentMethod.name> Creates VariableNode and FieldRefNode and LoadEdge = <a>");
	ref = FieldRefNode(methodSig, "<lhs>",  "<rhs>.<fieldName>", \type); 
	var = VariableNode(methodSig, "<lhs>", getVarType(currentMethod.body, lhs));	
	edge = LoadEdge();
	return <ref, edge, var>;
}

// x.f = z	
// z --> x.f
private Nome build(Method currentMethod, str methodSig,	a: assign(fieldRef(lhs,fieldSignature(class, \type, fieldName)),immediate(local(rhs)))){
	println("<currentMethod.name> Creates FieldRefNode and VariableNode and StoreEdge = <a>");
	var = VariableNode(methodSig, "<rhs>", getVarType(currentMethod.body, rhs));  
	ref = FieldRefNode(methodSig, "<rhs>", "<lhs>.<fieldName>", \type);	
	edge = StoreEdge();
	return <var, edge, ref>;
}	


////////////////////////////////////////////	
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

private str buildMethodSignatureFromMethod(Method m) {
	return signature(methodSignature("", m.returnType, m.name, m.formals)); 	
}

private AllocationSite AllocSiteFromAllocNode(PointerAssignmentNodeType n) {
	return allocsite(n.methodSig, n.name, n.exp);	
}
