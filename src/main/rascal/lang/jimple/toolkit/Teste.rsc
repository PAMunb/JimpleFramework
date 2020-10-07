module lang::jimple::toolkit::Teste

import Type;
import IO;
import analysis::graphs::Graph;
import vis::Render;

import lang::jimple::core::Context; 
import lang::jimple::Syntax; 
import lang::jimple::toolkit::GraphUtil;


//TODO remover antes de fazer merge

//hierarchy type's graph
alias HT = rel[str parent, str child];

public HT createHT(ExecutionContext ctx){
	HT ht = {};
	
	top-down visit(ctx) {
     	case classDecl(TObject(t), _, TObject(superClass), interfaces, _, _ ): {
     		ht = ht + <superClass, t>;     		
     		names = [name | TObject(name) <- interfaces];
     		for(n <- names){
     			ht = ht + <n, t>;	
     		}
     	}  
     	case interfaceDecl(TObject(t), _, interfaces, _, _ ): {
     		names = [name | TObject(name) <- interfaces];
     		for(n <- names){
     			ht = ht + <n, t>;	
     		}
     	} 
	}
	
	return ht;
}

/*
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
*/
public list[str] hierarchy_types(HT ht, str name) {
	hierarquia = [name];
	
	types = successors(ht,name);
	for(t <- types){
		hierarquia = hierarquia + hierarchy_types(ht, t);
	}

	return hierarquia;
}

public void teste(){
	files = findClassFiles(|project://JimpleFramework/target/test-classes/samples/callgraph/polymorphism|);
    es = [];
    
    ExecutionContext ctx =  createExecutionContext(files,es,true);
    
    //typeName = TObject("samples.callgraph.polymorphism.util.Log");
    //typeName = TObject("samples.callgraph.polymorphism.service.Service");	
    //typeName = TObject("samples.callgraph.polymorphism.service.AbstractService");
    
    //hierarquia = hierarchy_types(typeName, ctx);
    //println(hierarquia);
    
    println("\n\nMETODOS .....");
    for(m <- ctx.mt){
    	println("<m>");
    }
    
    println("\n\nCLASSES .....");
    for(TObject(m) <- ctx.ct){
    	println("<m>");
    }
    
    HT ht = createHT(ctx);      
    //println("HT=<ht>");     
    //for(k <- ht){
    //	println("- <k>");
    //}
    
    //for(k <- ht){
    //	println("- <k.parent> = <hierarchy_types(ht,k.parent)>");
    //}
    
    println("\n\nMAPA");
    mapa = (k.parent : hierarchy_types(ht,k.parent) | k <- ht);
    println(typeOf(mapa));//map(str(),list(str()))
    for(k <- mapa){
    	println(" - <k>===<mapa[k]>");
    }
    
    //render(toFigure(ht));     
    //println(toDot(ht));
    
    
    
    
}