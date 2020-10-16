module TestDominanceTree

import lang::jimple::analysis::FlowGraph;
import lang::jimple::analysis::saa::DominanceTree;
import lang::jimple::Syntax; 

test bool testDominanceTree() {
  	Statement s1 = assign(localVariable("v0"), immediate(iValue(booleanValue(false))));
	
	Statement s2 = ifStmt(cmp(local("v0"), iValue(booleanValue(false))), "label1:");
	Statement s3 = assign(localVariable("v1"), immediate(iValue(intValue(1)))); 
	Statement s4 = gotoStmt("label2:");
	
	Statement s5 = label("label1:");
  	Statement s6 = assign(localVariable("v2"), immediate(iValue(intValue(2)))); 
  	
  	Statement s7 = label("label2:");
  	Statement s8 = label("print"); 	
  
  	Statement s9 = returnStmt(local("v2"));  

	list[Statement] stmts = [s1, s2, s3, s4, s5, s6, s7, s8, s9]; 
  
  	methodStatments = methodBody([], stmts, []);
  	flowGraph = forwardFlowGraph(methodStatments);
  
  	rel[&T, set[&T]] expectation = {
	  <stmtNode(assign(
	      localVariable("v2"),
	      immediate(iValue(intValue(2))))),{
	    stmtNode(returnStmt(local("v2"))),
	    exitNode()
	  }>,
	  <entryNode(),{
	    stmtNode(assign(
	        localVariable("v2"),
	        immediate(iValue(intValue(2))))),
	    stmtNode(ifStmt(
	        cmp(
	          local("v0"),
	          iValue(booleanValue(false))),
	        "label1:")),
	    stmtNode(returnStmt(local("v2"))),
	    stmtNode(gotoStmt("label2:")),
	    stmtNode(assign(
	        localVariable("v0"),
	        immediate(iValue(booleanValue(false))))),
	    stmtNode(assign(
	        localVariable("v1"),
	        immediate(iValue(intValue(1))))),
	    exitNode(),
	    stmtNode(label("print"))
	  }>,
	  <stmtNode(ifStmt(
	      cmp(
	        local("v0"),
	        iValue(booleanValue(false))),
	      "label1:")),{
	    stmtNode(assign(
	        localVariable("v2"),
	        immediate(iValue(intValue(2))))),
	    stmtNode(returnStmt(local("v2"))),
	    stmtNode(gotoStmt("label2:")),
	    stmtNode(assign(
	        localVariable("v1"),
	        immediate(iValue(intValue(1))))),
	    exitNode(),
	    stmtNode(label("print"))
	  }>,
	  <stmtNode(returnStmt(local("v2"))),{exitNode()}>,
	  <stmtNode(gotoStmt("label2:")),{stmtNode(label("print"))}>,
	  <stmtNode(assign(
	      localVariable("v0"),
	      immediate(iValue(booleanValue(false))))),{
	    stmtNode(assign(
	        localVariable("v2"),
	        immediate(iValue(intValue(2))))),
	    stmtNode(ifStmt(
	        cmp(
	          local("v0"),
	          iValue(booleanValue(false))),
	        "label1:")),
	    stmtNode(returnStmt(local("v2"))),
	    stmtNode(gotoStmt("label2:")),
	    stmtNode(assign(
	        localVariable("v1"),
	        immediate(iValue(intValue(1))))),
	    exitNode(),
	    stmtNode(label("print"))
	  }>,
	  <stmtNode(assign(
	      localVariable("v1"),
	      immediate(iValue(intValue(1))))),{
	    stmtNode(gotoStmt("label2:")),
	    stmtNode(label("print"))
	  }>,
	  <exitNode(),{}>,
	  <stmtNode(label("print")),{}>
	};
  
	return createDominanceTree(flowGraph) == expectation; 
}
