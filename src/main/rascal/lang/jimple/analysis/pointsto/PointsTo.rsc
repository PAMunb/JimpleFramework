module lang::jimple::analysis::pointsto::PointsTo

import lang::jimple::core::Syntax;
import lang::jimple::core::Context; 

import lang::jimple::analysis::pointsto::PointsToGraph;
import lang::jimple::analysis::pointsto::PointsToGraphBuilder;

import lang::jimple::toolkit::CallGraph;
import lang::jimple::util::Converters;

import analysis::graphs::LabeledGraph;
import analysis::graphs::Graph;
import IO;
import List;
import Map;
import Node;
import Relation;
import Set;
import String;
import Exception;

import Type;
import IO;
import vis::Render;
import lang::jimple::toolkit::PrettyPrinter;

/*
The analysis consists of three stages: 
building the pointer assignment graph, 
simplifying it, 
and then propagating the points-to sets along it to obtain the final solution
*/
public &T(ExecutionContext) pointsToAnalysis(list[str] entryPoints) {
	return PointerAssignGraph(ExecutionContext ctx){
		return execute(ctx, entryPoints);
	};
}

//TODO nao eh esse o tipo de retorno
private PointerAssignGraph execute(ExecutionContext ctx, list[str] entryPoints){
	methodsList = toMethods(ctx, entryPoints);
			
	println("ENTRY POINTS: <entryPoints>");
	println("METHODS: <methodsList>");
	show(ctx);
	
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


/////////////////////// UTIL
public void show(ExecutionContext ctx){			
	top-down visit(ctx.ct) {	 	
  		case ClassOrInterfaceDeclaration c:{
  			show(c);
  		}  			  		
  	}    
}

private void show(c: classDecl(TObject(name), _, _, _, _, list[Method] methods)){
	println("CLASS: <name>");
	
	println(c);
	//show(methods);	
}

private void show(interfaceDecl(TObject(name), _, _, _, list[Method] methods)){
	println("INTERFACE: <name>");
	show(methods);	
}

private void show(list[Method] methods){
	for(Method m <- methods){
		show(m);
	}
}

private void show(method(_, _, Name name, list[Type] args, _, MethodBody body)){
	println("\t - <name>(<intercalate(",", args)>)");
	show(body);
}

private void show(methodBody(list[LocalVariableDeclaration] localVariableDecls, list[Statement] stmts, _)){
	println("\t\tlocals:");
	for(LocalVariableDeclaration local <- localVariableDecls){
		show(local);
	}
}

private void show(LocalVariableDeclaration l){
	println("\t\t\t - <l>");
	//println("\t\t\t     local= <l.local>");
}
