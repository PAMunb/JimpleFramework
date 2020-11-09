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
//import Map;
import Relation;
import Type;
import Set;
//import List;
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
	methodSig = "samples.dataflow.SimpleVeryBusyExpression.veryBusy(int,int,int,int)";
	//methodSig = "samples.dataflow.SimpleVeryBusyExpression.veryBusy()";
	//body = ctx.mt[methodSig].method.body;
	body = getMethodBody();
	
	fg = forwardFlowGraph(body);
	//fg = backwardFlowGraph(body);
	
	//println(fg);

	render(toFigure(fg));
	println(toDot(fg));
	
	println(prettyPrint(body));
}

public void testVeryBusyExpressions(){
	files = [|project://JimpleFramework/target/test-classes/samples/dataflow/SimpleVeryBusyExpression.class|];
	methodSig = "samples.dataflow.SimpleVeryBusyExpression.veryBusy(int,int,int,int)";
	
	AnalysisResult[Expression] veryBusyExpressions = execute(files, methodSig, vb);	

	print(veryBusyExpressions);
}
private MethodBody getMethodBody(){
	Statement s1  = ifStmt(cmpeq(local("a"),local("b")),"label1");
	Statement s2  = assign(localVariable("x"),minus(local("b"),local("a")));
	Statement s3  = assign(localVariable("y"),minus(local("a"),local("b")));
	Statement s4  = gotoStmt("label2");
	Statement s5  = label("label1");
	Statement s6  = assign(localVariable("y"),minus(local("b"),local("a")));
	Statement s7  = assign(localVariable("a"),immediate(iValue(intValue(0))));
	Statement s8  = assign(localVariable("x"),minus(local("a"),local("b")));
	Statement s9  = label("label2");
	Statement s10  = returnEmptyStmt();	
	
	list[Statement] ss = [ s1,  s2,  s3,  s4,  s5,  s6,  s7,  s8, s9, s10 ]; 
  
	return methodBody([], ss, []);
}
private MethodBody getMethodBodyPPA(){
	Statement s1  = ifStmt(cmpgt(local("a"),local("b")),"label1");
	Statement s6  = assign(localVariable("y"),minus(local("b"),local("a")));
	Statement s8  = assign(localVariable("x"),minus(local("a"),local("b")));
	Statement s4  = gotoStmt("label2");
	
	Statement s5  = label("label1");
	Statement s2  = assign(localVariable("x"),minus(local("b"),local("a")));
	Statement s3  = assign(localVariable("y"),minus(local("a"),local("b")));
	
	Statement s9  = label("label2");
	Statement s10  = returnEmptyStmt();	
	
	list[Statement] ss = [ s1,  s2,  s3,  s4,  s5,  s6,  s8, s9, s10 ]; 
  
	return methodBody([], ss, []);
}
public void main(){
	testVeryBusyExpressions2();
}
public void testVeryBusyExpressions2(){
	files = [|project://JimpleFramework/target/test-classes/samples/dataflow/SimpleVeryBusyExpression.class|];
	methodSig = "samples.dataflow.SimpleVeryBusyExpression.ppa(int,int,int,int)";
	ExecutionContext ctx = createExecutionContext(files,[],true);	
	b = ctx.mt[methodSig].method.body;
	//b = getMethodBody();
	//b = getMethodBodyPPA();
	
	g = backwardFlowGraph(b); 
	//render(toFigure(g));
   	btm = exitNode(); 
	Abstraction[Expression] set1 = ();
	//Abstraction[Expression] set1 = (btm : vb.tf.boundary()) + (stmtNode(s) : vb.tf.init(b) | s <- b.stmts); 
   	Abstraction[Expression] set2 = (btm : vb.tf.boundary()) + (stmtNode(s) : vb.tf.init(b) | s <- b.stmts); 
   	Abstraction[Expression] genSet  = (stmtNode(s): vb.tf.gen(s)  | s <- b.stmts); 
   	Abstraction[Expression] killSet = (stmtNode(s): vb.tf.kill(s) | s <- b.stmts); 
   	
   	println("\n****************** GEN_KILL SETS");
   	printGenKill(genSet,killSet);
   	
   	println("\n\n****************** ITERATION 0");
   	printTable(<set2,set1>); 
   	
   	int iteration = 1;
   	list[Node] ns = [stmtNode(s) | s <- b.stmts];  
   	//while( iteration < 5 ) { 
   	solve(set2) {
   		println("\n\n****************** ITERATION <iteration>");
   		for(n <- ns) {
   			//println("***** node=<n>");
	    	set1[n]  = (vb.tf.init(b) | merge(vb.opr, it, set2[from]) | <from, to> <- g, to := n); 
	    	//set1[n]  = (merge(Intersection(), vb.tf.init(b) , set2[from]) | <from, to> <- g, to := n);
	     	set2[n] = genSet[n] + (set1[n] - killSet[n]);
	     	//println("******** IN = <set1>");
	     	//println("******** OUT = <set2>");     
	     	
	  	}	 
	  	printTable(<set2,set1>);  	
	  	iteration = iteration + 1;
   	}
  	
}

private set[&T] merge(Union(), set[&T] s1, set[&T] s2) = s1 + s2;           // merge using the union operator
private set[&T] merge(Intersection(), set[&T] s1, set[&T] s2) = s1 & s2; 

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

private void printGenKill(Abstraction[Expression] genSet, Abstraction[Expression] killSet){
	//println("GEN_KILL");
	for(n <- genSet){
		str noStr = right(toString(n),23);
		println("<noStr> \t <tmp(genSet[n])> \t <tmp(killSet[n])>");
	}
}
private void printTable(AnalysisResult[&T] result){
	//println("RESULT_TABLE ....<result>");
	str noTitle = "NODE";
	println("<right(noTitle,23)> \t IN \t OUT");
	//lista = sort(toList(result.inSet));
	lista = result.inSet;
	for(n <- lista){
		str noStr = right(toString(n),23);
		if(n in result.outSet){
			println("<noStr> \t <tmp(result.inSet[n])> \t <tmp(result.outSet[n])>");
		}else{
			println("<noStr> \t <tmp(result.inSet[n])> \t { }");
		}
	}
}
private void print(AnalysisResult[&T] result){
	println("RESULT:");
	for(n <- result.inSet){
		println("NODE: <toString(n)>");
		println("\t IN: <tmp(result.inSet[n])>");
		if(n in result.outSet){
			//tmp(result.outSet[n]);
			//println("\t OUT: <result.outSet[n]>");
			println("\t OUT: <tmp(result.outSet[n])>");
		}
	}
}

private set[str] tmp(set[&T] conjunto){
	set[str] retorno = {};
	for(c <- conjunto){
		retorno = retorno + prettyPrint(c);
	}
	return retorno;
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

private str toString(entryNode()) = "ENTRY";
private str toString(exitNode()) = "EXIT";
private str toString(s:stmtNode(_)) = prettyPrint(s.s);


private tuple[str, Figure] toNode(s:entryNode()){
	name = toString(s);	
	flowGraphNode = box(text(name), id(name), size(50), fillColor("blue"));
	return <name,flowGraphNode>;
}
private tuple[str, Figure] toNode(s:exitNode()){
	name = toString(s);	
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

public str toDot(FlowGraph fg){
	//procs = toList(carrier(fg));  
		
	return "digraph teste {
         '  fontname = \"Bitstream Vera Sans\"
         '  fontsize = 8
         '  node [ fontname = \"Bitstream Vera Sans\" fontsize = 8 shape = \"record\" ]
         '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
         '
         '  <for (call <- carrier(fg)) {>                  
         '  <startDot(call)> <}>
         '
         '  <for (call <- fg) {>                  
         '  \"<toDot(call.from)>\" -\> \"<toDot(call.to)>\" <}>
         '}";	         	
}

private str startDot(s:entryNode()){
	return "\"<toDot(s)>\" [shape=ellipse,style=filled,color=\"blue\"]";
}
private str startDot(s:exitNode()){
	return "\"<toDot(s)>\" [shape=ellipse,style=filled,color=\"red\"]";
}
private str startDot(s:stmtNode(ifStmt(Expression exp, Label target))){
	return "\"<toDot(s)>\" [shape=diamond,style=filled,color=\".7 .3 1.0\"]";
}
private str startDot(s:stmtNode(_)){
	return "\"<toDot(s)>\" [shape=box,style=filled,color=\"lightgreen\"]";
}
private str toDot(s:stmtNode(_)){
	return prettyPrint(s.s);
}
private str toDot(entryNode()){
	return "ENTRY";	
}
private str toDot(exitNode()){
	return "EXIT";	
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
	//for(Method m <- methods){
	//	show(m);
	//}
}
/*private void show(method(_, _, Name name, list[Type] args, _, body)){
	println("\t - <name>(<intercalate(",", args)>)");
	show(body);
}

private void show(methodBody(_, list[Statement] stmts, _)){
	for(stmt <- stmts){
		println("\t\t - <stmt>");
	}
}*/