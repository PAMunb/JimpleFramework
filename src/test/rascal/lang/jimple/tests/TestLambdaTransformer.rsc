module lang::jimple::tests::TestLambdaTransformer

import lang::jimple::core::Syntax; 
import lang::jimple::decompiler::Decompiler;
import lang::jimple::decompiler::jimplify::LambdaTransformer;
import lang::jimple::util::JPrettyPrinter; 
 
import List;
import IO;


str samplesPath = "JimpleFramework/target/test-classes/samples/";

lrel[loc, int] testRelation = [<|project://<samplesPath>SimpleLambdaExpression.class|, 2>,			// 0: Simple Lambda
							   <|project://<samplesPath>/arrays/ArrayExample.class|, 3>,			// 1: Array Lambda
							   <|project://<samplesPath>/lambdaExpressions/AddLambda.class|, 2>,	// 2: Interface Lambda
							   <|project://<samplesPath>/lambdaExpressions/Palindromes.class|, 4>,	// 3: Palindrome Lambda
							   <|project://<samplesPath>/lambdaExpressions/Runners.class|, 7>,		// 4: Multiple Runnable Lambdas
							   <|project://<samplesPath>/lambdaExpressions/SumList.class|, 2>,		// 5: List Lambda
							   <|project://<samplesPath>/lambdaExpressions/IncClosure.class|, 2>];	// 6: Closure

test bool testLambdaTransformer() { 

  int n = 3;
  loc classLocation = testRelation[n][0];
  
  ClassOrInterfaceDeclaration c = decompile(classLocation);
  
  println(prettyPrint(c));
  
  list[ClassOrInterfaceDeclaration] classes = lambdaTransformer(c);
  for(ClassOrInterfaceDeclaration aClass <- classes) {
  	println(prettyPrint(aClass));
  	//println(aClass);	//abstract syntax tree
  }
  
  return size(classes) == testRelation[n][1]; 
}