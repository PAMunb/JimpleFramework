module lang::jimple::analysis::pointsto::Framework

import lang::jimple::toolkit::CallGraph;
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;

//Types of node on graph
data PointerAssignmentNodeType = AllocationNode()
								| VariableNode()
								| FieldRefNode()
								| ConcreteFieldNode();

//Types of edges on graph (some way to map NodeType -> NodeType)
data PointerAssignmentEdgeType = AllocationEdge()
								| AssignmentEdge()
								| StoreEdge()
								| LoadEdge();


alias PointerAssignGraph = LGraph[PointerAssignmentNodeType , PointerAssignmentEdgeType];

//bool isAllocationNode(Statement s) = return false;
//bool isVariableNode(Statement s) = return false;
//bool isFieldRefNode(Statement s) = return false;
//bool isConcreteFieldNode(Statement s) = return false;
//
