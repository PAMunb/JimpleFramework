module lang::jimple::analysis::pointsto::Framework

import lang::jimple::toolkit::CallGraph;
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;

//Inputs: 
//CallGraph (Entrypoint?)
//Jimple IR for all methods.
//Process: 
//As for Lhotak these, we have to do these steps below;
//1 - Build Pointer Assignment Graph
//2 - Simplify of Pointer Assignment Graph
//3 - Propagation of points-to set (turns candidates edges into real edges)
//3.1 - Use Iterative algorithm or 
//3.2 - Use Worklist algorithm 
//Outpus: 
//1 - Points-to set output (graph) and 
//2 - Helper functions over points-to set.

//Types of node on graph
data PointerAssignmentNodeType = AllocationNode(str name)
								| VariableNode(str name)
								| FieldRefNode()
								| ConcreteFieldNode();

//Types of edges on graph (some way to map NodeType -> NodeType)
data PointerAssignmentEdgeType = AllocationEdge()
								| AssignmentEdge()
								| StoreEdge()
								| LoadEdge();


//Try using a labeled graph for mapping node types (nodes)  and edge types (labels).
//OBS it is not possible to do a transitive clojure with labeled graph
alias PointerAssignGraph = LGraph[PointerAssignmentNodeType , PointerAssignmentEdgeType];


