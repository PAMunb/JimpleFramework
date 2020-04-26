module lang::jimple::Decompiler

import lang::jimple::Syntax;

@javaClass{lang.jimple.internal.Decompiler}
java str foo(); 


@javaClass{lang.jimple.internal.Decompiler}
java ClassOrInterfaceDeclaration decompile(loc classFile) throws IO; 