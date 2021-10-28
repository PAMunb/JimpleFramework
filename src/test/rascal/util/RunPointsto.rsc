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
