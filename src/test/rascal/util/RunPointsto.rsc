module util::RunPointsto

import IO;
import Map;
import Relation;
import Type;
import Set;
import List;
import util::Math;
import analysis::graphs::Graph;

import vis::Figure;
import vis::ParseTree;
import vis::Render;

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;
import lang::jimple::toolkit::CallGraph;
import lang::jimple::toolkit::GraphUtil;
import lang::jimple::util::Converters;
import lang::jimple::toolkit::PrettyPrinter;

import lang::jimple::analysis::pointsto::PointsTo;
import lang::jimple::analysis::pointsto::PointsToGraph;
import lang::jimple::analysis::pointsto::PointsToGraphBuilder;

public tuple[list[loc] classPath, list[str] entryPoints] fooBar() {
	//TODO compile class before using: mvn test -DskipTests
	files = [|project://JimpleFramework/target/test-classes/samples/pointsto/simple/|];
    es = ["samples.pointsto.simple.FooBar.foo()"];
    return <files, es>;
}

public void pointsTo() {
	// possible tests	
	tuple[list[loc] cp, list[str] e] t = fooBar();

    files = t.cp;
    es = t.e;

	println("INICIANDO");
    PointerAssignGraph pag = execute(files, es, Analysis(pointsToAnalysis(es)), true);
    println("TERMINOU");
    render(toFigure(pag));  
       
}

public Figure toFigure(PointerAssignGraph pag) {
  //Create nodes  
  nodes = carrier(pag);
  boxes = [];
   
  top-down visit(nodes) {
    case AllocationNode(color, methodSig, name, _): {
      println("<methodSig>.<name>");
      boxes += box(text("Alloc <name>"), id("<methodSig>.<name>"), size(50), fillColor(color));
    } 
    case VariableNode(color, methodSig, name, _): {
      println("<methodSig>.<name>");
      boxes += box(text(name), id("<methodSig>.<name>"), size(50), fillColor(color));
    }
    case FieldRefNode(color, methodSig, name): {
      println("<methodSig>.<name>");
      boxes += box(text(name), id("<methodSig>.<name>"), size(50), fillColor(color));
    }
    case ConcreteFieldNode(color, _, name): boxes += box(text(name), id(name), size(50), fillColor(color));
  }  
  
  //Create edges
  edges = [];
  edges += [edge("<t1.methodSig>.<t1.name>", "<t2.methodSig>.<t2.name>") | <t1, f, t2> <- pag];
      
  return scrollable(graph(boxes, edges, hint("layered"), std(size(20)), std(gap(10))));    
}