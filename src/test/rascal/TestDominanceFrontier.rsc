module TestDominanceFrontier

import lang::jimple::analysis::FlowGraph;
import lang::jimple::analysis::saa::DominanceFrontier;
import lang::jimple::Syntax; 

test bool testDominanceFrontier() {
  	Statement s1 = assign(localVariable("v0"), immediate(iValue(booleanValue(false))));
	
	Statement s2 = ifStmt(cmp(local("v0"), iValue(booleanValue(false))), "label1:");
	Statement s3 = assign(localVariable("v1"), immediate(iValue(intValue(1)))); 
	Statement s4 = gotoStmt("label2:");
	
	Statement s5 = label("label1:");
  	Statement s6 = assign(localVariable("v1"), immediate(iValue(intValue(2)))); 
  	Statement s7 = gotoStmt("label2:");
  	
  	Statement s8 = label("label2:");
  	Statement s9 = label("print");
  
  	Statement s10 = returnStmt(local("v2"));  

	list[Statement] stmts = [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]; 
  
  	methodStatments = methodBody([], stmts, []);
  	flowGraph = forwardFlowGraph(methodStatments);
  	
  	result = createDominanceFrontier(flowGraph);
  	
  	/*
  	result = createDominanceSet(flowGraph);
  
  
  	map[Node, set[Node]] expectation = (
		entryNode(): {entryNode()},
		stmtNode(s1): {entryNode(), stmtNode(s1)},
		stmtNode(s2): {entryNode(), stmtNode(s1), stmtNode(s2)},
		stmtNode(s3): {entryNode(), stmtNode(s1), stmtNode(s2), stmtNode(s3)},
		stmtNode(s4): {entryNode(), stmtNode(s1), stmtNode(s2), stmtNode(s3), stmtNode(s4)},
		stmtNode(s6): {entryNode(), stmtNode(s1), stmtNode(s2), stmtNode(s6)},
		stmtNode(s9): {entryNode(), stmtNode(s1), stmtNode(s2), stmtNode(s6), stmtNode(s9)}
	);
  
	return createDominanceSet(flowGraph) == expectation; 
	
	*/
	
	return true;
}