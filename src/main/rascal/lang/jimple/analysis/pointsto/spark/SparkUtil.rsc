module lang::jimple::analysis::pointsto::spark::SparkUtil

import lang::jimple::core::Syntax;
import lang::jimple::analysis::pointsto::spark::PointerAssignmentGraph;

import Relation;
//import analysis::graphs::Graph;
import vis::Figure;



public Figure toFigure(PointerAssignGraph pag) {
  //Create nodes  
  nodes = carrier(pag);
  boxes = [];
   
  top-down visit(nodes) {
  	case AllocationNode(methodSig, name, newInstance(TObject(t))): boxes += box(text("A<name>: new <t>"), id("<methodSig>.<name>"), size(50), fillColor("blue")); 
    case AllocationNode(methodSig, name, _): boxes += box(text("A<name>"), id("<methodSig>.<name>"), size(50), fillColor("blue"));    
    case VariableNode(methodSig, name, _):   boxes += box(text(name), id("<methodSig>.<name>"), size(50), fillColor("green"));    
    case FieldRefNode(methodSig,_, name,_):      boxes += box(text(name), id("<methodSig>.<name>"), size(50), fillColor("red"));    
    case ConcreteFieldNode(methodSig, name): boxes += box(text(name), id("<methodSig>.<name>"), size(50), fillColor("yellow"));    
  }  
  
  //Create edges
  edges = [];
  edges += [e("<t1.methodSig>.<t1.name>", "<t2.methodSig>.<t2.name>") | <t1, _, t2> <- pag];
      
  return scrollable(graph(boxes, edges, hint("layered"), std(size(20)), std(gap(20))));    
}

private Edge e(str i, str j, FProperty props ...) = edge(i, j, props + toArrow(triangle(5)));