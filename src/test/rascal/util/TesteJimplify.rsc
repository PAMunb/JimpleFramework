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
	ClassOrInterfaceDeclaration c = decompile(fooBar,true);	
	//ClassOrInterfaceDeclaration c = decompile(fooBarStatic,true);
    
    println(c);
    
    //toPrettyPrint(c);
	//toJimple(c);
}

void toPrettyPrint(ClassOrInterfaceDeclaration c){	
	println(prettyPrint(c));	
}

void toJimple(classDecl(_, TObject(name), _, _, _, list[Method] methods)){	
	println("***** CLASS: <name>");	
	toJimple(methods);
}

void toJimple(interfaceDecl(_, TObject(name), _, _, list[Method] methods)){	
	println("***** INTERFACE: <name>");	
	toJimple(methods);
}

void toJimple(list[Method] methods){	
	for(Method m <- methods){
		println("***** METHOD: <m.name>");
		println(m);
	}
}
