module TestConstantPropagationAndFolder

import lang::jimple::core::Syntax;
import lang::jimple::decompiler::jimplify::ConstantPropagatorAndFolder;

import Map; 
import IO;

test bool testConstantFold() {
	
	Statement p1 = assign(localVariable("l1"), immediate(iValue(intValue(1))));

	Statement p2 = assign(localVariable("l2"), immediate(iValue(intValue(2))));	
    
	Statement p3  = nop(); 
	
	Statement p4 = assign(localVariable("l1"), plus(local("l1"), iValue(intValue(1))));

	list[Statement] ss = [p1, p2, p3, p4]; 
	  
	MethodBody b = methodBody([], ss, []);

	m = method([], TInteger(), "add", [], [], b);
	
	processConstantPropagatorAndFolder(classDecl(TObject("Teste"), [], object(), [], [], [m]));
	 
	return true;
}
