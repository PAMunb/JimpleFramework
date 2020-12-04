module lang::jimple::toolkit::ValueFlowGraph

import lang::jimple::core::Context; 
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;

//alias LGraph[&T,&L] = rel[&T from, &L label, &T to];
alias ValueFlowGraph = LGraph[ValueFlowNode,ValueFlowEdge];

data ValueFlowNodeType = sourceNode()
					| sinkNode()
					| simpleNode()
					| callSiteNode();
					
data ValueFlowEdgeType = callSiteOpenEdge()
					| callSiteCloseEdge();
					
data ValueFlowEdge = valueFlowEdge(Name className, Method callerMethod, Method calleeMethod, Statement stmt, ValueFlowEdgeType edgeType);
					
data ValueFlowNode = valueFlowNode(Name className, Name methodName, Statement stmt, ValueFlowNodeType nodeType);


public bool isCallSiteOpen(valueFlowEdge(_, _, _, _, callSiteOpenEdge())) = true;
public bool isCallSiteOpen(valueFlowEdge(_, _, _, _, _)) = false;

public bool isCallSiteClose(valueFlowEdge(_, _, _, _, callSiteCloseEdge())) = true;
public bool isCallSiteClose(valueFlowEdge(_, _, _, _, _)) = false;