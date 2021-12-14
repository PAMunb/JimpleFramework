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
import lang::jimple::util::JPrettyPrinter;

import lang::jimple::analysis::pointsto::spark::Spark;
import lang::jimple::analysis::pointsto::spark::PointerAssignmentGraph;
import lang::jimple::analysis::pointsto::spark::PointerAssignmentGraphBuilder;
import lang::jimple::analysis::pointsto::spark::SparkUtil;

public tuple[list[loc] classPath, list[str] entryPoints] fooBar() {
	//TODO compile class before using: mvn test -DskipTests
	files = [|project://JimpleFramework/target/test-classes/samples/pointsto/simple/|];
	//TODO rever entry points
    es = ["samples.pointsto.simple.FooBar.foo()", "samples.pointsto.simple.FooBar.bar(samples.pointsto.simple.Node)"];
    return <files, es>;
}

public tuple[list[loc] classPath, list[str] entryPoints] fooBarStatic() {
	files = [|project://JimpleFramework/target/test-classes/samples/pointsto/simple/|];
	//TODO rever entry points
    es = ["samples.pointsto.simple.FooBarStatic.foo()", "samples.pointsto.simple.FooBarStatic.bar(samples.pointsto.simple.Node)"];
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

public void toJimple(){
	// possible tests	
	tuple[list[loc] cp, list[str] e] t = fooBar();

    classPath = t.cp;
    entryPoints = t.e;
	ExecutionContext ctx = createExecutionContext(classPath, entryPoints, true);
	
	for(className <- ctx.ct){
		
		println(prettyPrint(ctx.ct[className].dec));
	}
}
