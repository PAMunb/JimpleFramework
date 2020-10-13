module lang::jimple::Decompiler

import lang::jimple::Syntax;
import lang::jimple::core::Context;
 
import IO;  

import Exception;

@javaClass{lang.jimple.internal.Decompiler}
@reflect{for stdout}
java ClassOrInterfaceDeclaration decompile(loc classFile) throws IO; 



