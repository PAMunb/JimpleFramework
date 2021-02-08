module lang::jimple::tests::TestAvailableExpressions

import lang::jimple::core::Syntax; 

import lang::jimple::toolkit::FlowGraph;

import lang::jimple::analysis::dataflow::Framework;
import lang::jimple::analysis::dataflow::AvailableExpressions; 

import IO;

Statement s1  = assign(localVariable("b"), immediate(iValue(intValue(4))));
Statement s2  = assign(localVariable("a"), plus(local("b"), local("c")));
Statement s3  = assign(localVariable("d"), mult(local("a"), local("b")));

Statement s4  = ifStmt(cmple(local("d"), iValue(intValue(0))), "label4:");

Statement s5  = assign(localVariable("c"), plus(local("b"), local("c")));

Statement s6  = ifStmt(cmple(local("c"), iValue(intValue(0))), "label2:");

Statement s7  = label("label1:"); 
Statement s8  = assign(localVariable("d"), plus(local("a"), local("b")));
Statement s9  = assign(localVariable("f"), plus(local("b"), local("c")));
Statement s10 = ifStmt(cmple(local("f"), iValue(intValue(0))), "label1:");
Statement s11 = gotoStmt("label3:"); 

Statement s12  = label("label2:"); 
Statement s13  = assign(localVariable("c"), mult(local("a"), local("b")));
Statement s14  = assign(localVariable("f"), minus(local("a"), local("b")));

Statement s15  = label("label3:"); 
Statement s16  = assign(localVariable("g"), plus(local("a"), local("b")));
Statement s17 = gotoStmt("label5:"); 

Statement s18  = label("label4:"); 
Statement s19  = assign(localVariable("b"), minus(local("a"), local("c")));

Statement s20  = label("label5:");
Statement s21  = assign(localVariable("h"), minus(local("a"), local("c")));
Statement s22  = assign(localVariable("i"), plus(local("b"), local("c")));

Statement s23 = returnStmt(local("i"));  

list[Statement] ss = [ s1,  s2,  s3,  s4,  s5,  s6,  s7,  s8, s9, s10
                     ,s11, s12, s13, s14, s15, s16, s17, s18,s19, s20
                     ,s21, s22, s23
                     ]; 
  
public MethodBody b = methodBody([], ss, []);

test bool testAvailableExpressions() {
   tuple[Abstraction[Expression] inSet, Abstraction[Expression] outSet] res = execute(ae, b); 
   return res.inSet[stmtNode(s1)]   == {}
       && res.outSet[stmtNode(s1)]  == {}
       && res.inSet[stmtNode(s2)]   == {}
       && res.outSet[stmtNode(s2)]  == { plus(local("b"), local("c")) }
       && res.inSet[stmtNode(s3)]   == { plus(local("b"), local("c")) }
       && res.outSet[stmtNode(s3)]  == { plus(local("b"), local("c")), mult(local("a"), local("b")) }
       && res.inSet[stmtNode(s5)]   == { plus(local("b"), local("c")), mult(local("a"), local("b")) }
       && res.outSet[stmtNode(s5)]  == { plus(local("b"), local("c")), mult(local("a"), local("b")) }
       && res.inSet[stmtNode(s8)]   == { plus(local("b"), local("c")) }
       && res.outSet[stmtNode(s8)]  == { plus(local("a"), local("b")), plus(local("b"), local("c")) }
       && res.inSet[stmtNode(s9)]   == { plus(local("a"), local("b")), plus(local("b"), local("c")) }
       && res.inSet[stmtNode(s19)]  == { plus(local("b"), local("c")), mult(local("a"), local("b")) }
       && res.outSet[stmtNode(s19)] == { minus(local("a"), local("c")) }
       ;
   
}
