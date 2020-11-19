module lang::jimple::toolkit::ValueFlowGraph

import lang::jimple::core::Context; 
import lang::jimple::core::Syntax;
import analysis::graphs::LabeledGraph;

//alias LGraph[&T,&L] = rel[&T from, &L label, &T to];
alias ValueFlowGraph = LGraph[ValueFlowNode,ValueFlowEdge];

data ValueFlowNode = sourceNode()
					| sinkNode()
					| simpleNode()
					| callSiteNode();
					
data ValueFlowEdge = callSiteOpenEdge()
					| callSiteCloseEdge();
					
					