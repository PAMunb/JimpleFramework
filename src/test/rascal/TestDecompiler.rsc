module TestDecompiler

import lang::jimple::Syntax;
import lang::jimple::Decompiler; 
import List;
import Set;
import IO;
import String;
import io::IOUtil;


loc classLocation = |project://JimpleFramework/target/test-classes/samples/AbstractClassSample.class|;  
loc interfaceLocation = |project://JimpleFramework/target/test-classes/samples/InterfaceSample.class|;

loc path = |project://JimpleFramework/target/test-classes/samples/operators|;

 test bool testAbstractClass() {
    ClassOrInterfaceDeclaration c = decompile(classLocation);
    switch(c) {
      case classDecl(_, _, _, _, _, _): return true;  
      default: return false; 
    }
 }
 
 test bool testInterface() {
    ClassOrInterfaceDeclaration c = decompile(interfaceLocation);
    switch(c) {
      case interfaceDecl(TObject("samples.InterfaceSample"), _, _, _, _): return true;  
      default: return false; 
    }
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
   	println("Total number of classes: <count>");
   	
   	if(size(results) > 0){
   		println(results);
   		return false;
   	}
   	
   	return true;
}
 
