module TestLiveVariable

import lang::jimple::core::Syntax;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::analysis::dataflow::Framework; 
import lang::jimple::analysis::dataflow::LiveVariable; 

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


test bool testReachDefinitions() {
  // tuple[Abstraction inSet, Abstraction outSet] reachDefs = reachDefinition(b, loadDefinitions(b.stmts)); 
  tuple[map[Node, set[LocalVariable]] inSet, map[Node, set[LocalVariable]] outSet] lvs = execute(lv, b);
  return lvs.outSet[stmtNode(s9)] == { }
      && lvs.inSet[stmtNode(s9)]  == {"l1"}  
      && lvs.outSet[stmtNode(s7)] == {"l1", "l0"}
      && lvs.inSet[stmtNode(s7)]  == {"l1", "l0"}
      && lvs.outSet[stmtNode(s6)] == {"l1", "l0"}
      && lvs.inSet[stmtNode(s6)]  == {"l2", "l0"}
      && lvs.outSet[stmtNode(s5)] == {"l2", "l0"}
      && lvs.inSet[stmtNode(s5)]  == {"l1", "l0"}
      && lvs.outSet[stmtNode(s4)] == {"l1", "l0"}
      && lvs.inSet[stmtNode(s4)]  == {"l1", "l0"}
      && lvs.outSet[stmtNode(s3)] == {"l1", "l0"}
      && lvs.inSet[stmtNode(s3)]  == {"l1", "l0"}
      && lvs.outSet[stmtNode(s1)] == {"l1", "l0"}
      && lvs.inSet[stmtNode(s1)]  == {"l0"}
      ; 
}
