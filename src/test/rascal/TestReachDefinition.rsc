module TestReachDefinition

import lang::jimple::core::Syntax;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::analysis::dataflow::Framework; 
import lang::jimple::analysis::dataflow::ReachDefinition; 

import Map; 

Statement s1 = assign(localVariable("l1"), immediate(local("l0"))); 
Statement s2 = label("label1:"); 
Statement s3 = ifStmt(cmple(local("l0"), iValue(intValue(0))), "label2:");
Statement s4 = assign(localVariable("l0"), plus(local("l0"), iValue(intValue(-1)))); 
Statement s5 = assign(localVariable("l2"), mult(local("l0"), local("l1")));
Statement s6 = assign(localVariable("l1"), immediate(local("l2"))); 
Statement s7 = gotoStmt("label1:"); 
Statement s8 = label("label2:");
Statement s9 = returnStmt(local("l1"));  
  
list[Statement] ss = [s1, s2, s3, s4, s5, s6, s7, s8, s9]; 
  
MethodBody b = methodBody([], ss, []);

//test bool testLoadDefinitions() {
//  return loadDefinitions(b.stmts) == ("l1" : {s1, s6}, "l0" : {s4}, "l2" : {s5}); 
//}

test bool testReachDefinitions() {
  // tuple[Abstraction inSet, Abstraction outSet] reachDefs = reachDefinition(b, loadDefinitions(b.stmts)); 
  tuple[map[Node, set[Statement]] inSet, map[Node, set[Statement]] outSet] reachDefs = execute(rd, b);
  return size(reachDefs.inSet)  == 9                     // the current flow graph impl is discarding labels  
      && size(reachDefs.outSet) == 10                    // 1 more due to the entryNode()
      && reachDefs.inSet[stmtNode(s1)]  == {}
      && reachDefs.outSet[stmtNode(s1)] == {s1}
      && reachDefs.inSet[stmtNode(s3)] == {s1,s4,s5,s6}
      && reachDefs.outSet[stmtNode(s3)] == {s1,s4,s5,s6}
      && reachDefs.inSet[stmtNode(s4)]  == {s1,s4,s5,s6} 
      && reachDefs.outSet[stmtNode(s4)] == {s1,s4,s5,s6}
      && reachDefs.inSet[stmtNode(s5)]  == {s1,s4,s5,s6} 
      && reachDefs.outSet[stmtNode(s5)] == {s1,s4,s5,s6}
      && reachDefs.inSet[stmtNode(s6)]  == {s1,s4,s5,s6} 
      && reachDefs.outSet[stmtNode(s6)] == {s4,s5,s6}
      && reachDefs.inSet[stmtNode(s7)]  == {s4,s5,s6} 
      && reachDefs.outSet[stmtNode(s7)] == {s4,s5,s6}
      && reachDefs.inSet[stmtNode(s9)]  == {s1,s4,s5,s6} 
      && reachDefs.outSet[stmtNode(s9)] == {s1,s4,s5,s6}
      ; 
}
