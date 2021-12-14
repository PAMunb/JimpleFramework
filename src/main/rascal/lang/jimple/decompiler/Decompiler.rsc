module lang::jimple::decompiler::Decompiler

extend lang::jimple::core::Syntax;

import lang::jimple::decompiler::jimplify::Transformations;
 
import IO;  
import Exception;


bool defaultKeepOriginalVarNames = true;

public ClassOrInterfaceDeclaration decompile(loc classFile) throws IO {
	return decompile(classFile, defaultKeepOriginalVarNames);
}

public ClassOrInterfaceDeclaration decompile(loc classFile, bool keepOriginalVarNames) throws IO {
	return jimplify(bytecodeToJimple(classFile, keepOriginalVarNames));	
}

@javaClass{lang.jimple.internal.Decompiler}
@reflect{for stdout} 
java ClassOrInterfaceDeclaration bytecodeToJimple(loc classFile, bool keepOriginalVarNames) throws IO; 
