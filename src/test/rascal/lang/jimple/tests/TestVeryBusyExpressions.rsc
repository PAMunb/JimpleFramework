module lang::jimple::tests::TestVeryBusyExpressions

import lang::jimple::core::Syntax; 

import lang::jimple::toolkit::FlowGraph;

import lang::jimple::analysis::dataflow::Framework;
import lang::jimple::analysis::dataflow::VeryBusyExpressions; 


//example from book: Principles of Program Analysis
Statement s1  = ifStmt(cmpgt(local("a"),local("b")),"label1");
Statement s6  = assign(localVariable("y"),minus(local("b"),local("a")));
Statement s8  = assign(localVariable("x"),minus(local("a"),local("b")));
Statement s4  = gotoStmt("label2");
	
Statement s5  = label("label1");
Statement s2  = assign(localVariable("x"),minus(local("b"),local("a")));
Statement s3  = assign(localVariable("y"),minus(local("a"),local("b")));
	
Statement s9  = label("label2");
Statement s10  = returnEmptyStmt();	
	
list[Statement] ss = [ s1,  s2,  s3,  s4,  s5,  s6,  s8, s9, s10 ]; 
  
public MethodBody b = methodBody([], ss, []);


test bool testVeryBusyExpressions() {
   	AnalysisResult[Expression] res = execute(vb, b); 
   	
   	return res.inSet[stmtNode(s1)]   == { minus(local("b"),local("a")), minus(local("a"),local("b")) }
       && res.outSet[stmtNode(s1)]  == { minus(local("b"),local("a")), minus(local("a"),local("b")) }
       
       && res.inSet[stmtNode(s2)]   == { minus(local("b"),local("a")), minus(local("a"),local("b")) }
       && res.outSet[stmtNode(s2)]  == { minus(local("a"),local("b")) }
       
       && res.inSet[stmtNode(s3)]   == { minus(local("a"),local("b")) }
       && res.outSet[stmtNode(s3)]  == { }
       
       && res.inSet[stmtNode(s4)]   == { }
       && res.outSet[stmtNode(s4)]  == { }
       
       && res.inSet[stmtNode(s5)]   == { minus(local("b"),local("a")), minus(local("a"),local("b")) }
       && res.outSet[stmtNode(s5)]  == { minus(local("b"),local("a")), minus(local("a"),local("b")) }
       
       && res.inSet[stmtNode(s6)]   == { minus(local("b"),local("a")), minus(local("a"),local("b"))  }
       && res.outSet[stmtNode(s6)]  == { minus(local("a"),local("b")) }
       
       && res.inSet[stmtNode(s8)]   == { minus(local("a"),local("b")) }
       && res.outSet[stmtNode(s8)]  == { }
       
       && res.inSet[stmtNode(s9)]   == { minus(local("b"),local("a")), minus(local("a"),local("b")) }
       && res.outSet[stmtNode(s9)]  == { minus(local("b"),local("a")), minus(local("a"),local("b")) }
       
       && res.inSet[stmtNode(s10)]   == { }
       && res.outSet[stmtNode(s10)]  == { }
       ;   
}
