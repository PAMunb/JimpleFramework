module TestFlowGraph

import lang::jimple::analysis::FlowGraph;
import lang::jimple::Syntax; 

import Set; 

test bool testSimpleGraph() {
  vars = [localVariableDeclaration(TInteger(), "x"), localVariableDeclaration(TInteger(), "y")];
                                      
  s1 = assign(localVariable("x"), immediate(iValue(intValue(4)))); 
  s2 = assign(localVariable("y"), immediate(iValue(intValue(10)))); 	
  s3 = assign(localVariable("r"), plus(local("x"), local("y"))); 
  
  b = methodBody(vars, [s1,s2,s3], []); 
  
  g = forwardFlowGraph(b);
  
  return size(g) == 4 && g == {<startNode(), stmtNode(s1)>, <stmtNode(s1), stmtNode(s2)>, <stmtNode(s2), stmtNode(s3)>, <stmtNode(s3), endNode()>}; 	
}