module \test::rascal::TestDecompiler

import lang::jimple::Syntax;
import lang::jimple::Decompiler; 


loc classLocation = |project://JimpleFramework/target/classes/test/java/AbstractClassSample.class|;  
loc interfaceLocation = |project://JimpleFramework/target/classes/test/java/InterfaceSample.class|;  

 test bool testAbstractClass() {
    ClassOrInterfaceDeclaration c = decompile(classLocation);
    switch(c) {
      case class(_): return c.fields == [] && c.interfaces == [] && c.super == object("java.lang.Object");  
      default: return false; 
    }
 }
 
 test bool testInterface() {
    ClassOrInterfaceDeclaration c = decompile(interfaceLocation);
    switch(c) {
      case interface(_): return true;  
      default: return false; 
    }
 }
 
