module lang::jimple::analysis::pointsto::PointsToGraph

import lang::jimple::toolkit::CallGraph;
import lang::jimple::util::Converters;
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;
import IO;
import List;
import Relation;


//	This is a context-insensitive subset-based points-to analysis
//	Inputs: 
//	CallGraph (Entrypoint?)
//	Jimple IR for all methods.
//	Process: 
//	As for Lhotak thesis, we have to do thesis steps below;
//		1 - Build Pointer Assignment Graph
//		2 - Simplify of Pointer Assignment Graph
//		3 - Propagation of points-to set (turns candidates LoadEdge and StoreEdge into real ConcreteFieldNode)
//			3.1 - Use Iterative algorithm or 
//			3.2 - Use Worklist algorithm 
//	Outpus: 
//		1 - Points-to set output (graph) and 
//		2 - Helper functions over points-to set.


//	Types of node on graph
//TODO tirar color
data PointerAssignmentNodeType = AllocationNode(str color, str methodSig, str name, Expression exp)
								| VariableNode(str color, str methodSig, str name, Type \type)
								| FieldRefNode(str color, str methodSig, str name)
								| ConcreteFieldNode(str color, str methodSig, str name);
data PointerAssignmentNodeTypeNovo = AllocationNode(str methodSig, str name, Expression exp)
								| VariableNode(str methodSig, str name, Type \type)
								| FieldRefNode(str methodSig, str name)
								| ConcreteFieldNode(str methodSig, str name);								

//	Types of edges on graph (some way to map NodeType -> NodeType)
data PointerAssignmentEdgeType = AllocationEdge()
								| AssignmentEdge()
								| StoreEdge()
								| LoadEdge()
								| ToBeResolved();

//	Try using a labeled graph for mapping node types (nodes) and edge types (labels).
//	OBS: it is not possible to do a transitive clojure with labeled graph
alias PointerAssignGraph = LGraph[PointerAssignmentNodeType , PointerAssignmentEdgeType];

// Model for pointsTo Set interface.
data AllocationSite = allocsite(str methodSig, str name, Expression exp);
//TODO migrar para relation
alias PointsToSet = map[str, set[AllocationSite]];
alias PointsToSetNovo = rel[str, set[AllocationSite]];

