module lang::jimple::decompiler::Decompiler

extend lang::jimple::core::Syntax;
 
import IO;  
import Exception;


bool defaultKeepOriginalVarNames = false;

public ClassOrInterfaceDeclaration decompile(loc classFile) throws IO {
	return decompile(classFile, defaultKeepOriginalVarNames);
}

@javaClass{lang.jimple.internal.Decompiler}
@reflect{for stdout} 
java ClassOrInterfaceDeclaration decompile(loc classFile, bool keepOriginalVarNames) throws IO; 
