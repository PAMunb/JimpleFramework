module TestVariableRenaming

import analysis::graphs::Graph;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;
import lang::jimple::toolkit::ssa::DominanceTree;
import lang::jimple::toolkit::ssa::PhiFunctionInsertion; 
import lang::jimple::toolkit::ssa::VariableRenaming;

test bool testVariableRenaming() {
	Statement s1 = assign(localVariable("v0"), immediate(iValue(booleanValue(false))));

	Statement s2 = ifStmt(cmp(local("v0"), iValue(booleanValue(false))), "label1:");
	Statement s3 = assign(localVariable("v1"), immediate(iValue(intValue(1))));
	Statement s4 = gotoStmt("print");

	Statement s5 = label("label1:");
  	Statement s6 = assign(localVariable("v1"), immediate(iValue(intValue(2))));
  	Statement s7 = gotoStmt("print");

  	Statement s8 = label("print");
  	Statement s9 = returnStmt(local("v2"));

	list[Statement] stmts = [s1, s2, s3, s4, s5, s6, s7, s8, s9];

  	methodStatments = methodBody([], stmts, []);
  	flowGraph = forwardFlowGraph(methodStatments);	
  	map[&T, set[&T]] dominanceTree = createDominanceTree(flowGraph);

	FlowGraph phiFunctionFlowGraph = {
		<stmtNode(assign(localVariable("v1"), immediate(iValue(intValue(2))))), stmtNode(phiFunction(localVariable("v1")))>,
		<stmtNode(phiFunction(localVariable("v1"))), stmtNode(gotoStmt("print"))>,
		<entryNode(), stmtNode(assign(localVariable("v0"),immediate(iValue(booleanValue(false)))))>,
		<stmtNode(returnStmt(local("v2"))) ,exitNode()>,
		<stmtNode(assign(localVariable("v0"), immediate(iValue(booleanValue(false))))),stmtNode(ifStmt(cmp(local("v0"), iValue(booleanValue(false))), "label1:"))>,
		<stmtNode(assign(localVariable("v1"), immediate(iValue(intValue(1))))), stmtNode(phiFunction(localVariable("v1")))>,
		<stmtNode(gotoStmt("print")),stmtNode(returnStmt(local("v2")))>,
		<stmtNode(ifStmt(cmp(local("v0"), iValue(booleanValue(false))), "label1:")), stmtNode(assign(localVariable("v1"), immediate(iValue(intValue(2)))))>,
		<stmtNode(ifStmt(cmp(local("v0"),iValue(booleanValue(false))),"label1:")), stmtNode(assign(localVariable("v1"), immediate(iValue(intValue(1)))))>
	};
	
	
	applyVariableRenaming(phiFunctionFlowGraph, dominanceTree);
	
	return false;
}

test bool testLeftHandSideImmediatesRename() {
	Statement s1 = assign(localVariable("v0"), immediate(iValue(booleanValue(false))));
	Statement s2 = assign(localVariable("v1"), immediate(iValue(booleanValue(true))));

	list[Statement] stmts = [s1, s2];

  	methodStatments = methodBody([], stmts, []);
  	flowGraph = forwardFlowGraph(methodStatments);	
  	map[&T, set[&T]] dominanceTree = createDominanceTree(flowGraph);
	FlowGraph phiFunctionFlowGraph = insertPhiFunctions(flowGraph, dominanceTree);
	
	FlowGraph result = applyVariableRenaming(phiFunctionFlowGraph, dominanceTree);
	
	return result == {
	  <entryNode(),stmtNode(assign(localVariable("v0_version-0"), immediate(iValue(booleanValue(false)))))>,
	  <stmtNode(assign(localVariable("v0_version-0"),immediate(iValue(booleanValue(false))))), stmtNode(assign(localVariable("v1_version-0"), immediate(iValue(booleanValue(true)))))>,
	  <stmtNode(assign(localVariable("v1_version-0"), immediate(iValue(booleanValue(true))))), exitNode()>
	};
}


test bool testRightHandSideImmediatesRename() {
	Statement s1 = assign(localVariable("v0"), immediate(iValue(booleanValue(false))));
	Statement s2 = assign(localVariable("v1"), immediate(local("v0")));

	list[Statement] stmts = [s1, s2];

  	methodStatments = methodBody([], stmts, []);
  	flowGraph = forwardFlowGraph(methodStatments);	
  	map[&T, set[&T]] dominanceTree = createDominanceTree(flowGraph);
	FlowGraph phiFunctionFlowGraph = insertPhiFunctions(flowGraph, dominanceTree);
	
	FlowGraph result = applyVariableRenaming(phiFunctionFlowGraph, dominanceTree);
	
	return result == {
	  <entryNode(),stmtNode(assign(localVariable("v0"), immediate(iValue(booleanValue(false)))))>,
	  <stmtNode(assign(localVariable("v0"),immediate(iValue(booleanValue(false))))), stmtNode(assign(localVariable("v1"), immediate(local("v0_version-0"))))>,
	  <stmtNode(assign(localVariable("v1"), immediate(local("v0_version-0")))), exitNode()>
	};
}
