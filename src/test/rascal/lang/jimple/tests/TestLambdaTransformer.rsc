module lang::jimple::tests::TestLambdaTransformer

import lang::jimple::core::Syntax; 
import lang::jimple::decompiler::Decompiler;
import lang::jimple::decompiler::jimplify::LambdaTransformer; 
import List; 

loc classLocation = |project://JimpleFramework/target/test-classes/samples/SimpleLambdaExpression.class|;  


test bool testLambdaTransformer() { 
  ClassOrInterfaceDeclaration c = decompile(classLocation);
  
  list[ClassOrInterfaceDeclaration] classes = lambdaTransformer(c);
  
  return size(classes) == 1; 
}