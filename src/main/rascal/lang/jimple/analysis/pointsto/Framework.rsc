module lang::jimple::analysis::pointsto::Framework

import lang::jimple::toolkit::CallGraph;
import lang::jimple::util::Converters;
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;
import lang::jimple::util::Converters;
import IO;
import List;

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
								| LoadEdge();

//	Try using a labeled graph for mapping node types (nodes)  and edge types (labels).
//	OBS it is not possible to do a transitive clojure with labeled graph
alias PointerAssignGraph = LGraph[PointerAssignmentNodeType , PointerAssignmentEdgeType];

public PointerAssignGraph propagatesPointsToGraph(PointerAssignGraph pag) {
	return pag;
}

public PointerAssignGraph buildsPointsToGraph(list[Method] methodsList) {
	PointerAssignGraph pag = {};
	int i = 0;
	// Loking for assigns, all kinds.
	// Still to go: return, identity, throw
	while(!isEmpty(methodsList)) {
		Method currentMethod = head(methodsList);
		str methodSig = buildMethodSignatureFromMethod(currentMethod);
		methodsList = drop(1,methodsList);
		println("metodo <currentMethod.name>");
		top-down visit(currentMethod.body.stmts) {
			case assign(localVariable(lhs), immediate(stringValue(s))): {
				println("<currentMethod.name> Creates String AllocNode and VariableNode and AllocationEdge"); // x = "Hello"
				i += 1;
				alloc = AllocationNode("blue", methodSig, "<i>", immediate(stringValue(s)));
				var = VariableNode("green", methodSig, "Global<lhs>", TObject("java.lang.String")); // Get type from LocalVariableDeclaration
				edge = AllocationEdge(); 
				pag += <alloc, edge, var>;				
			}
			case assign(localVariable(lhs), newInstance(\type)): {
				println("<currentMethod.name> Creates AllocNode and VariableNode and AllocationEdge"); // x = new A
				i += 1;
				alloc = AllocationNode("blue", methodSig, "<i>", newInstance(\type));
				var = VariableNode("green", methodSig, "Global<lhs>", getVarType(currentMethod.body, lhs)); // Get type from LocalVariableDeclaration
				edge = AllocationEdge(); 
				pag += <alloc, edge, var>;
			}
			case assign(localVariable(lhs), immediate(local(rhs))): { 
				println("<currentMethod.name> Creates VariableNode and VariableNode and AssignmentEdge"); // y = x
				var1 = VariableNode("green", methodSig, "Global<lhs>", getVarType(currentMethod.body, lhs)); // Get type from LocalVariableDeclaration
				var2 = VariableNode("green", methodSig, "Global<rhs>", getVarType(currentMethod.body, rhs)); // Get type from LocalVariableDeclaration
				edge = AssignmentEdge(); 
				pag += <var1, edge, var2>;
			}
			case assign(localVariable(lhs), localFieldRef(rhs, class, \type, fieldName)): { 
				println("<currentMethod.name> Creates VariableNode and FieldRefNode and LoadEdge"); // z = x.f
				var = VariableNode("green", methodSig, "Global<lhs>", getVarType(currentMethod.body, lhs)); // Get type from LocalVariableDeclaration
				ref = FieldRefNode("red", methodSig, "<rhs>.<fieldName>");
				edge = LoadEdge(); 
				pag += <var, edge, ref>;
			}
			case assign(fieldRef(lhs,fieldSignature(class, \type, fieldName)),immediate(local(rhs))): {
				println("<currentMethod.name> Creates FieldRefNode abd VariableNode and StoreEdge");  // x.f = z
				ref = FieldRefNode("red", methodSig, "<lhs>.<fieldName>");
				var = VariableNode("green", methodSig, "Global<rhs>", getVarType(currentMethod.body, rhs)); // Get type from LocalVariableDeclaration				
				edge = StoreEdge(); 
				pag += <ref, edge, var>;
			}
		}		
	}
			
	return pag;
}

private str buildMethodSignatureFromMethod(Method m) {
	return signature(methodSignature("", m.returnType, m.name, m.formals)); 	
}
