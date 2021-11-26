module util::Teste

import IO;
import Type;
import Set;
import List;
import util::Math;

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;
import lang::jimple::toolkit::CallGraph;
import lang::jimple::toolkit::GraphUtil;
import lang::jimple::util::Converters;
import lang::jimple::toolkit::PrettyPrinter;
import lang::jimple::util::JPrettyPrinter;

tuple[list[loc] classPath, list[str] entryPoints] iris() {
	files = [|project://JimpleFramework/src/test/resources/iris-core/|];
    es = ["br.unb.cic.iris.core.SystemFacade.send(br.unb.cic.iris.core.model.EmailMessage)"];
	return <files, es>;
}

tuple[list[loc] classPath, list[str] entryPoints] fooBar() {
	//TODO compile classes before using: mvn test -DskipTests
	files = [|project://JimpleFramework/target/test-classes/samples/pointsto/simple/|];
    es = ["samples.pointsto.simple.FooBar.foo()", "samples.pointsto.simple.FooBar.bar(samples.pointsto.simple.Node)"];
    return <files, es>;
}
tuple[list[loc] classPath, list[str] entryPoints] fooBarStatic() {
	files = [|project://JimpleFramework/target/test-classes/samples/pointsto/simple/|];
    es = ["samples.pointsto.simple.FooBarStatic.foo()", "samples.pointsto.simple.FooBar.bar(samples.pointsto.simple.Node)"];
    return <files, es>;
}

public void executar(){
	//tuple[list[loc] cp, list[str] e] t = iris();
	tuple[list[loc] cp, list[str] e] t = fooBar();
	//tuple[list[loc] cp, list[str] e] t = fooBarStatic();

    classPath = t.cp;
    entryPoints = t.e;
   
    ExecutionContext ctx =  createExecutionContext(classPath, entryPoints, true);	
    
    //show(ctx);
    toJimple(ctx);
}

void toJimple(ExecutionContext ctx){
	for(className <- ctx.ct){		
		println(prettyPrint(ctx.ct[className].dec));	
	}
}

void show(ExecutionContext ctx){			
	top-down visit(ctx.ct) {	 	
  		case ClassOrInterfaceDeclaration c:{
  			show(c);
  		}  			  		
  	}    
}

void show(classDecl(_, TObject(name), _, _, _, list[Method] methods)){
	println("CLASS: <name>");
	show(methods);
}

void show(interfaceDecl(_, TObject(name), _, _, list[Method] methods)){
	println("INTERFACE: <name>");
	show(methods);
}

void show(list[Method] methods){
	for(Method m <- methods){
		show(m);
	}
}

void show(method(_, Type returnType, Name name, list[Type] args, _, MethodBody body)){
	println("\t - <name>(<intercalate(",", args)>)");
	show(body);
}

void show(methodBody(list[LocalVariableDeclaration] localVariableDecls, list[Statement] stmts, list[CatchClause] catchClauses)){
	for(localVariableDeclaration(TObject(Name name), Identifier local) <- localVariableDecls){
		println("\t\t - <name> <local>");
	}	
}

void show(signatureOnly()){

}
