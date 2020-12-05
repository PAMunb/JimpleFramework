module lang::jimple::toolkit::DefUse

import lang::jimple::core::Context; 
import lang::jimple::core::Syntax; 

import IO;

alias Definition = Statement; 
alias LocalVariable = str;

data VariableDefinition = varDef(Name var);//, Statement stmt);

data DefUse = defUse(VariableDefinition def, set[Statement] uses);


map[LocalVariable, set[Statement]] localDefs = (); 

public list[DefUse] teste(MethodBody b){
	list[DefUse] retorno = [];
	localDefs = loadDefinitions(b.stmts);
	
	for(localDef <- localDefs){
		VariableDefinition def = varDef(localDef);
		set[Statement] uses = findUses(def, b);
		retorno = retorno + defUse(def,uses);
	}
	return retorno;
}

private set[Statement] findUses(VariableDefinition def, MethodBody b) {
	return { stmt | stmt <- b.stmts, uses(stmt, def.var)};
	//for(stmt <- b.stmts){
	//	uses(stmt, def.var);
	//}
}

private bool uses(Statement stmt, LocalVariable var) {
	top-down visit(stmt) {	
		case Expression e: return useVariable(e,var);
	}
	return false;
}

//private set[Statement] uses(MethodBody b, LocalVariable var) 
//   = { stmt | /Expression e <- stmt, useVariable(e, var) | stmt <- b.stmts };

private bool useVariable(Expression e, str v) = local(v) in localReferences(e); 

private list[Immediate] localReferences(Expression e) = [local(v) | /local(v) <- e];

map[LocalVariable, set[Definition]] loadDefinitions([]) = (); 

map[LocalVariable, set[Definition]] loadDefinitions([assign(localVariable(v), e), *Statement SS]) = defs + (v : (assign(localVariable(v), e) + defs[v]))
  when defs := loadDefinitions(SS)
     , v in defs
     ;

map[LocalVariable, set[Definition]] loadDefinitions([assign(localVariable(v), e), *Statement SS]) = defs + (v : { (assign(localVariable(v), e)) } )
  when defs := loadDefinitions(SS)
     , v notin defs
     ; 
           
map[LocalVariable, set[Definition]] loadDefinitions([_, *Statement SS]) = defs
   when defs := loadDefinitions(SS)
      ;
      
      
      
      
private tuple[list[loc] classPath, list[str] entryPoints] runBasic11() {
	//TODO compile class before using: mvn test -DskipTests
	files = [|project://JimpleFramework/target/test-classes/samples/svfa/basic/Basic11.class|];
    es = ["samples.svfa.basic.Basic11.main(java.lang.String[])"];
    return <files, es>;
}
      
public void testeDef(){
	tuple[list[loc] cp, list[str] e] t = runBasic11();
	sig = "samples.svfa.basic.Basic11.main(java.lang.String[])";
	ExecutionContext ctx = createExecutionContext(t.cp, t.e);
    MethodBody b = ctx.mt[sig].method.body;
    
    list[DefUse] lista = teste(b);
    for(l <- lista){
    	println("\n <l.def>");
    	for(u <- l.uses){
    		println("\t- <u>");
    	}
    }
}      