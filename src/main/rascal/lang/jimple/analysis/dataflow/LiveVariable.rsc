module lang::jimple::analysis::dataflow::LiveVariable

import lang::jimple::core::Syntax;
import lang::jimple::toolkit::FlowGraph; 
extend lang::jimple::analysis::dataflow::Framework; 

private TransferFunctions[LocalVariable] tf 
  = transfer( set[LocalVariable] () { return boundaryFunction(); }
  , set[LocalVariable] (Statement s) { return genFunction(s); } 
  , set[LocalVariable] (Statement s) { return killFunction(s); } 
  , set[LocalVariable] (MethodBody b) { return initFunction(b); }
  );

public DFA[LocalVariable] lv = dfa(Backward(), Union(), tf); 

private set[LocalVariable] boundaryFunction() = {}; 

@synopsis{ the init function... only returning the empty set for every statement }  
private set[LocalVariable] initFunction(MethodBody _) ={};

@synopsis{ the gen function of live variables. In this case, we generate 
 a reference to every variable in the statement. }  
public set[LocalVariable] genFunction(Statement s) = { v | /local(v) <- s} ;  

@synopsis{ the kill function of live variables. In this case, we kill 
 all variables in the LHS of an assignment statement. }  

public set[LocalVariable]  killFunction(assign(localVariable(v), _)) = { v }; 
public set[LocalVariable] killFunction(Statement _) = { }; 
