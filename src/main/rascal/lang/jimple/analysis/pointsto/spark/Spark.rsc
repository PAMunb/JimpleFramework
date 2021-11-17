module lang::jimple::analysis::pointsto::spark::Spark

import lang::jimple::core::Context;
import lang::jimple::core::Syntax;
import lang::jimple::util::Converters;

import analysis::graphs::Graph;
import analysis::graphs::LabeledGraph;

import lang::jimple::analysis::pointsto::spark::PointerAssignmentGraph;
import lang::jimple::analysis::pointsto::spark::PointerAssignmentGraphBuilder;
import lang::jimple::analysis::pointsto::spark::SparkUtil;
//import lang::jimple::analysis::pointsto::PointsToGraph;

import IO;
import List;
import Relation;
import Set;
//import vis::Figure;
import vis::Render;





public &T(ExecutionContext) pointsToAnalysis(list[str] entryPoints) {
	return PointerAssignGraph(ExecutionContext ctx){
		return execute(ctx, entryPoints);
	};
}			

//TODO nao eh esse o tipo de retorno
private PointerAssignGraph execute(ExecutionContext ctx, list[str] entryPoints){
	methodsList = toMethods(ctx, entryPoints);

	//build pointer assignement graph
	PointerAssignGraph pag = buildsPointsToGraph(methodsList);
	
	//simplify pointer assignement graph
	//...
	//points-to set propagator
	//...
	//return points-to analysis result
	//...
	
	return pag;
}		


private list[Method] toMethods(ExecutionContext ctx, list[str] entryPoints){
	methodsList = [];	
	for(e <- entryPoints){
		methodsList = methodsList + ctx.mt[e].method;
	}
	return methodsList;
}		



////////////////////////////////////////////
public tuple[list[loc] classPath, list[str] entryPoints] fooBar() {
	//TODO compile class before using: mvn test -DskipTests
	files = [|project://JimpleFramework/target/test-classes/samples/pointsto/simple/|];
	//TODO rever entry points
    es = ["samples.pointsto.simple.FooBar.foo()", "samples.pointsto.simple.FooBar.bar(samples.pointsto.simple.Node)"];
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

public void p2(){
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
  //render(toFigure(pag));  
}


