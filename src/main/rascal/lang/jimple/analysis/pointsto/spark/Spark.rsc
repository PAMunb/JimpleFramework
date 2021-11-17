module lang::jimple::analysis::pointsto::spark::Spark

import lang::jimple::core::Context;
import lang::jimple::core::Syntax;
import lang::jimple::util::Converters;

import lang::jimple::analysis::pointsto::spark::PointerAssignmentGraph;
import lang::jimple::analysis::pointsto::spark::PointerAssignmentGraphBuilder;
import lang::jimple::analysis::pointsto::spark::SparkUtil;

import Exception;
import IO;
import List;
import Set;
import String;

import vis::Render;



public &T(ExecutionContext) pointsToAnalysis(list[str] entryPoints) {
	return PointerAssignGraph(ExecutionContext ctx){
		return execute(ctx, entryPoints);
	};
}			

//TODO nao eh esse o tipo de retorno
private PointerAssignGraph execute(ExecutionContext ctx, list[str] methods){
	// select the entry points
	entrypoints = selectEntryPoints(ctx, methods);

	//build pointer assignement graph
	PointerAssignGraph pag = buildsPointsToGraph(ctx, entrypoints);
	
	//simplify pointer assignement graph
	//...
	
	//points-to set propagator
	//...
	
	//return points-to analysis result
	//...
	
	return pag;
}		

list[MethodSignature] selectEntryPoints(ExecutionContext ctx, list[str] givenMethods) = [toMethodSignature(m,ctx) | m <- givenMethods, m in ctx.mt];


MethodSignature toMethodSignature(str ms, ExecutionContext ctx) {
	Name className = getClassName(ms);
	if(className != ""){
		m = ctx.mt[ms].method;		
		return methodSignature(className, m.returnType, m.name, m.formals);
	}
	throw IllegalArgument(methodSignature, "The method does not exist in the execution context.");
}

str getClassName(str methodSignature) {
	if(contains(methodSignature,"(") && contains(methodSignature,".")){
		untilMethodName = substring(methodSignature,0,findFirst(methodSignature,"("));	
		return substring(untilMethodName,0,findLast(untilMethodName,"."));
	}
	return "";
}

////////////////////////////////////////////
tuple[list[loc] classPath, list[str] entryPoints] fooBar() {
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

