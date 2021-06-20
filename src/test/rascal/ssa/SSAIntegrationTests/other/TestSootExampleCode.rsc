module ssa::SSAIntegrationTests::other::TestSootExampleCode

import Set;
import lang::jimple::toolkit::FlowGraph;
import ssa::SSAIntegrationTests::util::CreateClassfileSSAFlowGraph;

test bool testSootSampleCodeMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/other/SootExampleCode.class|;
	int methodToTest = 1;
	FlowGraph result = createClassFileSSAFlowGraph(classFilePath, methodToTest);

	// I think this return may be incorrect, because seems that the returned value should be the phiFunction one, the r1_version-1.
	// Also, the r1_version-0 isn`t in the phi_function list of varaibles defined for r1.
	return {
	  <entryNode(),
	    stmtNode(identity("r0","@this",TObject("samples.ssa.other.SootExampleCode")))>,
	  <stmtNode(gotoStmt("label3")),
	    stmtNode(returnStmt(local("r1_version-0")))>,
	  <stmtNode(assign(localVariable("r1_version-1"),phiFunction(localVariable("r1"),[localVariable("r1_version-2")]))),
	    stmtNode(ifStmt(cmpeq(local("r1_version-1"),iValue(intValue(100))),"label1"))>,
	  <stmtNode(assign(localVariable("r1_version-2"),immediate(iValue(intValue(200))))),
	    stmtNode(assign(localVariable("r1_version-1"),phiFunction(localVariable("r1"),[localVariable("r1_version-2")])))>,
	  <stmtNode(returnStmt(local("r1_version-0"))),
	    exitNode()>,
	  <stmtNode(identity("r0","@this",TObject("samples.ssa.other.SootExampleCode"))),
	    stmtNode(assign(localVariable("r1_version-0"),immediate(iValue(intValue(100)))))>,
	  <stmtNode(assign(localVariable("r1_version-0"),immediate(iValue(intValue(100))))),
	    stmtNode(gotoStmt("label3"))>,
	  <stmtNode(assign(localVariable("r1_version-0"),immediate(iValue(intValue(100))))),
	    stmtNode(assign(localVariable("r1_version-1"),phiFunction(localVariable("r1"),[localVariable("r1_version-2")])))>,
	  <stmtNode(ifStmt(cmpge(local("r1_version-1"),iValue(intValue(200))),"label2")),
	    stmtNode(assign(localVariable("r1_version-0"),immediate(iValue(intValue(100)))))>,
	  <stmtNode(ifStmt(cmpge(local("r1_version-1"),iValue(intValue(200))),"label2")),
	    stmtNode(assign(localVariable("r1_version-2"),immediate(iValue(intValue(200)))))>,
	  <stmtNode(ifStmt(cmpeq(local("r1_version-1"),iValue(intValue(100))),"label1")),
	    stmtNode(gotoStmt("label3"))>,
	  <stmtNode(ifStmt(cmpeq(local("r1_version-1"),iValue(intValue(100))),"label1")),
	    stmtNode(ifStmt(cmpge(local("r1_version-1"),iValue(intValue(200))),"label2"))>,
	  <stmtNode(ifStmt(cmpeq(local("r1_version-1"),iValue(intValue(100))),"label1")),
	    stmtNode(returnStmt(local("r1_version-0")))>
	};
}