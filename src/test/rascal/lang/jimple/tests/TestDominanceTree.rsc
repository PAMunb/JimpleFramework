module lang::jimple::tests::TestDominanceTree

import lang::jimple::toolkit::FlowGraph;
import lang::jimple::toolkit::ssa::DominanceTree;
import lang::jimple::core::Syntax; 

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
  	result = createDominanceTree(flowGraph);
  
  	map[Node, Node] expectation = (
	  stmtNode(assign(
	      localVariable("v2"),
	      immediate(iValue(intValue(2))))):stmtNode(returnStmt(local("v2"))),
	  entryNode():stmtNode(assign(
	      localVariable("v0"),
	      immediate(iValue(booleanValue(false))))),
	  stmtNode(ifStmt(
	      cmp(
	        local("v0"),
	        iValue(booleanValue(false))),
	      "label1:")):stmtNode(assign(
	      localVariable("v1"),
	      immediate(iValue(intValue(1))))),
	  stmtNode(assign(
	      localVariable("v0"),
	      immediate(iValue(booleanValue(false))))):stmtNode(ifStmt(
	      cmp(
	        local("v0"),
	        iValue(booleanValue(false))),
	      "label1:")),
	  stmtNode(assign(
	      localVariable("v1"),
      immediate(iValue(intValue(1))))):stmtNode(gotoStmt("label2:"))
	);
  
	return createDominanceTree(flowGraph) == expectation; 
}
