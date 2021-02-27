module ssa::SSAIntegrationTests::TestSootExampleCode

import List;
import Type;

import analysis::graphs::Graph;

import lang::jimple::decompiler::Decompiler;
import lang::jimple::decompiler::jimplify::ProcessLabels;
import lang::jimple::core::Context;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;

import lang::jimple::toolkit::ssa::Generator;

test bool testSootSampleCodeMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/SootExampleCode.class|;
	ClassOrInterfaceDeclaration classFileDeclaration = decompile(classFilePath);
	classFileDeclaration = processJimpleLabels(classFileDeclaration);
	list[Method] methodList = castMethodList(classFileDeclaration);	
	MethodBody methodBody = castMethodBody(methodList[1]);
	
	FlowGraph result = applySSATransformation(methodBody);

	return result == {
	  <entryNode(),
	    stmtNode(identity("r0","@this",TObject("samples.ssa.SootExampleCode")))>,
	
	  <stmtNode(identity("r0","@this",TObject("samples.ssa.SootExampleCode"))),
	    stmtNode(assign(localVariable("r1_version-0"),phiFunction(localVariable("r1"),[localVariable("r1_version-1"),localVariable("r1_version-2")])))>,
	
	  <stmtNode(assign(localVariable("r1_version-0"),phiFunction(localVariable("r1"),[localVariable("r1_version-1"),localVariable("r1_version-2")]))),
	    stmtNode(assign(localVariable("r1_version-2"),immediate(iValue(intValue(100)))))>,
	
	  <stmtNode(assign(localVariable("r1_version-2"),immediate(iValue(intValue(100))))),
	    stmtNode(gotoStmt("label3"))>,
	
	  <stmtNode(gotoStmt("label3")),
	    stmtNode(assign(localVariable("r1_version-0"),phiFunction(localVariable("r1"),[localVariable("r1_version-1"),localVariable("r1_version-2")])))>,
	
	  <stmtNode(assign(localVariable("r1_version-0"),phiFunction(localVariable("r1"),[localVariable("r1_version-1"),localVariable("r1_version-2")]))),
	    stmtNode(ifStmt(cmpeq(local("r1_version-0"),iValue(intValue(100))),"label1"))>,
	
	  <stmtNode(ifStmt(cmpeq(local("r1_version-0"),iValue(intValue(100))),"label1")),
	    stmtNode(returnStmt(local("r1_version-1")))>,
	
	  <stmtNode(returnStmt(local("r1_version-1"))),
	    exitNode()>,
	
	  <stmtNode(ifStmt(cmpeq(local("r1_version-0"),iValue(intValue(100))),"label1")),
	    stmtNode(ifStmt(cmpge(local("r1_version-0"),iValue(intValue(200))),"label2"))>,
	
	  <stmtNode(ifStmt(cmpge(local("r1_version-0"),iValue(intValue(200))),"label2")),
	    stmtNode(assign(localVariable("r1_version-0"),phiFunction(localVariable("r1"),[localVariable("r1_version-1"),localVariable("r1_version-2")])))>,
	
	  <stmtNode(ifStmt(cmpge(local("r1_version-0"),iValue(intValue(200))),"label2")),
	    stmtNode(assign(localVariable("r1_version-1"),immediate(iValue(intValue(200)))))>,
	
	  <stmtNode(assign(localVariable("r1_version-1"),immediate(iValue(intValue(200))))),
	    stmtNode(assign(localVariable("r1_version-0"),phiFunction(localVariable("r1"),[localVariable("r1_version-1"),localVariable("r1_version-2")])))>,
	
	  <stmtNode(assign(localVariable("r1_version-2"),immediate(iValue(intValue(100))))),
	    stmtNode(gotoStmt("label3"))>
	};
}

private list[Method] castMethodList(ClassOrInterfaceDeclaration declaration) {
	switch(declaration[5]) {
		case list[Method] methodList : return methodList;
	}
}

private MethodBody castMethodBody(Method method) {
	switch(method[5]) {
		case MethodBody methodBody : return methodBody;
	}
}