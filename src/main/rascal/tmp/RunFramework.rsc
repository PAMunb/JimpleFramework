module tmp::RunFramework

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;

//import lang::jimple::toolkit::GraphUtil;
import lang::jimple::toolkit::CallGraph;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::toolkit::PrettyPrinter;
import lang::jimple::util::Converters;
import lang::jimple::util::JPrettyPrinter;

import lang::jimple::analysis::dataflow::Framework; 
import lang::jimple::analysis::dataflow::AvailableExpressions;
import lang::jimple::analysis::dataflow::LiveVariable;
import lang::jimple::analysis::dataflow::ReachDefinition; 
import lang::jimple::analysis::dataflow::VeryBusyExpressions;

import IO;
import Map;
import Relation;
import Type;
import Set;
import List;
import String;
import util::Math;
import analysis::graphs::Graph;

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
	files = [|project://JimpleFramework/target/test-classes/samples/dataflow/SimpleVeryBusyExpression.class|];
	methodSig = "samples.dataflow.SimpleVeryBusyExpression.veryBusy()";
	
	AnalysisResult[Expression] veryBusyExpressions = execute(files, methodSig, vb);	

	print(veryBusyExpressions);
}

public void testAvailableExpressions(){
	files = [|project://JimpleFramework/target/test-classes/samples/dataflow/SimpleAvailableExpression.class|];
	methodSig = "samples.dataflow.SimpleAvailableExpression.available(int,int)";
	
	AnalysisResult[Expression] availableExpressions = execute(files, methodSig, ae);	

	print(availableExpressions);
}

public void testReachDefinition(){
	files = [|project://JimpleFramework/target/test-classes/samples/dataflow/SimpleReachDefinition.class|];
	methodSig = "samples.dataflow.SimpleReachDefinition.factorial(int)";
			
	AnalysisResult[Statement] reachDefs = execute(files, methodSig, rd);	

	print(reachDefs);	
}

public void testLiveVariable(){
	files = [|project://JimpleFramework/target/test-classes/samples/dataflow/SimpleLiveVariable.class|];	
	methodSig = "samples.dataflow.SimpleLiveVariable.live()";
	
	AnalysisResult[LocalVariable] liveVariables = execute(files, methodSig, lv);	

	print(liveVariables);
}


private AnalysisResult[&T] execute(list[loc] files, str methodSig, DFA[&T] dfa){
	ExecutionContext ctx = createExecutionContext(files,[],true);	
	body = ctx.mt[methodSig].method.body;	
	return execute(dfa, body);	
}


private void print(AnalysisResult[&T] result){
	println("RESULT:");
	for(n <- result.inSet){
		println("NODE: <n>");
		println("\t IN: <result.inSet[n]>");
		if(n in result.outSet){
			println("\t OUT: <result.outSet[n]>");
		}
	}
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