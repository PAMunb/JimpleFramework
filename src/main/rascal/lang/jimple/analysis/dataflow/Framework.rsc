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

public AnalysisResult[&T] run(DFA[&T] a, MethodBody b) {
   localDefs = loadDefinitions(b.stmts);
   
   Abstraction[&T] genSet  = (stmtNode(s): a.tf.gen(s)  | s <- b.stmts); 
   Abstraction[&T] killSet = (stmtNode(s): a.tf.kill(s) | s <- b.stmts);  
   if(a.direction == Forward()) {
     return forward(a.opr, genSet, killSet, a.tf.bottom(), b);
   } 
   return backward(a.opr, genSet, killSet, a.tf.bottom(), b); 
}

private AnalysisResult[&T] forward(MeetOperator opr, Abstraction[&T] genSet, Abstraction[&T] killSet, set[&T] bottom, MethodBody b) {
   g = forwardFlowGraph(b); 
   Abstraction[&T] inSet = ();
   Abstraction[&T] outSet = (entryNode() : bottom) + ( stmtNode(n) : {} | <stmtNode(n), _> <- g); 
   solve(outSet) {
      list[Node] ns = [stmtNode(s) | s <- b.stmts];  
      for(n <- ns) {
          inSet[n]  = ({} | merge(opr, it, outSet[from]) | <from, to> <- g, to := n); 
  	      outSet[n] = genSet[n] + (inSet[n] - killSet[n]);      
      }
   }
   return <inSet, outSet>;
}

private AnalysisResult[&T] backward(MeetOperator opr, Abstraction[&T] genSet, Abstraction[&T] killSet, set[&T] bottom, MethodBody b) {
   g = forwardFlowGraph(b); 
   Abstraction[&T] outSet = ();
   Abstraction[&T] inSet = (exitNode() : bottom) + ( stmtNode(n) : {} | <_, stmtNode(n)> <- g); 
   solve(inSet) {
      list[Node] ns = [stmtNode(s) | s <- b.stmts];  
      for(n <- ns) {
          outSet[n]  = ({} | merge(opr, it, inSet[to]) | <from, to> <- g, from := n); 
  	      inSet[n] = genSet[n] + (outSet[n] - killSet[n]);      
      }
   }
   return <inSet, outSet>;
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
  