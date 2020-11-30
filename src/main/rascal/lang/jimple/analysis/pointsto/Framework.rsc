module lang::jimple::analysis::pointsto::Framework

import lang::jimple::toolkit::CallGraph;
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;
import lang::jimple::util::Converters;
import IO;
import List;

//Inputs: 
//CallGraph (Entrypoint?)
//Jimple IR for all methods.
//Process: 
//As for Lhotak thesis, we have to do these steps below;
//1 - Build Pointer Assignment Graph
//2 - Simplify of Pointer Assignment Graph
//3 - Propagation of points-to set (turns candidates edges into real edges)
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


//r1.<samples.pointsto.ex2.O: samples.pointsto.ex2.O f> = r4;
//$r1 = r1.<samples.pointsto.ex2.O: samples.pointsto.ex2.O f>;
//assign(Variable var, Expression expression)
//Variable -> localVariable or fieldRef

//Try using a labeled graph for mapping node types (nodes)  and edge types (labels).
//OBS it is not possible to do a transitive clojure with labeled graph
alias PointerAssignGraph = LGraph[PointerAssignmentNodeType , PointerAssignmentEdgeType];


public PointerAssignGraph computePointsToGraph(list[Method] methodsList) {
	PointerAssignGraph pag = {};
	int i = 0;
	//Loking for assigns, all kinds.
	while(!isEmpty(methodsList)) {
		Method currentMethod = head(methodsList);
		str methodSig = buildMethodSignatureFromMethod(currentMethod);
		methodsList = drop(1,methodsList);
		println("metodo <currentMethod.name>");
		top-down visit(currentMethod.body.stmts) {
			case assign(localVariable(lhs), newInstance(\type)): {
				println("<currentMethod.name> Creates AllocNode and VariableNode and AllocationEdge"); // x = new A
				i += 1;
				alloc = AllocationNode("blue", methodSig, "<i>", newInstance(\type));
				var = VariableNode("green", methodSig, "Global<lhs>", TUnknown()); // Get type from LocalVariableDeclaration
				edge = AllocationEdge();
				elemen = <alloc, edge, var>;
				pag += elemen;
			}
			case assign(localVariable(lhs), immediate(local(rhs))): { 
				println("<currentMethod.name> Creates VariableNode and VariableNode and AssignmentEdge"); // y = x
				var1 = VariableNode("green", methodSig, "Global<lhs>", TUnknown()); // Get type from LocalVariableDeclaration
				var2 = VariableNode("green", methodSig, "Global<rhs>", TUnknown()); // Get type from LocalVariableDeclaration
				edge = AssignmentEdge();
				elemen = <var1, edge, var2>;
				pag += elemen;
			}
			case assign(localVariable(lhs), localFieldRef(rhs, class, \type, fieldName)): { 
				println("<currentMethod.name> Creates VariableNode and FieldRefNode and LoadEdge"); // z = x.f
				var = VariableNode("green", methodSig, "Global<lhs>", TUnknown()); // Get type from LocalVariableDeclaration
				ref = FieldRefNode("red", methodSig, "<rhs>.<fieldName>");
				edge = LoadEdge();
				elemen = <var, edge, ref>;
				pag += elemen;
			}
			case assign(fieldRef(lhs,fieldSignature(class, \type, fieldName)),immediate(local(rhs))): {
				println("<currentMethod.name> Creates FieldRefNode abd VariableNode and StoreEdge");  // x.f = z
				ref = FieldRefNode("red", methodSig, "<lhs>.<fieldName>");
				var = VariableNode("green", methodSig, "Global<rhs>", TUnknown()); // Get type from LocalVariableDeclaration				
				edge = StoreEdge();
				elemen = <ref, edge, var>;
				pag += elemen;
			}
		}		
	}
			
	return pag;
//	for(m <- methods) {	
//	for(/assign(var, exp) := m)
//		println("Match <var>:<exp>");
//}	
}

private str buildMethodSignatureFromMethod(Method m) {
	return signature(methodSignature("", m.returnType, m.name, m.formals)); 	
}

//public map[str, Statement] buildWholeProgramStmts(MethodMap m)