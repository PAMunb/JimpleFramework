module lang::jimple::toolkit::PrettyPrinter

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;
import lang::jimple::util::JPrettyPrinter;

/*
 * TODO PP: 
 *	Indentation must be made easier, configurable and less error prone.
 *	Methods in interfaces are printed in a diferent way than in classes; interfaces have a ';' and no {}.
 *	 
 * TODO Jimple Decompiler:
 *  Missing local variable decl (the one with $ symbol.
 *  execute from Context does not process interfaces.
 *  Sort LocalVariableDeclaration by variable name.
 *  Changes in .classpath file  made the test-classes dir, on target, disappear. This broke the Test*.rsc files. 
 */

alias PrettyPrintMap = map[str, str]; 

public data PrettyPrintModel = PrettyPrintModel(PrettyPrintMap ppMap);

public PrettyPrintMap PrettyPrint(ExecutionContext ctx) {
	PrettyPrintMap ppMap = ();
	
	top-down visit(ctx) {
		case classDecl(n, ms, s, is, fs, mss): ppMap[prettyPrint(n)] = prettyPrint(classDecl(n, ms, s, is, fs, mss));
		case interfaceDecl(n, ms, is, fs, mss):ppMap[prettyPrint(n)] = prettyPrint(interfaceDecl(n, ms, is, fs, mss));	
	}	
	return ppMap;
}

