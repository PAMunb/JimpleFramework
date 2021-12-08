module lang::jimple::tests::TestDecompiler

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;
import lang::jimple::decompiler::Decompiler; 
import lang::jimple::decompiler::jimplify::FixStmtId;
import lang::jimple::decompiler::jimplify::FixStmtMethodSignature;
import lang::jimple::decompiler::jimplify::ProcessLabels; 
import lang::jimple::decompiler::jimplify::RemoveModifiers; 
import lang::jimple::toolkit::PrettyPrinter; 
import lang::jimple::util::JPrettyPrinter; 

import Type;
import List; 
import Set;
import IO;
import String;
import lang::jimple::util::IO;


loc classLocation = |project://JimpleFramework/target/test-classes/samples/AbstractClassSample.class|;  
loc interfaceLocation = |project://JimpleFramework/target/test-classes/samples/InterfaceSample.class|;
loc whileLocation = |project://JimpleFramework/target/test-classes/samples/WhileStmtSample.class|;
loc longValueLocation = |project://JimpleFramework/target/test-classes/samples/AdditionalLongValueSample.class|;

loc path = |project://JimpleFramework/target/test-classes/samples/operators|;

 test bool testAbstractClass() {
    ClassOrInterfaceDeclaration c = decompile(classLocation);
    switch(c) {
      case classDecl(_, _, _, _, _, _): return true;  
      default: return false; 
    }
 }
 
 test bool longValueSampleClass() {
    ClassOrInterfaceDeclaration c = decompile(longValueLocation);
    switch(c) {
      case classDecl(_, _, _, _, _, _): { 
        return true;
      }  
      default: return false; 
    }
 }
 
test bool testInterface() {
  ClassOrInterfaceDeclaration c = decompile(interfaceLocation);
  switch(c) {
    case interfaceDecl(_, TObject("samples.InterfaceSample"), _, _, _): return true;  
    default: return false;
  }
}

