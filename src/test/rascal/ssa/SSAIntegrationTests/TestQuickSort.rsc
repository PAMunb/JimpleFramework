module ssa::SSAIntegrationTests::TestQuickSort

import List;
import Type;
import Set;

import analysis::graphs::Graph;

import lang::jimple::decompiler::Decompiler;
import lang::jimple::decompiler::jimplify::ProcessLabels;
import lang::jimple::core::Context;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;

import lang::jimple::toolkit::ssa::Generator;

test bool testQuickSortPartitionMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/QuickSort.class|;
	ClassOrInterfaceDeclaration classFileDeclaration = decompile(classFilePath);
	classFileDeclaration = processJimpleLabels(classFileDeclaration);
	list[Method] methodList = castMethodList(classFileDeclaration);	
	MethodBody methodBody = castMethodBody(methodList[1]);
	
	FlowGraph result = applySSATransformation(methodBody);

	return !isEmpty(result);
}

test bool testQuickSortSortMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/QuickSort.class|;
	ClassOrInterfaceDeclaration classFileDeclaration = decompile(classFilePath);
	classFileDeclaration = processJimpleLabels(classFileDeclaration);
	list[Method] methodList = castMethodList(classFileDeclaration);	
	MethodBody methodBody = castMethodBody(methodList[2]);
	
	FlowGraph result = applySSATransformation(methodBody);

	// Doest support invokeStmt operators
	return result == {};
}

test bool testQuickSortPrintMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/QuickSort.class|;
	ClassOrInterfaceDeclaration classFileDeclaration = decompile(classFilePath);
	classFileDeclaration = processJimpleLabels(classFileDeclaration);
	list[Method] methodList = castMethodList(classFileDeclaration);	
	MethodBody methodBody = castMethodBody(methodList[2]);
	
	FlowGraph result = applySSATransformation(methodBody);

	// Doest support invokeStmt operators
	return result == {};
}

test bool testQuickSortMainMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/QuickSort.class|;
	ClassOrInterfaceDeclaration classFileDeclaration = decompile(classFilePath);
	classFileDeclaration = processJimpleLabels(classFileDeclaration);
	list[Method] methodList = castMethodList(classFileDeclaration);	
	MethodBody methodBody = castMethodBody(methodList[2]);
	
	FlowGraph result = applySSATransformation(methodBody);

	// Doest support invokeStmt operators
	return result == {};
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