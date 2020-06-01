module lang::jimple::analysis::dataflow::LiveVariable

import lang::jimple::Syntax; 
extend lang::jimple::analysis::dataflow::Framework; 

private TransferFunctions[LocalVariable] tf 
  = transfer( set[LocalVariable] () { return bottomFunction(); }
  , set[LocalVariable] (Statement s) { return genFunction(s); } 
  , set[LocalVariable] (Statement s) { return killFunction(s); } 
  );

public DFA[LocalVariable] lv = dfa(Backward(), Union(), tf); 

private set[LocalVariable] bottomFunction() = {}; 

@synopsis{ the gen function of live variables. In this case, we generate 
 a reference to every variable in the statement. }  
public set[LocalVariable] genFunction(Statement s) = { v | /local(v) <- s} ;  

@synopsis{ the kill function of live variables. In this case, we kill 
 all variables in the LHS of an assignment statement. }  

public set[LocalVariable]  killFunction(assign(localVariable(v), _)) = { v }; 
public set[LocalVariable] killFunction(Statement _) = { }; 
