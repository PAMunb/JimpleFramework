module lang::jimple::core::Parser

import ParseTree;

import lang::jimple::core::Syntax;
import lang::jimple::core::ConcreteSyntax;


public ClassOrInterfaceDeclaration parseJimpleCode(str code) {
   parseTree = parse(#JimpleClassOrInterfaceDeclaration, code); 
   return implode(#ClassOrInterfaceDeclaration, parseTree); 
}