test bool testDoWhileStatement() {
  loc pathDoWhile = |project://JimpleFramework/target/test-classes/samples/controlStatements/DoWhileStatement.class|;
  ClassOrInterfaceDeclaration c = fixStmtId(fixSignature(processJimpleLabels(decompile(pathDoWhile))));
  list[Statement] expected = [
      identity("r0","@this",TObject("samples.controlStatements.DoWhileStatement"),context=stmtContext(1,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",-1)),
      assign(localVariable("r1"),immediate(iValue(intValue(0))),context=stmtContext(2,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",5)),
      assign(localVariable("r2"),immediate(iValue(intValue(0))),context=stmtContext(3,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",6)),
    label("label1",context=stmtContext(4,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",6)),
      assign(localVariable("$r1"),plus(local("r2"),local("r1")),context=stmtContext(5,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",8)),
      assign(localVariable("r2"),immediate(local("$r1")),context=stmtContext(6,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",8)),
      assign(localVariable("r1"),plus(local("r1"),iValue(intValue(1))),context=stmtContext(7,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",9)),
      ifStmt(cmplt(local("r1"),iValue(intValue(10))),"label1",context=stmtContext(8,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",10)),
      returnStmt(local("r2"),context=stmtContext(9,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",11))  
  ]; 
  switch(c) {
    case classDecl(_, _, _, _, _, methods): { 
      list[Statement] ss = methods[1].body.stmts;
      return expected == ss; 
    }
    default: return false; 
  }
}

test bool testWhileStatement() {
  loc pathDoWhile = |project://JimpleFramework/target/test-classes/samples/controlStatements/WhileStatement.class|;
  ClassOrInterfaceDeclaration c = fixStmtId(fixSignature(processJimpleLabels(decompile(pathDoWhile))));
  list[Statement] expected = [
     identity("r0","@this",TObject("samples.controlStatements.WhileStatement"),context=stmtContext(1,"TObject(\"samples.controlStatements.WhileStatement\").execute()",-1)),
     assign(localVariable("r1"),immediate(iValue(intValue(0))),context=stmtContext(2,"TObject(\"samples.controlStatements.WhileStatement\").execute()",5)),
     assign(localVariable("r2"),immediate(iValue(intValue(0))),context=stmtContext(3,"TObject(\"samples.controlStatements.WhileStatement\").execute()",6)),
   label("label1",context=stmtContext(4,"TObject(\"samples.controlStatements.WhileStatement\").execute()",6)),
     ifStmt(cmpge(local("r1"),iValue(intValue(10))),"label2",context=stmtContext(5,"TObject(\"samples.controlStatements.WhileStatement\").execute()",7)),
     assign(localVariable("$r1"),plus(local("r2"),local("r1")),context=stmtContext(6,"TObject(\"samples.controlStatements.WhileStatement\").execute()",8)),
     assign(localVariable("r2"),immediate(local("$r1")),context=stmtContext(7,"TObject(\"samples.controlStatements.WhileStatement\").execute()",8)),
     assign(localVariable("r1"),plus(local("r1"),iValue(intValue(1))),context=stmtContext(8,"TObject(\"samples.controlStatements.WhileStatement\").execute()",9)),
     gotoStmt("label1",context=stmtContext(9,"TObject(\"samples.controlStatements.WhileStatement\").execute()",9)),
   label("label2",context=stmtContext(10,"TObject(\"samples.controlStatements.WhileStatement\").execute()",9)),
     returnStmt(local("r2"),context=stmtContext(11,"TObject(\"samples.controlStatements.WhileStatement\").execute()",11))
  ];  
  switch(c) {
    case classDecl(_, _, _, _, _, methods): { 
      list[Statement] ss = methods[1].body.stmts; 
      return expected == ss; 
    }
    default: return false; 
  }
}

test bool testStaticBlock() {
  loc pathDoWhile = |project://JimpleFramework/target/test-classes/samples/controlStatements/StaticBlock.class|;
  ClassOrInterfaceDeclaration c = fixStmtId(fixSignature(processJimpleLabels(decompile(pathDoWhile))));
  switch(c) {
    case classDecl(_, _, _, _, _, methods): {  
      return {m.name | m <- methods} == {"sum", "\<init\>", "\<clinit\>" } && size(methods) == 3; 
    }
    default: return false; 
  }
} 

test bool testSolveLabels() {
  ClassOrInterfaceDeclaration c = decompile(whileLocation);
  c = processJimpleLabels(c);
  return size([aLabel | /label(aLabel) <- c]) == 2;  
}
 
 
test bool testWrongTypeDecompilerNames(){
	list[loc] entries = findAllFiles(path,"class");
	set[str] results = {};
	int count= 0;
	for(loc entry <- entries) {
		ClassOrInterfaceDeclaration c = decompile(entry);
		count = count + 1;
		bottom-up visit(c) {
		     case TObject(name): if(contains(name, "/")) results += "Object(<name>)" ;
		     case fieldRef(name,_,_): if(contains(name, "/")) results +=  "fieldRef(<name>)" ;
		     case methodSignature(name,_,_,_): results +=  "methodSignature(<name>)" ;
		};
   	}
   	
   	return true;
}

test bool removeModifiers(){

	loc pathDoWhile = |project://JimpleFramework/target/test-classes/samples/controlStatements/WhileStatement.class|;
	
  	ClassOrInterfaceDeclaration c1 = processModifiers(decompile(pathDoWhile));
  	ClassOrInterfaceDeclaration c2 = decompile(pathDoWhile);
  	  	
  	list[Modifier] e1 = [Public()];  
    list[Modifier] e2 = [Public(),Synchronized()]; 
    
  	return classDecl(mds1, _, _, _, _, _) := c1 && e1 == mds1 &&
  		   classDecl(mds2, _, _, _, _, _) := c2 && e2 == mds2;
}











 
