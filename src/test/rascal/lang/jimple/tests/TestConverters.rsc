module lang::jimple::tests::TestConverters

import lang::jimple::util::Converters;
import lang::jimple::core::Syntax;

test bool testgetTypeVar() {
	MethodBody b = methodBody(  
		    [localVariableDeclaration(TArray(TObject("java.lang.String")),"r6"),
		    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"$r0"),
		    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"r1"),
		    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"r2"),
		    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"$r3"),
		    localVariableDeclaration(TObject("samples.pointsto.ex2.O"),"r4"),
		    localVariableDeclaration(TDouble(),"r5")],
		    [],[]);	
	return (getTypeVar(b, "r6") == TArray(TObject("java.lang.String")) &&
			getTypeVar(b, "r5") == TDouble() && 
			getTypeVar(b, "$r0") == TObject("samples.pointsto.ex2.O"));
}