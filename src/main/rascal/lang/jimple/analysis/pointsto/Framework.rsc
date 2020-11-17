module lang::jimple::analysis::pointsto::Framework

import lang::jimple::core::Syntax;

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


bool isAllocationNode(Statement s) = return false;
bool isVariableNode(Statement s) = return false;
bool isFieldRefNode(Statement s) = return false;
bool isConcreteFieldNode(Statement s) = return false;


