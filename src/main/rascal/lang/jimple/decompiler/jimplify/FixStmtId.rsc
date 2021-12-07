module lang::jimple::decompiler::jimplify::FixStmtId

import lang::jimple::core::Syntax; 
import lang::jimple::util::Converters; 

public ClassOrInterfaceDeclaration fixStmtId(ClassOrInterfaceDeclaration c) { 
 stmtId = 0; 
 c = top-down visit(c) {
    case Method _ : stmtId = 0; 
    
    case stmtContext(_, sig, line): {
       stmtId = stmtId + 1; 
       insert stmtContext(stmtId, sig, line);
    }
  };
  return c;   
}

