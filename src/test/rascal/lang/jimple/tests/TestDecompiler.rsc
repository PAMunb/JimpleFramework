module lang::jimple::tests::TestDecompiler

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;
import lang::jimple::decompiler::Decompiler; 
import lang::jimple::decompiler::jimplify::FixStmtMethodSignature;
import lang::jimple::decompiler::jimplify::ProcessLabels; 
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
  ClassOrInterfaceDeclaration c = fixSignature(processJimpleLabels(decompile(pathDoWhile)));
  list[Statement] expected = [  
     identity("r0","@this",TObject("samples.controlStatements.DoWhileStatement"),context=stmtContext(1,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",-1)),
     assign(localVariable("r1"),immediate(iValue(intValue(0))),context=stmtContext(3,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",5)),
     assign(localVariable("r2"),immediate(iValue(intValue(0))),context=stmtContext(5,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",6)),
   label("label1"),
     assign(localVariable("$r1"),plus(local("r2"),local("r1")),context=stmtContext(7,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",8)),
     assign(localVariable("r2"),immediate(local("$r1")),context=stmtContext(8,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",8)),
     assign(localVariable("r1"),plus(local("r1"),iValue(intValue(1))),context=stmtContext(10,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",9)),
     ifStmt(cmplt(local("r1"),iValue(intValue(10))),"label1"),
     returnStmt(local("r2"),context=stmtContext(14,"TObject(\"samples.controlStatements.DoWhileStatement\").execute()",11))
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
  ClassOrInterfaceDeclaration c = fixSignature(processJimpleLabels(decompile(pathDoWhile)));
  list[Statement] expected = [
     identity("r0","@this",TObject("samples.controlStatements.WhileStatement"),context=stmtContext(1,"TObject(\"samples.controlStatements.WhileStatement\").execute()",-1)),
     assign(localVariable("r1"),immediate(iValue(intValue(0))),context=stmtContext(3,"TObject(\"samples.controlStatements.WhileStatement\").execute()",5)),
     assign(localVariable("r2"),immediate(iValue(intValue(0))),context=stmtContext(5,"TObject(\"samples.controlStatements.WhileStatement\").execute()",6)),
   label("label1"),
     ifStmt(cmpge(local("r1"),iValue(intValue(10))),"label2"),
     assign(localVariable("$r1"),plus(local("r2"),local("r1")),context=stmtContext(9,"TObject(\"samples.controlStatements.WhileStatement\").execute()",8)),
     assign(localVariable("r2"),immediate(local("$r1")),context=stmtContext(10,"TObject(\"samples.controlStatements.WhileStatement\").execute()",8)),
     assign(localVariable("r1"),plus(local("r1"),iValue(intValue(1))),context=stmtContext(12,"TObject(\"samples.controlStatements.WhileStatement\").execute()",9)),
     gotoStmt("label1"),
   label("label2"),
     returnStmt(local("r2"),context=stmtContext(16,"TObject(\"samples.controlStatements.WhileStatement\").execute()",11))
  ];  
  switch(c) {
    case classDecl(_, _, _, _, _, methods): { 
      list[Statement] ss = methods[1].body.stmts; 
      return expected == ss; 
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
 
