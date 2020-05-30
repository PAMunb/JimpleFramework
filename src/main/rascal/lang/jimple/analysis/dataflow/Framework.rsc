module lang::jimple::analysis::dataflow::Framework

import lang::jimple::Syntax; 
import lang::jimple::analysis::FlowGraph; 

alias Abstraction[&T] = map[Node, set[&T]];
alias AnalysisResult[&T] = tuple[Abstraction[&T] inSet, Abstraction[&T] outSet];

data Direction = Forward()
               | Backward()
               ;

data MeetOperator = Union()  
                  | Intersection()
                  ; 
          
data DFA[&T] = dfa(Direction direction, MeetOperator opr, set[&T] (Statement) gen, set[&T] (Statement) kill); 

public AnalysisResult[&T] run(DFA[&T] a, MethodBody b) {
   Abstraction[&T] genSet  = (stmtNode(s): a.gen(s)  | s <- b.stmts); 
   Abstraction[&T] killSet = (stmtNode(s): a.kill(s) | s <- b.stmts);  
     
   if(a.direction == Forward()) {
     return forward(a.opr, genSet, killSet, b);
   } 
   return forward(a.opr, genSet, killSet, b); 
}

private AnalysisResult[&T] forward(MeetOperator opr, Abstraction[&T] genSet, Abstraction[&T] killSet, MethodBody b) {
   g = forwardFlowGraph(b); 
   Abstraction[&T] inSet = ();
   Abstraction[&T] outSet = (entryNode() : {}) + ( stmtNode(n) : {} | <stmtNode(n), _> <- g); 
   
   
   solve(outSet) {
      list[Node] ns = [stmtNode(s) | s <- b.stmts];  
      for(n <- ns) {
          inSet[n]  = ({} | merge(opr, it, outSet[from]) | <from, to> <- g, to := n); 
  	      outSet[n] = genSet[n] + (inSet[n] - killSet[n]);      
      }
   }
   return <inSet, outSet>;
}

private set[&T] merge(Union(), set[&T] s1, set[&T] s2) = s1 + s2; 
private set[&T] merge(Intersection(), set[&T] s1, set[&T] s2) = s1 & s2; 
  