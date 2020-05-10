module TestDecompiler

import lang::jimple::Syntax;
import lang::jimple::Decompiler; 

import IO;

loc classLocation = |project://JimpleFramework/target/classes/test/java/AbstractClassSample.class|;  
loc interfaceLocation = |project://JimpleFramework/target/classes/test/java/InterfaceSample.class|;  

 test bool testAbstractClass() {
    ClassOrInterfaceDeclaration c = decompile(classLocation);
    switch(c) {
      case classDecl(_, _, _, _, _, _): return true;  
      default: return false; 
    }
 }
 
 test bool testInterface() {
    ClassOrInterfaceDeclaration c = decompile(interfaceLocation);
    println(c); 
    switch(c) {
      case interfaceDecl(TObject("test.java.InterfaceSample"), _, _, _, _): return true;  
      default: return false; 
    }
 }
 
