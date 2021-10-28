module lang::jimple::analysis::pointsto::PointsToGraphBuilder

import lang::jimple::analysis::pointsto::PointsToGraph;
import lang::jimple::core::Syntax;
import lang::jimple::core::Context; 

import lang::jimple::toolkit::CallGraph;
import lang::jimple::util::Converters;

import analysis::graphs::LabeledGraph;
import analysis::graphs::Graph;
import IO;
import List;
import Map;
import Node;
import Relation;
import Set;
import String;

import Type;
import IO;
import lang::jimple::toolkit::PrettyPrinter;


int i = 0;
//TODO escolher nome "direito"!!!
alias Nome = tuple[PointerAssignmentNodeType , PointerAssignmentEdgeType, PointerAssignmentNodeType];


public PointerAssignGraph buildsPointsToGraph(list[Method] methodsList) {
	PointerAssignGraph pag = {};
	i = 0;
	
	// Loking for assigns, all kinds (pointer ones)
	// Still to go: return, identity, throw
	while(!isEmpty(methodsList)) {
		Method currentMethod = head(methodsList);
		str methodSig = buildMethodSignatureFromMethod(currentMethod);
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
private Nome build(Method currentMethod, str methodSig,	assign(localVariable(lhs), immediate(iValue(stringValue(_))))){				
	println("<currentMethod.name> Creates String AllocNode and VariableNode and AllocationEdge");
	i += 1;
	alloc = AllocationNode(methodSig, "<i>", immediate(iValue(stringValue(_))));
	var = VariableNode(methodSig, "Global<lhs>", TObject("java.lang.String"));
	edge = AllocationEdge();
	return <alloc, edge, var>;
}			
// y = x		
private Nome build(Method currentMethod, str methodSig, assign(localVariable(lhs), immediate(local(rhs)))){
	println("<currentMethod.name> Creates VariableNode and VariableNode and AssignmentEdge"); 
	var1 = VariableNode(methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
	var2 = VariableNode(methodSig, "<rhs>", getVarType(currentMethod.body, rhs));
	edge = AssignmentEdge();
	return <var1, edge, var2>;
}


//TODO arrumar isso!!!
// x = bar(something in our VarNode)	
/*private Nome build(Method currentMethod, str methodSig, assign(localVariable(lhs), invokeExp(exp))){		
	println("<currentMethod.name> An assign with invoke to other method"); 
	//Creates a VarNode with AssignmentEdge to the parameter of method (another VarNode)
	//Looks for variable nodes that maybe arg in args list of invoke
	args = getAllPagVars(pag) & exp.args;
	for (Immediate i <- args) {
		var1 = VariableNode("green", methodSig, "<i.localName>", getVarType(currentMethod.body, i.localName));
		var2 = VariableNode("green", "INVOKE", "INVOKE_ARGS", getVarType(currentMethod.body, i.localName));
		edge = AssignmentEdge();
		pag += <var1, edge, var2>;					
	}
	// We also create a relation to be resolved later when the invoked method is treated.
	var1 = VariableNode("green", methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
	var2 = VariableNode("green", "INVOKE", "INVOKE_ARGS", getVarType(currentMethod.body, lhs));
	edge = ToBeResolved();
	return <var1, edge, var2>;
}*/




// z = x.f		
private Nome build(Method currentMethod, str methodSig,	a: assign(localVariable(lhs), localFieldRef(rhs, class, \type, fieldName))){
	println("<currentMethod.name> Creates VariableNode and FieldRefNode and LoadEdge = <a>"); 
	var = VariableNode(methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
	ref = FieldRefNode(methodSig, "<rhs>.<fieldName>");
	edge = LoadEdge();
	return <var, edge, ref>;
}
// x.f = z	
private Nome build(Method currentMethod, str methodSig,	a: assign(fieldRef(lhs,fieldSignature(class, \type, fieldName)),immediate(local(rhs)))){
	println("<currentMethod.name> Creates FieldRefNode abd VariableNode and StoreEdge = <a>");  
	ref = FieldRefNode(methodSig, "<lhs>.<fieldName>");
	var = VariableNode(methodSig, "<rhs>", getVarType(currentMethod.body, rhs));
	edge = StoreEdge();
	return <ref, edge, var>;
}				


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


/////////// TODO
// Interative algorithm for pointsto propagation
public PointsToSet propagatesPointsToGraph(PointerAssignGraph pag) {
	PointsToSet pSet = ();	
	// Propagate Allocation Edge
	allocsEdges = (t2.name : t1 | <t1, f, t2> <- pag, f == AllocationEdge());
    for(e <- allocsEdges) {
    	pSet[e] = {AllocSiteFromAllocNode(allocsEdges[e])};
    }

	// Propagate Assignment Edge    
    solve(pSet) {
    	assignEdges = (t2.name : t1.name | <t1, f, t2> <- pag, f == AssignmentEdge());    	
        for(e <- assignEdges) {
        	if (e in pSet) {
        		pSet[assignEdges[e]] = pSet[e];
        	}
        }
    }
	return pSet;
}


