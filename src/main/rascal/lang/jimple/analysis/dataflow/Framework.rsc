module lang::jimple::analysis::dataflow::Framework

import lang::jimple::Syntax; 
import lang::jimple::analysis::FlowGraph; 

alias Definition = Statement; 
alias LocalVariable = str;

alias Abstraction[&T] = map[Node, set[&T]];
alias AnalysisResult[&T] = tuple[Abstraction[&T] inSet, Abstraction[&T] outSet];


map[LocalVariable, set[Definition]] localDefs = (); 

data Direction = Forward()
               | Backward()
               ;

data MeetOperator = Union()  
                  | Intersection()
                  ; 

data TransferFunctions[&T] = transfer(set[&T] () bottom, set[&T] (Statement) gen, set[&T] (Statement) kill); 
          
data DFA[&T] = dfa(Direction direction, MeetOperator opr, TransferFunctions[&T] tf); 

public AnalysisResult[&T] execute(DFA[&T] a, MethodBody b) {
   localDefs = loadDefinitions(b.stmts);
   
   Abstraction[&T] genSet  = (stmtNode(s): a.tf.gen(s)  | s <- b.stmts); 
   Abstraction[&T] killSet = (stmtNode(s): a.tf.kill(s) | s <- b.stmts);  
 
   return analyze(a.direction, a.opr, genSet, killSet, a.tf.bottom(), b); 
}

private AnalysisResult[&T] analyze(Direction dir, MeetOperator opr, Abstraction[&T] genSet, Abstraction[&T] killSet, set[&T] bottom, MethodBody b) {
   g = dir == Forward() ? forwardFlowGraph(b) : backwardFlowGraph(b); 
   btm = dir == Forward() ? entryNode() : exitNode(); 
   Abstraction[&T] set1 = ();
   Abstraction[&T] set2 = (btm : bottom) + ( stmtNode(n) : {} | <stmtNode(n), _> <- g); 
   solve(set2) {
      list[Node] ns = [stmtNode(s) | s <- b.stmts];  
      for(n <- ns) {
          set1[n]  = ({} | merge(opr, it, set2[from]) | <from, to> <- g, to := n); 
  	      set2[n] = genSet[n] + (set1[n] - killSet[n]);      
      }
   }
   return dir == Forward() ? <set1,set2> : <set2, set1>;
}

private set[&T] merge(Union(), set[&T] s1, set[&T] s2) = s1 + s2;           // merge using the union operator
private set[&T] merge(Intersection(), set[&T] s1, set[&T] s2) = s1 & s2;    // merge using the intersection operator

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
  