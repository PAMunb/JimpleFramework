module lang::jimple::decompiler::jimplify::LambdaTransformer

import lang::jimple::core::Syntax; 

import IO;


public list[ClassOrInterfaceDeclaration] lambdaTransformer(ClassOrInterfaceDeclaration c) {
  list[ClassOrInterfaceDeclaration] classes = [c]; 
  int total = 0; 
  
  visit(c) {
    case dynamicInvoke(_, _, _, _): total = total + 1;
  }
  
  println("\n - Number of Transformations: <total>"); 
  return classes; 
}