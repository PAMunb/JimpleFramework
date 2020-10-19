module lang::jimple::tests::TestFlowGraph

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
  
  return size(g) == 4 && g == { <entryNode(), stmtNode(s1)>
                              , <stmtNode(s1), stmtNode(s2)>
                              , <stmtNode(s2), stmtNode(s3)>
                              , <stmtNode(s3), exitNode()>
                              }; 	
}

test bool testMapLabels() {
  Statement s1 = assign(localVariable("l1"), immediate(local("l0"))); 
  Statement s2 = label("label1:"); 
  Statement s3 = ifStmt(cmple(local("l0"), iValue(intValue(0))), "label2:");
  Statement s4 = assign(localVariable("l0"), plus(local("l0"), iValue(intValue(-1)))); 
  Statement s5 = assign(localVariable("l2"), mult(local("l0"), local("l1")));
  Statement s6 = assign(localVariable("l1"), immediate(local("l2"))); 
  Statement s7 = gotoStmt("label1:"); 
  Statement s8 = label("label2:");
  Statement s9 = returnStmt(local("l1"));  
  
  list[Statement] stmts = [s1, s2, s3, s4, s5, s6, s7, s8, s9]; 
  
  return mapLabels(stmts) == ("label1:" : s3, "label2:" : s9); 
}

test bool testFactorialFlowGraph() {
  Statement s1 = assign(localVariable("l1"), immediate(local("l0"))); 
  Statement s2 = label("label1:"); 
  Statement s3 = ifStmt(cmple(local("l0"), iValue(intValue(0))), "label2:");
  Statement s4 = assign(localVariable("l0"), plus(local("l0"), iValue(intValue(-1)))); 
  Statement s5 = assign(localVariable("l2"), mult(local("l0"), local("l1")));
  Statement s6 = assign(localVariable("l1"), immediate(local("l2"))); 
  Statement s7 = gotoStmt("label1:"); 
  Statement s8 = label("label2:");
  Statement s9 = returnStmt(local("l1"));  
  
  list[Statement] stmts = [s1, s2, s3, s4, s5, s6, s7, s8, s9]; 
  
  MethodBody factorialMethodBody = methodBody([], stmts, []);
  
  g = forwardFlowGraph(factorialMethodBody);
  
  return size(g) == 9 && g == { <entryNode(), stmtNode(s1)>
                              , <stmtNode(s1), stmtNode(s3)> 
                              , <stmtNode(s3), stmtNode(s4)> 
                              , <stmtNode(s3), stmtNode(s9)>
                              , <stmtNode(s4), stmtNode(s5)>
                              , <stmtNode(s5), stmtNode(s6)>
                              , <stmtNode(s6), stmtNode(s7)>
                              , <stmtNode(s7), stmtNode(s3)>
                              , <stmtNode(s9), exitNode()> 
                              }; 
}