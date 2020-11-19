module util::RunSVFA

import IO;
import Map;
import Relation;
import Type;
import Set;
import List;
import util::Math;
import analysis::graphs::Graph;

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;
import lang::jimple::analysis::svfa::SparseValueFlowAnalysis;
import lang::jimple::toolkit::ValueFlowGraph;
import lang::jimple::util::Converters;
import lang::jimple::toolkit::PrettyPrinter;

private tuple[list[loc] classPath, list[str] entryPoints] basic11() {
	//TODO compile class before using: mvn test -DskipTests
	files = [|project://JimpleFramework/target/test-classes/samples/svfa/basic/Basic11.class|];
    es = ["samples.svfa.basic.Basic11.main(java.lang.String[])"];
    return <files, es>;
}

public void main(){
	tuple[list[loc] cp, list[str] e] t = basic11();
	
	files = t.cp;
    es = t.e;
    
    println("iniciando ....");
    
    SVFAModel model = execute(files, es, Analysis(generateSVFGraph([])),true);
    
    println("model=<model>");
    
    
    //ExecutionContext ctx = createExecutionContext(files,es,true);	    
    //show(ctx);    
    //for(m <- ctx.mt){
    //	println(m);
    //}    
}




private void show(ExecutionContext ctx){			
	top-down visit(ctx.ct) {	 	
  		case ClassOrInterfaceDeclaration c:{
  			show(c);
  		}  			  		
  	}    
}

private void show(classDecl(TObject(name), _, _, _, _, list[Method] methods)){
	println("CLASS: <name>");
	show(methods);	
}

private void show(interfaceDecl(TObject(name), _, _, _, list[Method] methods)){
	println("INTERFACE: <name>");
	show(methods);	
}

private void show(list[Method] methods){
	for(Method m <- methods){
		show(m);
	}
}

private void show(method(_, _, Name name, list[Type] args, _, _)){
	println("\t - <name>(<intercalate(",", args)>)");
}
