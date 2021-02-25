module ssa::SSAIntegrationTests::TestQuickSort

import List;
import Type;

import analysis::graphs::Graph;

import lang::jimple::decompiler::Decompiler;
import lang::jimple::decompiler::jimplify::ProcessLabels;
import lang::jimple::core::Context;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;

import lang::jimple::toolkit::ssa::Generator;

test bool testFirstMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/QuickSort.class|;
	ClassOrInterfaceDeclaration classFileDeclaration = decompile(classFilePath);
	classFileDeclaration = processJimpleLabels(classFileDeclaration);
	list[Method] methodList = castMethodList(classFileDeclaration);	
	MethodBody methodBody = castMethodBody(methodList[1]);
	
	FlowGraph result = applySSATransformation(methodBody);

	// Os arrays ref tao com problema

	return false;
}

test bool testSecondMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/QuickSort.class|;
	ClassOrInterfaceDeclaration classFileDeclaration = decompile(classFilePath);
	classFileDeclaration = processJimpleLabels(classFileDeclaration);
	list[Method] methodList = castMethodList(classFileDeclaration);	
	MethodBody methodBody = castMethodBody(methodList[2]);
	
	FlowGraph result = applySSATransformation(methodBody);

	// Os arrays ref tao com problema
	// Quando tem invoke do lado direito do assing, ele não é renomeado
	// 

	return false;
}

test bool testThirdMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/QuickSort.class|;
	ClassOrInterfaceDeclaration classFileDeclaration = decompile(classFilePath);
	classFileDeclaration = processJimpleLabels(classFileDeclaration);
	list[Method] methodList = castMethodList(classFileDeclaration);	
	MethodBody methodBody = castMethodBody(methodList[2]);
	
	FlowGraph result = applySSATransformation(methodBody);

	// Os arrays ref tao com problema

	return false;
}

test bool testFourthMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/QuickSort.class|;
	ClassOrInterfaceDeclaration classFileDeclaration = decompile(classFilePath);
	classFileDeclaration = processJimpleLabels(classFileDeclaration);
	list[Method] methodList = castMethodList(classFileDeclaration);	
	MethodBody methodBody = castMethodBody(methodList[2]);
	
	FlowGraph result = applySSATransformation(methodBody);

	// Os arrays ref tao com problema

	return false;
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