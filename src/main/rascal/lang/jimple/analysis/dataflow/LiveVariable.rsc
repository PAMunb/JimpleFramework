module lang::jimple::analysis::dataflow::LiveVariable

import lang::jimple::Syntax; 
import lang::jimple::analysis::FlowGraph; 

alias LocalVariable = str; 
alias Abstraction = set[LocalVariable]; 



public tuple[map[Node, Abstraction] inSet, map[Node, Abstraction] outSet] liveVariables(MethodBody b) {
   map[Statement, Abstraction] genSet  = (s : gen(s) | s <- b.stmts); 
   map[Statement, Abstraction] killSet = (s : kill(s) | s <- b.stmts); 
   
   g = forwardFlowGraph(b); 

   map[Node, Abstraction] inSet = (exitNode() : {} ) + (stmtNode(n) : {} | <_, stmtNode(n)> <- g);    
   map[Node, Abstraction] outSet = (); 
   
   solve(inSet) {
      for(s <- b.stmts) {
         outSet[stmtNode(s)] = ({} | it + inSet[to] | <from, to> <- g, from := stmtNode(s));
         inSet[stmtNode(s)] = outSet[stmtNode(s)] + (genSet[s] - killSet[s]); 
      }
   }
   return <inSet, inSet>; 
}

@synopsis{ the gen function of live variables. In this case, we generate 
 a reference to every variable in the statement. }  
public Abstraction gen(Statement s) = { v | /local(v) <- s} ;  

@synopsis{ the kill function of live variables. In this case, we kill 
 all variables in the LHS of an assignment statement. }  

public Abstraction  kill(assign(localVariable(v), _)) = { v }; 
public Abstraction kill(Statement _) = { }; 
