module lang::jimple::tests::TestTransformations

import lang::jimple::core::Syntax;
import lang::jimple::decompiler::Decompiler; 
import lang::jimple::core::Context;
//import lang::jimple::toolkit::PrettyPrinter; 
import lang::jimple::util::JPrettyPrinter; 

import  IO;
import String;

test bool testInitial(){

	files = [|project://JimpleFramework/src/test/resources/iris-core/|];
	
    es = [];
    
	c = createExecutionContext(files, es);
    
    println([f | f <- c]); 
     
	return true;
}
