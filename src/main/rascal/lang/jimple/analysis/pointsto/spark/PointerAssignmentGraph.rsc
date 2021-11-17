module lang::jimple::analysis::pointsto::spark::PointerAssignmentGraph


import lang::jimple::core::Syntax;

import analysis::graphs::LabeledGraph;

//TODO
//data VariableNodeType = ClassVariableNode(str name, Type \type)
//						| MethodVariableNode(str methodSig, str name, Type \type);

//	Types of node on graph
data PointerAssignmentNodeType = AllocationNode(str methodSig, str name, Expression exp)
								| VariableNode(str methodSig, str name, Type \type)
								| FieldRefNode(str methodSig, str varName, str name, Type \type) //methodSig+varName represents the variable node (its base)
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