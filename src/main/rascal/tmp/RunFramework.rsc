module tmp::RunFramework

import lang::jimple::Syntax;
import lang::jimple::core::Context;

import lang::jimple::toolkit::CallGraph;
import lang::jimple::toolkit::GraphUtil;
import lang::jimple::util::Converters;
import lang::jimple::toolkit::PrettyPrinter;
import lang::jimple::util::JPrettyPrinter;

import lang::jimple::analysis::FlowGraph;
import lang::jimple::analysis::dataflow::Framework; 
import lang::jimple::analysis::dataflow::ReachDefinition; 

import IO;
import Map;
import Relation;
import Type;
import Set;
import List;
import util::Math;
import analysis::graphs::Graph;
import String;

import vis::Figure;
import vis::ParseTree;
import vis::Render;


public void testFlowGraph(){
	files = [|project://JimpleFramework/target/test-classes/samples/dataflow/SimpleVeryBusyExpression.class|];
	es = [];
	
	ExecutionContext ctx = createExecutionContext(files,es,true);	
	methodSig = "samples.dataflow.SimpleVeryBusyExpression.veryBusy()";
	body = ctx.mt[methodSig].method.body;
	
	fg = forwardFlowGraph(body);
	
	//println(fg);

	render(toFigure(fg));
}

public void testVeryBusyExpressions(){
	
}

public void testAvailableExpressions(){
	
}

public void testReachDefinition(){
	files = [|project://JimpleFramework/target/test-classes/samples/dataflow/SimpleReachDefinition.class|];
	es = [];
	
	methodSig = "samples.dataflow.SimpleReachDefinition.factorial(int)";
	
	ExecutionContext ctx = createExecutionContext(files,es,true);
	
	tuple[map[Node, set[Statement]] inSet, map[Node, set[Statement]] outSet] reachDefs = execute(rd, ctx.mt[methodSig].method.body);	

	println(reachDefs);	
}




public Figure toFigure(FlowGraph fg){
	procs = toList(carrier(fg));  
	
	map[Node, str] nodesMap = (); 
	
	nodes = [];
	for(p <- procs){
		tuple[str name, Figure figure] n = toNode(p);
		nodes = nodes + n.figure;
		nodesMap[p] = n.name;		
	}
		
	edges = [edge(nodesMap[c.from],nodesMap[c.to]) | c <- fg];   
	
	return scrollable(graph(nodes, edges, hint("layered"), std(size(20)), std(gap(10))));
}

private tuple[str, Figure] toNode(entryNode()){
	name = "ENTRY";	
	flowGraphNode = box(text(name), id(name), size(50), fillColor("blue"));
	return <name,flowGraphNode>;
}
private tuple[str, Figure] toNode(exitNode()){
	name = "EXIT";	
	flowGraphNode = box(text(name), id(name), size(50), fillColor("red"));
	return <name,flowGraphNode>;
}
private tuple[str, Figure] toNode(s:stmtNode(ifStmt(Expression exp, Label target))){
	name = prettyPrint(s.s);
	flowGraphNode = ellipse(text(name), id(name), size(50), fillColor("lightgreen"));
	return <name,flowGraphNode>;
}
private tuple[str, Figure] toNode(s:stmtNode(_)){
	name = prettyPrint(s.s);
	flowGraphNode = box(text(name), id(name), size(50), fillColor("lightgreen"));
	return <name,flowGraphNode>;
}



private void show(list[loc] files, list[str] es){    
    ExecutionContext ctx =  createExecutionContext(files,es,true);	
    show(ctx);
}
private void show(ExecutionContext ctx){			
	top-down visit(ctx.ct) {	 	
  		case ClassOrInterfaceDeclaration c:{
  			show(c);
  		}  			  		
  	}    
}
private void show(classDecl(TObject(name), _, _, _, _, list[Method] methods)){
	println("CLASS: <name>");
	show(methods);	
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
private void show(method(_, _, Name name, list[Type] args, _, body)){
	println("\t - <name>(<intercalate(",", args)>)");
	show(body);
}

private void show(methodBody(_, list[Statement] stmts, _)){
	for(stmt <- stmts){
		println("\t\t - <stmt>");
	}
}