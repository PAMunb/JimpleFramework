module lang::jimple::toolkit::Teste

import IO;

import lang::jimple::core::Context; 
import lang::jimple::Syntax; 

public set[Type] hierarchy_types(Type typeName, ExecutionContext ctx){
	println("typeName=<typeName>");
	
	hierarquia = {typeName};
	
	top-down visit(ctx) {
     	case c: classDecl(t, _, _, _, _, _ ): {
     		println("\tclasse=<t>");
     		if(extends(c,typeName) || implements(c,typeName)){
     			println("*********************BINGO");
     			hierarquia = hierarquia + hierarchy_types(t, ctx);
     			
     		}
     	}  
     	case i: interfaceDecl(t, _, _, _, _ ): {
     		println("\tinterface=<t>");     		
     		if(extends(i, typeName)){
     			println("*********************BINGO");
     			hierarquia = hierarquia + hierarchy_types(t, ctx);
     		}
     	} 
	}
	
	return hierarquia;	
}

private bool extends(classDecl(_, _, TObject(s), _, _, _ ), TObject(tn)) {
	return s == tn;
}
private bool extends(interfaceDecl(_, _, interfaces, _, _ ), TObject(tn)) {
	names = [name | TObject(name) <- interfaces];
	return tn in names;
}
private bool implements(classDecl(_, _, _, interfaces, _, _ ), TObject(tn)) {
	names = [name | TObject(name) <- interfaces];
	return tn in names;
}

public void teste(){
	files = findClassFiles(|project://JimpleFramework/target/test-classes/samples/callgraph/polymorphism|);
    es = [];
    
    ExecutionContext ctx =  createExecutionContext(files,es,true);
    
    typeName = TObject("samples.callgraph.polymorphism.util.Log");
    //typeName = TObject("samples.callgraph.polymorphism.service.Service");	
    //typeName = TObject("samples.callgraph.polymorphism.service.AbstractService");
    
    hierarquia = hierarchy_types(typeName, ctx);
    println(hierarquia);
}