module lang::jimple::tests::TestControlDependencyGraph

import lang::jimple::core::Syntax; 
import lang::jimple::toolkit::FlowGraph;

test bool testIfStatement() { 
  vars = [localVariableDeclaration(TInteger(), "x")]; 
  
  s1 = assign(localVariable("x"), immediate(iValue(intValue(1))));
  s2 = ifStmt(cmple(local("x"), iValue(intValue(1))), "label1");
  s3 = assign(localVariable("x"), immediate(iValue(intValue(2))));
  s4 = label("label1"); 
  s5 = assign(localVariable("x"), immediate(iValue(intValue(4))));
  s6 = returnEmptyStmt();
  
  b = methodBody(vars, [s1, s2, s3, s4, s5, s6], []); 
  
  g = forwardFlowGraph(b);
  
  return true;
}