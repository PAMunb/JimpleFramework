module lang::jimple::analysis::pointsto::Framework

import lang::jimple::toolkit::CallGraph;
import lang::jimple::util::Converters;
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;
import lang::jimple::util::Converters;
import IO;
import List;
import Relation;

// This is a context-insensitive subset-based points-to analysis
//Inputs: 
//CallGraph (Entrypoint?)
//Jimple IR for all methods.
//Process: 
//As for Lhotak thesis, we have to do thesis steps below;
//1 - Build Pointer Assignment Graph
//2 - Simplify of Pointer Assignment Graph
//3 - Propagation of points-to set (turns candidates LoadEdge and StoreEdge into real ConcreteFieldNode)
//3.1 - Use Iterative algorithm or 
//3.2 - Use Worklist algorithm 
//Outpus: 
//1 - Points-to set output (graph) and 
//2 - Helper functions over points-to set.


//Types of node on graph
data PointerAssignmentNodeType = AllocationNode(str color, str methodSig, str name, Expression exp)
								| VariableNode(str color, str methodSig, str name, Type \type)
								| FieldRefNode(str color, str methodSig, str name)
								| ConcreteFieldNode(str color, str methodSig, str name);

//Types of edges on graph (some way to map NodeType -> NodeType)
data PointerAssignmentEdgeType = AllocationEdge()
								| AssignmentEdge()
								| StoreEdge()
								| LoadEdge()
								| ToBeResolved();

//	Try using a labeled graph for mapping node types (nodes)  and edge types (labels).
//	OBS: it is not possible to do a transitive clojure with labeled graph
alias PointerAssignGraph = LGraph[PointerAssignmentNodeType , PointerAssignmentEdgeType];
 
data AllocationSite = allocsite(str methodSig, str name, Expression exp);
alias PointsToSet = map[str, set[AllocationSite]];

public PointsToSet propagatesPointsToGraph(PointerAssignGraph pag) {
	PointsToSet pSet = ();	
	// Process allocations edges
	allocsEdges = (t2.name : t1 | <t1, f, t2> <- pag, f == AllocationEdge());
    for(e <- allocsEdges) {
    	pSet[e] = {AllocSiteFromAllocNode(allocsEdges[e])};
    }
	return pSet;
}


public PointerAssignGraph buildsPointsToGraph(list[Method] methodsList) {
	PointerAssignGraph pag = {};
	int i = 0;
	// Loking for assigns, all kinds (pointer ones)
	// Still to go: return, identity, throw
	while(!isEmpty(methodsList)) {
		Method currentMethod = head(methodsList);
		str methodSig = buildMethodSignatureFromMethod(currentMethod);
		methodsList = drop(1,methodsList);
		top-down visit(currentMethod.body.stmts) {			
			// x = new A[][]			
			case assign(localVariable(lhs), newArray(\type, _)): {
				println("<currentMethod.name> Creates NewArray AllocNode and VariableNode and AllocationEdge");
				i += 1;
				alloc = AllocationNode("blue", methodSig, "<i>", immediate(stringValue(s)));
				var = VariableNode("green", methodSig, "Global<lhs>", \type);
				edge = AllocationEdge();
				pag += <alloc, edge, var>;
			}
			// x = "Hello"			
			case assign(localVariable(lhs), immediate(stringValue(s))): {
				println("<currentMethod.name> Creates String AllocNode and VariableNode and AllocationEdge");
				i += 1;
				alloc = AllocationNode("blue", methodSig, "<i>", immediate(stringValue(s)));
				var = VariableNode("green", methodSig, "Global<lhs>", TObject("java.lang.String"));
				edge = AllocationEdge();
				pag += <alloc, edge, var>;
			}
			// x = new A			
			case assign(localVariable(lhs), newInstance(\type)): {
				println("<currentMethod.name> Creates AllocNode and VariableNode and AllocationEdge"); 
				i += 1;
				alloc = AllocationNode("blue", methodSig, "<i>", newInstance(\type));
				var = VariableNode("green", methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
				edge = AllocationEdge();
				pag += <alloc, edge, var>;
			}
			// y = x			
			case assign(localVariable(lhs), immediate(local(rhs))): {
				println("<currentMethod.name> Creates VariableNode and VariableNode and AssignmentEdge"); 
				var1 = VariableNode("green", methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
				var2 = VariableNode("green", methodSig, "<rhs>", getVarType(currentMethod.body, rhs));
				edge = AssignmentEdge();
				pag += <var1, edge, var2>;
			}
			// x = bar(something in our VarNode)			
			case assign(localVariable(lhs), invokeExp(exp)): {
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
				pag += <var1, edge, var2>;
			}
			// z = x.f			
			case assign(localVariable(lhs), localFieldRef(rhs, class, \type, fieldName)): { 
				println("<currentMethod.name> Creates VariableNode and FieldRefNode and LoadEdge"); 
				var = VariableNode("green", methodSig, "<lhs>", getVarType(currentMethod.body, lhs));
				ref = FieldRefNode("red", methodSig, "<rhs>.<fieldName>");
				edge = LoadEdge();
				pag += <var, edge, ref>;
			}
			// x.f = z			
			case assign(fieldRef(lhs,fieldSignature(class, \type, fieldName)),immediate(local(rhs))): {
				println("<currentMethod.name> Creates FieldRefNode abd VariableNode and StoreEdge");  
				ref = FieldRefNode("red", methodSig, "<lhs>.<fieldName>");
				var = VariableNode("green", methodSig, "<rhs>", getVarType(currentMethod.body, rhs));
				edge = StoreEdge();
				pag += <ref, edge, var>;
			}
		}		
	}			
	return pag;
}

private list[Immediate] getAllPagVars(PointerAssignGraph pag) {
	list[Immediate] vars = [];
	top-down visit(carrier(pag)) {
    	case VariableNode(color, methodSig, name, _): vars += local(name);
	}
	return vars;
}

private str buildMethodSignatureFromMethod(Method m) {
	return signature(methodSignature("", m.returnType, m.name, m.formals)); 	
}

private AllocationSite AllocSiteFromAllocNode(PointerAssignmentNodeType n) {
	return allocsite(n.methodSig, n.name, n.exp);	
}
