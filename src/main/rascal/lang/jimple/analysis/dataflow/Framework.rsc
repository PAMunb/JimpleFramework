module lang::jimple::analysis::dataflow::Framework

import lang::jimple::core::Syntax; 
import lang::jimple::toolkit::FlowGraph; 

alias Definition = Statement; 
alias LocalVariable = str;

alias Abstraction[&T] = map[Node, set[&T]];
alias AnalysisResult[&T] = tuple[Abstraction[&T] inSet, Abstraction[&T] outSet];

map[LocalVariable, set[Definition]] localDefs = (); 
set[Expression] binExpressions = {}; 

data Direction = Forward()
               | Backward()
               ;

data MeetOperator = Union()  
                  | Intersection()
                  ; 

data TransferFunctions[&T] 
  = transfer(set[&T] () boundary, set[&T] (Statement) gen, set[&T] (Statement) kill, set[&T] (MethodBody) init); 
          
data DFA[&T] = dfa(Direction direction, MeetOperator opr, TransferFunctions[&T] tf); 

public AnalysisResult[&T] execute(DFA[&T] a, MethodBody b) {
   localDefs = loadDefinitions(b.stmts);
   binExpressions = loadBinExpressions(b); 
   
   return analyze(a, b); 
}

private AnalysisResult[&T] analyze(DFA[&T] d, MethodBody b) {
   g = d.direction == Forward() ? forwardFlowGraph(b) : backwardFlowGraph(b); 
   btm = d.direction == Forward() ? entryNode() : exitNode(); 
   
   Abstraction[&T] set1 = ();
   Abstraction[&T] set2 = (btm : d.tf.boundary()) + (stmtNode(s) : d.tf.init(b) | s <- b.stmts); 
   
   Abstraction[&T] genSet  = (stmtNode(s): d.tf.gen(s)  | s <- b.stmts); 
   Abstraction[&T] killSet = (stmtNode(s): d.tf.kill(s) | s <- b.stmts);  
 
   solve(set2) {
      list[Node] ns = [stmtNode(s) | s <- b.stmts];  
      for(n <- ns) {
          set1[n]  = (d.tf.init(b) | merge(d.opr, it, set2[from]) | <from, to> <- g, to := n); 
          set2[n] = genSet[n] + (set1[n] - killSet[n]);      
      }
   }
   return d.direction == Forward() ? <set1,set2> : <set2, set1>;
}

private set[&T] merge(Union(), set[&T] s1, set[&T] s2) = s1 + s2;           // merge using the union operator
private set[&T] merge(Intersection(), set[&T] s1, set[&T] s2) = s1 & s2;    // merge using the intersection operator

set[Expression] loadBinExpressions(MethodBody b) = {e | /Expression e <- b, binArithmeticExpression(e)}; 

@synopsis{recovers the local definitions of each variable.}  

map[LocalVariable, set[Definition]] loadDefinitions([]) = (); 

map[LocalVariable, set[Definition]] loadDefinitions([assign(localVariable(v), e), *Statement SS]) = defs + (v : (assign(localVariable(v), e) + defs[v]))
  when defs := loadDefinitions(SS)
     , v in defs
     ;

map[LocalVariable, set[Definition]] loadDefinitions([assign(localVariable(v), e), *Statement SS]) = defs + (v : { (assign(localVariable(v), e)) } )
  when defs := loadDefinitions(SS)
     , v notin defs
     ; 
           
map[LocalVariable, set[Definition]] loadDefinitions([_, *Statement SS]) = defs
   when defs := loadDefinitions(SS)
      ;
  
  
private bool binArithmeticExpression(Expression e) {
  switch(e) {
    case plus(_, _)  : return true;  
    case minus(_, _) : return true; 
    case mult(_, _)  : return true;  
    case div(_, _)   : return true; 
  }
  return false; 
}  