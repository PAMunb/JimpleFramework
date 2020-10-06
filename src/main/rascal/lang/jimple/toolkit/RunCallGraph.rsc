module lang::jimple::toolkit::RunCallGraph

import IO;
import Map;
import Relation;
import Type;
import Set;
import List;
import util::Math;
import vis::Render;
import analysis::graphs::Graph;

import lang::jimple::Syntax;
import lang::jimple::core::Context;
import lang::jimple::toolkit::CallGraph;
import lang::jimple::toolkit::GraphUtil;

public tuple[list[loc] classPath, list[str] entryPoints] polymorphism() {
	//TODO compile class before using: mvn test -DskipTests
	files = findClassFiles(|project://JimpleFramework/target/test-classes/samples/callgraph/polymorphism|);
    es = ["samples.callgraph.polymorphism.Main.execute()"];
    //es = ["samples.callgraph.polymorphism.Main.main(TArray(TObject(\"java.lang.String\")))"];
	return <files, es>;
}

public tuple[list[loc] classPath, list[str] entryPoints] iris() {
	files = [|project://JimpleFramework/src/test/resources/iris-core/|];
    es = ["br.unb.cic.iris.core.SystemFacade.send(TObject(\"br.unb.cic.iris.core.model.EmailMessage\"))"];
	return <files, es>;
}

public tuple[list[loc] classPath, list[str] entryPoints] slf4j() {
	files = [|project://JimpleFramework/src/test/resources/slf4j/|];	
    es = [];
    return <files, es>;
}

public tuple[list[loc] classPath, list[str] entryPoints] simple() {
	//TODO compile class before using: mvn test -DskipTests
	files = [|project://JimpleFramework/target/test-classes/samples/callgraph/simple/SimpleCallGraph.class|];
    es = ["samples.callgraph.simple.SimpleCallGraph.A()"];
    //es = ["samples.TestCallGraph.execute()"];
    //es = ["samples.callgraph.simple.SimpleCallGraph.B()","samples.TestCallGraph.C()"];
    return <files, es>;
}


public void main(){
	tuple[list[loc] cp, list[str] e] t = polymorphism();
	//tuple[list[loc] cp, list[str] e] t = simple();
	//tuple[list[loc] cp, list[str] e] t = iris();
	//tuple[list[loc] cp, list[str] e] t = slf4j();

    files = t.cp;
    es = t.e;
   
    // EXECUTION
    //CGModel model = execute(files, es, Analysis(computeCallGraph));
    CGModel model = execute(files, es, Analysis(computeCallGraphConditional));
    //println(model.cg);        
    
    CG cg = model.cg;
    mm = invertUnique(model.methodMap);
    //mm = invert(model.methodMap);
    println("\n\n");
    println(typeOf(mm));    
    
    nCalls = size(model.cg);
    println("Number os calls: "+toString(nCalls));
    println("Calls: "+toString(model.cg));    
    
    procs = carrier(cg);    
    println("\nNumber of Procedures: "+toString(size(procs)));
    println("Procedures: "+toString(procs));
    
    entryPoints = top(cg);    
    println("\nNumber of Entry Points: "+toString(size(entryPoints)));
    println("Entry Points: "+toString(entryPoints));
    procsList = toList(procs);
    println([mm[name] | name <- procsList]);
    
    bottomCalls = bottom(cg);
    println("\nNumber of Bottom Calls (leaves): "+toString(size(bottomCalls)));
    println("Bottom Calls (leaves): "+toString(bottomCalls));
    
    closureCalls = cg+;
    println("\nIndirect Calls: "+toString(closureCalls));
    
    connections = connectedComponents(cg);
    println("\nConnected Components: "+toString(connections));
    
    // draw the call graph
    render(toFigure(cg));   
    //render(toFigure(cg,mm));
    
    //to dot (use xdot or graphviz to view)
    println("DOT:");
    println(toDot(cg, "CallGraph", mm));
}


public void show(){
	files = findClassFiles(|project://JimpleFramework/target/test-classes/samples/callgraph/polymorphism|);
	//files = [|project://JimpleFramework/src/test/resources/slf4j/|];	
	//files = [|project://JimpleFramework/src/test/resources/iris-core/|];
	es = [];

	ExecutionContext ctx =  createExecutionContext(files,es,true);	
		
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

