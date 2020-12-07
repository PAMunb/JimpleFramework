module lang::jimple::toolkit::ValueFlowGraph

import lang::jimple::core::Context; 
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;

import lang::jimple::util::JPrettyPrinter;

import Relation;
import Type;
import Set;
import List;
import String;
import analysis::graphs::Graph;
import vis::Figure;
import vis::ParseTree;
import vis::Render;
import IO;

alias ValueFlowGraph = LGraph[ValueFlowNode,ValueFlowEdge];

data ValueFlowNodeType = sourceNode()
					| sinkNode()
					| simpleNode()
					| callSiteNode();
					
data ValueFlowEdgeType = callSiteOpenEdge()
					| callSiteCloseEdge()
					| simpleEdge();
					
//data ValueFlowEdge = valueFlowEdge(Name className, Method callerMethod, Method calleeMethod, Statement stmt, ValueFlowEdgeType edgeType);
data ValueFlowEdge = valueFlowEdge(ValueFlowEdgeType edgeType);
					
data ValueFlowNode = valueFlowNode(Name className, Name methodName, Statement stmt, ValueFlowNodeType nodeType);


//public bool isCallSiteOpen(valueFlowEdge(_, _, _, _, callSiteOpenEdge())) = true;
//public bool isCallSiteOpen(valueFlowEdge(_, _, _, _, _)) = false;
public bool isCallSiteOpen(valueFlowEdge(callSiteOpenEdge())) = true;
public bool isCallSiteOpen(valueFlowEdge(_)) = false;

//public bool isCallSiteClose(valueFlowEdge(_, _, _, _, callSiteCloseEdge())) = true;
//public bool isCallSiteClose(valueFlowEdge(_, _, _, _, _)) = false;
public bool isCallSiteClose(valueFlowEdge(callSiteCloseEdge())) = true;
public bool isCallSiteClose(valueFlowEdge(_)) = false;


public Figure toFigure(ValueFlowGraph g){
	procs = toList(carrier(g));
	println("PROCS...........................");  
	for(p <- procs){
		println(p);
	}
	//nodes = [];
	//edges = [];
	println("GRAFO ......");
	for(a <- g){
		println("a=<a>");
		println("\tFROM=<a.from>");
		println("\tTO=<a.to>");
		//from = box(text(a.from), id(a.from), size(50), fillColor("lightgreen"));
		//to = box(text(a.to), id(a.to), size(50), fillColor("lightgreen"));
		//if(! (from in nodes)){
		//	nodes = nodes + from;
		//}
	}
	
	//nodes = [box(text(nn), id(nn), size(50), fillColor("lightgreen")) | nn <- procs];
	nodes = [box(text(prettyPrint(stmt)), id(prettyPrint(stmt)), size(50), fillColor("lightgreen")) | nn: valueFlowNode(Name className, Name methodName, Statement stmt, ValueFlowNodeType nodeType) <- procs];
	println("NODES=<nodes>");
	return toFigure(g, nodes);
}
private Figure toFigure(ValueFlowGraph g, Figures nodes){
    edges = [edge(prettyPrint(c.from),prettyPrint(c.to)) | c <- g];   
    return scrollable(graph(nodes, edges, hint("layered"), std(size(20)), std(gap(10))));
}



public str toDot(ValueFlowGraph g, str title) {
	return "digraph <title> {
         '  fontname = \"Bitstream Vera Sans\"
         '  fontsize = 8
         '  node [ fontname = \"Bitstream Vera Sans\" fontsize = 8 shape = \"record\" ]
         '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
         '
         '  <for (call <- g) {>                  
         '  \"<prettyPrint(call.from.stmt)>\" -\> \"<prettyPrint(call.to.stmt)>\" <}>
         '}";	
         //'  \"<call.from>\" -\> \"<call.to>\" [arrowhead=\"empty\"]<}>
}

