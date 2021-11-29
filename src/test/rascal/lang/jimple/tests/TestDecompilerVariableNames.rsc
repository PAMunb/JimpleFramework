module lang::jimple::tests::TestDecompilerVariableNames

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;
import lang::jimple::decompiler::Decompiler; 

import Exception;
import IO;

loc fooBar = |project://JimpleFramework/target/test-classes/samples/pointsto/simple/FooBar.class|;
loc fooBarStatic = |project://JimpleFramework/target/test-classes/samples/pointsto/simple/FooBarStatic.class|;  


test bool testFooBar(){
	ClassOrInterfaceDeclaration c = decompile(fooBar);
	
	Method bar = getMethodByName(c,"bar");
	
	list[LocalVariableDeclaration] localVarsExpected = [
		localVariableDeclaration(TObject("samples.pointsto.simple.Node"),"s"),
		localVariableDeclaration(TObject("samples.pointsto.simple.FooBar"),"r0"),
		localVariableDeclaration(TObject("samples.pointsto.simple.Node"),"$r1")
	];
	
	list[Statement] stmtsExpected = [
		identity("r0","@this",TObject("samples.pointsto.simple.FooBar")),
		identity("s","@parameter0",TObject("samples.pointsto.simple.Node")),
		assign(localVariable("$r1"),localFieldRef("s","samples/pointsto/simple/Node",TObject("samples.pointsto.simple.Node"),"next")),
		returnStmt(local("$r1"))
	];
	
	return check(localVarsExpected,stmtsExpected,bar);
}

test bool testFooBarStatic(){
	ClassOrInterfaceDeclaration c = decompile(fooBarStatic);
	
	Method bar = getMethodByName(c,"bar");
	
	list[LocalVariableDeclaration] localVarsExpected = [
		localVariableDeclaration(TObject("samples.pointsto.simple.Node"),"s"),
		localVariableDeclaration(TObject("samples.pointsto.simple.Node"),"$r1")
	];
	
	list[Statement] stmtsExpected = [
		identity("s","@parameter0",TObject("samples.pointsto.simple.Node")),
		assign(localVariable("$r1"),localFieldRef("s","samples/pointsto/simple/Node",TObject("samples.pointsto.simple.Node"),"next")),
		returnStmt(local("$r1"))
	];

	return check(localVarsExpected,stmtsExpected,bar);
}

test bool testFooBarStaticMultipleArgs(){
	ClassOrInterfaceDeclaration c = decompile(fooBarStatic);
	
	//multipleArgs(int x, Node x1, double y, Node y1, Node s[])
	Method bar = getMethodByName(c,"multipleArgs");
	
	list[LocalVariableDeclaration] localVarsExpected = [
		localVariableDeclaration(TObject("samples.pointsto.simple.Node"),"y1"),
		localVariableDeclaration(TObject("samples.pointsto.simple.Node"),"x1"),
		localVariableDeclaration(TArray(TObject("samples.pointsto.simple.Node")),"s"),
		localVariableDeclaration(TDouble(),"y"),
		localVariableDeclaration(TInteger(),"x"),
		localVariableDeclaration(TObject("java.lang.Double"),"d")
	];	
	
	list[Statement] stmtsExpected = [
		identity("x","@parameter0",TInteger()),
		identity("x1","@parameter1",TObject("samples.pointsto.simple.Node")),
		identity("y","@parameter2",TDouble()),
		identity("y1","@parameter3",TObject("samples.pointsto.simple.Node")),
		identity("s","@parameter4",TArray(TObject("samples.pointsto.simple.Node"))),
		identity("d","@parameter5",TObject("java.lang.Double")),
		returnEmptyStmt()
	];

	return check(localVarsExpected,stmtsExpected,bar);
}

void show(method(list[Modifier] modifiers, Type returnType, Name name, list[Type] formals, list[Type] exceptions, MethodBody body)){
	
}

bool check(list[LocalVariableDeclaration] localVarsExpected, list[Statement] stmtsExpected, method(_, _, _, _, _, methodBody(list[LocalVariableDeclaration] localVariableDecls, list[Statement] stmts, _))){
	return check(localVarsExpected, localVariableDecls) && check(stmtsExpected, stmts);
}

bool check(list[&T] expected, list[&T] original){
	for(&T stmt <- expected){
		if(stmt notin original){
			return false;
		}
	}
	return true;
}

Method getMethodByName(ClassOrInterfaceDeclaration c, str methodName){
	list[Method] methods = getMethods(c);
	for(m: method(_, _, Name name, _, _, _) <- methods){
		if(name == methodName){
			return m;
		}
	} 
    throw NoSuchKey(methodName);
}

list[Method] getMethods(ClassOrInterfaceDeclaration c){
	switch(c) {
    	case classDecl(_, _, _, _, _, list[Method] methods): return methods;
      	case interfaceDecl(_, _, _, _, list[Method] methods): return methods;      	
    }
    return [];
}