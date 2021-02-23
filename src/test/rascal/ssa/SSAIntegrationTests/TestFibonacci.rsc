module ssa::SSAIntegrationTests::TestFibonacci

import List;
import Type;

import analysis::graphs::Graph;

import lang::jimple::decompiler::Decompiler;
import lang::jimple::decompiler::jimplify::ProcessLabels;
import lang::jimple::core::Context;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;

import lang::jimple::toolkit::ssa::Generator;

test bool testFibonacciMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/Fibonacci.class|;
	ClassOrInterfaceDeclaration classFileDeclaration = decompile(classFilePath);
	classFileDeclaration = processJimpleLabels(classFileDeclaration);
	list[Method] methodList = castMethodList(classFileDeclaration);	
	MethodBody methodBody = castMethodBody(methodList[1]);
	
	FlowGraph result = applySSATransformation(methodBody);

	return result == {
	  <entryNode(), stmtNode(identity("r0","@this",TObject("samples.ssa.Fibonacci")))>,
	  <stmtNode(identity("r0","@this",TObject("samples.ssa.Fibonacci"))),stmtNode(identity("i1","@parameter0",TInteger()))>,
	  <stmtNode(identity("i1","@parameter0",TInteger())),stmtNode(assign(localVariable("r2_version-0"),immediate(iValue(intValue(0)))))>,
	  <stmtNode(assign(localVariable("r2_version-0"),immediate(iValue(intValue(0))))),stmtNode(assign(localVariable("r3_version-0"),immediate(iValue(intValue(1)))))>,
	  <stmtNode(assign(localVariable("r3_version-0"),immediate(iValue(intValue(1))))),stmtNode(assign(localVariable("r4_version-0"),immediate(iValue(intValue(1)))))>,
	  <stmtNode(assign(localVariable("r4_version-0"),immediate(iValue(intValue(1))))),stmtNode(gotoStmt("label2"))>,
	  <stmtNode(gotoStmt("label2")),stmtNode(assign(localVariable("r2_version-1"),phiFunction(localVariable("r2"),[localVariable("r2_version-0"),localVariable("r2_version-2")])))>,
	  <stmtNode(assign(localVariable("r2_version-1"),phiFunction(localVariable("r2"),[localVariable("r2_version-0"),localVariable("r2_version-2")]))),stmtNode(assign(localVariable("r3_version-1"),phiFunction(localVariable("r3"),[localVariable("r3_version-0")])))>,
	  <stmtNode(assign(localVariable("r3_version-1"),phiFunction(localVariable("r3"),[localVariable("r3_version-0")]))),stmtNode(assign(localVariable("r4_version-1"),phiFunction(localVariable("r4"),[localVariable("r4_version-0")])))>,
	  <stmtNode(assign(localVariable("r4_version-1"),phiFunction(localVariable("r4"),[localVariable("r4_version-0")]))),stmtNode(assign(localVariable("$r1_version-0"),phiFunction(localVariable("$r1"),[localVariable("$r1_version-0")])))>,
	  <stmtNode(assign(localVariable("$r1_version-0"),phiFunction(localVariable("$r1"),[localVariable("$r1_version-0")]))),stmtNode(assign(localVariable("r5_version-0"),phiFunction(localVariable("r5"),[localVariable("r5_version-0")])))>,
	  <stmtNode(assign(localVariable("r5_version-0"),phiFunction(localVariable("r5"),[localVariable("r5_version-0")]))),stmtNode(ifStmt(cmple(local("r4_version-1"),local("r1_version-0")),"label1"))>,
	
	  <stmtNode(ifStmt(cmple(local("r4_version-1"),local("r1_version-0")),"label1")),stmtNode(returnEmptyStmt())>,
	  <stmtNode(returnEmptyStmt()),exitNode()>,
	
	  <stmtNode(ifStmt(cmple(local("r4_version-1"),local("r1_version-0")),"label1")),stmtNode(assign(localVariable("$r1_version-1"),immediate(local("r3_version-1"))))>,
	  <stmtNode(assign(localVariable("$r1_version-1"),immediate(local("r3_version-1")))),stmtNode(assign(localVariable("r5_version-1"),immediate(local("$r1_version-1"))))>,
	  <stmtNode(assign(localVariable("r5_version-1"),immediate(local("$r1_version-1")))),stmtNode(assign(localVariable("r2_version-2"),immediate(local("r3_version-1"))))>,
	  <stmtNode(assign(localVariable("r2_version-2"),immediate(local("r3_version-1")))),stmtNode(assign(localVariable("r3_version-2"),immediate(local("r5_version-1"))))>,
	  <stmtNode(assign(localVariable("r3_version-2"),immediate(local("r5_version-1")))),stmtNode(assign(localVariable("r4_version-2"),immediate(local("r4_version-1"))))>,
	  <stmtNode(assign(localVariable("r4_version-2"),immediate(local("r4_version-1")))),stmtNode(assign(localVariable("r2_version-1"),phiFunction(localVariable("r2"),[localVariable("r2_version-0"),localVariable("r2_version-2")])))>
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