module lang::jimple::analysis::pointsto::PointsToGraph

import lang::jimple::toolkit::CallGraph;
import lang::jimple::util::Converters;
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;
import IO;
import List;
import Relation;
import vis::Figure;


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
//	Outputs: 
//		1 - Points-to set output (graph) and 
//		2 - Helper functions over points-to set.


//	Types of node on graph
data PointerAssignmentNodeType = AllocationNode(str methodSig, str name, Expression exp)
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




//////////////////////////////////////////////////////////////
///// UTILS
public Figure toFigure(PointerAssignGraph pag) {
  //Create nodes  
  nodes = carrier(pag);
  boxes = [];
   
  top-down visit(nodes) {
  	case AllocationNode(methodSig, name, newInstance(TObject(t))): boxes += box(text("A<name>: new <t>"), id("<methodSig>.<name>"), size(50), fillColor("blue")); 
    case AllocationNode(methodSig, name, _): boxes += box(text("A<name>"), id("<methodSig>.<name>"), size(50), fillColor("blue"));    
    case VariableNode(methodSig, name, _):   boxes += box(text(name), id("<methodSig>.<name>"), size(50), fillColor("green"));    
    case FieldRefNode(methodSig, name):      boxes += box(text(name), id("<methodSig>.<name>"), size(50), fillColor("red"));    
    case ConcreteFieldNode(methodSig, name): boxes += box(text(name), id("<methodSig>.<name>"), size(50), fillColor("yellow"));    
  }  
  
  //Create edges
  edges = [];
  edges += [e("<t1.methodSig>.<t1.name>", "<t2.methodSig>.<t2.name>") | <t1, _, t2> <- pag];
      
  return scrollable(graph(boxes, edges, hint("layered"), std(size(20)), std(gap(20))));    
}

private Edge e(str i, str j, FProperty props ...) = edge(i, j, props + toArrow(triangle(5)));
