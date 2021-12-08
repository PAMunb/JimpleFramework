module lang::jimple::decompiler::jimplify::RemoveModifiers

import lang::jimple::core::Syntax;
 
/**
 * An auxiliarly function to process all Jimple labels and 
 * goto statements, translating them to a more user friendly 
 * format. 
 *
 * This is an example of source-to-source transformation used to 
 * jimplify Jimple code. 
 */ 

//set[Modifier] VALID_MODIFIERS = {Public(), Protected(), Private(), Abstract(), Static(), Final(), Strictfp()};

set[Modifier] INVALID_MODIFIERS = {Synchronized(), Native(), Transient(), Volatile(), Enum(), Annotation(), Synthetic()};

public ClassOrInterfaceDeclaration processModifiers(ClassOrInterfaceDeclaration c) { 

  c = top-down visit(c) {

    case classDecl(modifiers, classType, superClass, interfaces, fields, methods) => 
    	 classDecl([m | m <- modifiers, !(m in INVALID_MODIFIERS)], classType, superClass, interfaces, fields, methods) 
    
    case interfaceDecl(modifiers, interfaceType, interfaces, fields, methods) => 
    	 interfaceDecl([m | m <- modifiers, !(m in INVALID_MODIFIERS)], interfaceType, interfaces, fields, methods)   
    	     
  }
  
  return c;   
}
