module util::TesteJimplify

import IO;
import Type;
import Set;
import List;
import util::Math;

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;
import lang::jimple::decompiler::Decompiler; 
import lang::jimple::toolkit::PrettyPrinter;
import lang::jimple::util::Converters;
import lang::jimple::util::JPrettyPrinter;

import lang::jimple::decompiler::jimplify::Transformations;


loc fooBar = |project://JimpleFramework/target/test-classes/samples/pointsto/simple/FooBar.class|;
loc fooBarStatic = |project://JimpleFramework/target/test-classes/samples/pointsto/simple/FooBarStatic.class|;

public void executar(){
	ClassOrInterfaceDeclaration c = jimplify(decompile(fooBar,true));	
    
    toPrettyPrint(c);
	//toJimple(c);
}

void toPrettyPrint(ClassOrInterfaceDeclaration c){	
	println(prettyPrint(c));	
}

void toJimple(ClassOrInterfaceDeclaration c){	
	println(c);	
}
