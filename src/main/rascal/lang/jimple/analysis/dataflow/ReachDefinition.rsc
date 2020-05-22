module lang::jimple::analysis::dataflow::ReachDefinition

import lang::jimple::Syntax; 
import lang::jimple::analysis::FlowGraph; 

import IO; 

alias Definition = Statement; 
alias UseSet = set[Statement]; 
alias LocalVariable = str;
alias Abstraction = map[Node, set[Definition]];


public tuple[Abstraction inSet, Abstraction outSet] reachDefinition(MethodBody b, map[LocalVariable, set[Definition]] defs) {
   map[Statement, set[Definition]] genSet  = ( s : gen(s) | Statement s <- b.stmts); 
   map[Statement, set[Definition]] killSet = ( s : kill(s, defs) | Statement s <- b.stmts); 
  
   g = forwardFlowGraph(b);
   
   map[Node, set[Definition]] inSet = ();
   
   map[Node, set[Definition]] outSet = (entryNode() : {}) + ( stmtNode(n) : {} | <stmtNode(n), _> <- g); 
   
   bool fixedPoint = false; 
   while(! fixedPoint) {
      temp = outSet; 
      for(s <- b.stmts) {
          inSet[stmtNode(s)]  = ({} | it + outSet[from] | <from, to> <- g, to := stmtNode(s)); 
  	      outSet[stmtNode(s)] = genSet[s] + (inSet[stmtNode(s)] - killSet[s]);      
      }
      fixedPoint = temp == outSet; 
   }
   return <inSet, outSet>;
}

@synopsis{ the gen function of reachability analysis }  

set[Definition] gen(assign(localVariable(v), e)) = {assign(localVariable(v), e)}; 
set[Definition] gen(_) = {};    

@synopsis{ the kill function of reachability analysis }  

set[Definition] kill(assign(localVariable(v), _), map[LocalVariable, set[Definition]] defs) = defs[v]; 
set[Definition] kill(_, map[LocalVariable, set[Definition]] defs) = {}; 

 
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