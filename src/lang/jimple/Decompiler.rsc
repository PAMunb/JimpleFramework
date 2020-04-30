module lang::jimple::Decompiler

import lang::jimple::Syntax;
import Exception;

@javaClass{lang.jimple.internal.Decompiler}
java ClassOrInterfaceDeclaration decompile(loc classFile) throws IO; 