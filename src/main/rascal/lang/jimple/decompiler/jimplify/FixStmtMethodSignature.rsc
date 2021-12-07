module lang::jimple::decompiler::jimplify::FixStmtMethodSignature

import lang::jimple::core::Syntax; 
import lang::jimple::util::Converters; 

import Node; 

public ClassOrInterfaceDeclaration fixSignature(ClassOrInterfaceDeclaration c) { 
 c = top-down-break visit(c) {
    case Method m  => processMethod(className(c), m)  
  };
  return c;   
}

Method processMethod(str cn, Method m) {
   m = top-down visit(m) {
      case stmtContext(id, _, line) => stmtContext(id, signature(cn, m.name, m.formals), line)   
   };
   return m;
}


str className(ClassOrInterfaceDeclaration c) {
   str res = "";
   switch(c) {
   	case classDecl(_, \type, _, _, _, _):  res = toString(\type); 
   	case interfaceDecl(_, \type, _, _, _): res = toString(\type); 
   }; 
   return res; 
}