module util::RunCallGraph

import IO;
import Map;
import Relation;
import Type;
import Set;
import List;
import util::Math;
import vis::Figure;
import vis::ParseTree;
import vis::Render;
import analysis::graphs::Graph;

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;
import lang::jimple::toolkit::CallGraph;

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
    es = ["samples.callgraph.simple.SimpleCallGraph.A()"];//["samples.TestCallGraph.execute()"];
    //es = ["samples.TestCallGraph.execute()"];
    //es = ["samples.callgraph.simple.SimpleCallGraph.B()","samples.TestCallGraph.C()"];
    return <files, es>;
}


public void main(){
	tuple[list[loc] cp, list[str] e] t = simple();
	//tuple[list[loc] cp, list[str] e] t = iris();
	//tuple[list[loc] cp, list[str] e] t = slf4j();

    files = t.cp;
    es = t.e;
   
    // EXECUTION
    //CGModel model = execute(files, es, Analysis(computeCallGraph));
    CGModel model = execute(files, es, Analysis(computeCallGraphConditional));
    //println(model.cg);        
    
    CG cg = model.cg;
    mm = invert(model.methodMap);
    println("\n\n");
    println(typeOf(cg));    
    
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
    println([name | nn <- procsList, name <- mm[nn]]);
    
    bottomCalls = bottom(cg);
    println("\nNumber of Bottom Calls (leaves): "+toString(size(bottomCalls)));
    println("Bottom Calls (leaves): "+toString(bottomCalls));
    
    closureCalls = cg+;
    println("\nIndirect Calls: "+toString(closureCalls));
    
    connections = connectedComponents(cg);
    println("\nConnected Components: "+toString(connections));
    
    // draw the call graph
    procsList = toList(procs);
    //nodes = toList({box(text(name), id(name), size(50), fillColor("lightgreen")) | name <- procsList});    
    nodes = toList({box(text(name), id(nn), size(50), fillColor("lightgreen")) | nn <- procsList, name <- mm[nn]});
    edges = [edge(c.from,c.to) | c <- cg];    
    render(graph(nodes, edges, hint("layered"), std(size(20)), gap(10)));    
}


public void show(){
	files = [|project://JimpleFramework/src/test/resources/slf4j/|];	
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

public void novo(){
    files = [|project://JimpleFramework/target/test-classes/samples/callgraph/simple/SimpleCallGraph.class|];
    es = ["samples.callgraph.simple.SimpleCallGraph.A()"];

    ExecutionContext ctx =  createExecutionContext(files,es);
    //println(ctx.mt);
    
    println(ctx.mt["samples.callgraph.simple.SimpleCallGraph.A()"].method.body);
    
    //para testar uma forma de tratar os invokes
    println("visitando");
    visit(ctx.mt["samples.callgraph.simple.SimpleCallGraph.A()"].method.body){
    	//case InvokeExp e: {
    	case InvokeExp e: {//_(_,methodSignature(cn, r, mn, args),_): {
    		//sig = signature(cn,mn,args); 
      		println("ENTROU!!! ");//+sig);
      		//println(e);
      		teste(e);
    	} 

    	//esse funciona mas fica mostrando erro no eclipse  
    	//case &T _(_, methodSignature(cn, r, mn, args), _): {
        //    println("aaa");
        //} 	
    }

}

public void teste(virtualInvoke(_, sig, _)) {
	println("teste");
}
