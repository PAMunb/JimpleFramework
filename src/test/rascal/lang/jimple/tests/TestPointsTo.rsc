module lang::jimple::tests::TestPointsTo

import lang::jimple::analysis::pointsto::Framework;
import lang::jimple::toolkit::CallGraph;
import lang::jimple::core::Context;
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;

import Relation;
import Type;
import Set;
import List;
import String;
import analysis::graphs::Graph;

import vis::Figure;
import vis::ParseTree;
import vis::Render;

import Map;
import IO;

private CG transformToFullNames(CGModel model){
  mm = invertUnique(model.methodMap); 
  cg = {<mm[call.from], mm[call.to]> | call <- model.cg}; 
  return cg;
}


test bool testInitial() {
	files = [|project://JimpleFramework/target/test-classes/samples/pointsto/ex2/|];
	es = [];
	CGModel model = execute(files, es, Analysis(generateCallGraph(full(), CHA())));
		
	cg = transformToFullNames(model);	
	
	//println("CG=<model.methodMap>");
  //render(toFigure(cg));
	return true;
}

test bool testInitial_2() {
  MethodBody b = methodBody(  
    [localVariableDeclaration(TArray(TObject("java.lang.String")),"r6"),
    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"$r0"),
    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"r1"),
    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"r2"),
    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"$r3"),
    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"r4"),
    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"r5")],
    [identity("r6","@parameter0",TArray(TObject("java.lang.String"))),
    assign(localVariable("$r0"),newInstance(TObject("samples.pointsto.ex2.O"))),
    invokeStmt(specialInvoke("$r0",methodSignature("samples.pointsto.ex2.O",TVoid(),"\<init\>",[]),[])),
    assign(localVariable("r1"),immediate(local("$r0"))),
    assign(localVariable("r2"),immediate(local("r1"))),
    assign(localVariable("$r3"),newInstance(TObject("samples.pointsto.ex2.O"))),
    invokeStmt(specialInvoke("$r3",methodSignature("samples.pointsto.ex2.O",TVoid(),"\<init\>",[]),[])),
    assign(localVariable("r4"),immediate(local("$r3"))),
    assign(fieldRef("r1",fieldSignature("samples/pointsto/ex2/O",TObject("samples.pointsto.ex2.O"),"f")),immediate(local("r4"))),
    assign(localVariable("r5"),invokeExp(staticMethodInvoke(
      methodSignature(
      "samples.pointsto.ex2.FooBar",
      TObject("samples.pointsto.ex2.O"),
      "bar",
      [TObject("samples.pointsto.ex2.O")]),
      [local("r2")]))),
    returnEmptyStmt()], []);
    
  Method main = method([Public(), Static()], TVoid(), "main", [], [], b);


  MethodBody c = methodBody(
    [localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"$r1"),
    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"r1")],
    [identity("r1","@parameter0",TArray(TObject("samples.pointsto.ex2.O"))),
    assign(localVariable("$r1"),localFieldRef("r1", "samples.pointsto.ex2.O", TObject("samples.pointsto.ex2.O"), "f")),
    retStmt(local("$r1"))], []);
  
  Method bar =  method([Static()], TObject("samples.pointsto.ex2.O"), "bar", [], [], c);
    
  PointerAssignGraph pag = buildsPointsToGraph([main, bar]);
  //println("CG=<pag>");
  render(toFigure(pag));  
  return true;
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