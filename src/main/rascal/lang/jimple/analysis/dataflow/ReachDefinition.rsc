module lang::jimple::analysis::dataflow::ReachDefinition  

import lang::jimple::Syntax;
extend lang::jimple::analysis::dataflow::Framework; 

@synopsis{ the set of transfer functions for reach definition analysis }  
private TransferFunctions[Statement] tf 
   = transfer( set[Statement] () { return bottomFunction(); }
             , set[Definition] (Statement s) { return genFunction(s); } 
             , set[Definition] (Statement s) { return killFunction(s); } 
             ); 

@synopsis{ an instance of the dataflow framework for reach definitions }  
public DFA[Statement] rd = dfa(Forward(), Union(), tf);

@synopsis{ the bottom function... only returning the empty set }  
private set[Statement] bottomFunction() = {};

@synopsis{ the gen function for reach definition analysis }  
private set[Definition] genFunction(assign(localVariable(v), e)) = {assign(localVariable(v), e)}; 
private set[Definition] genFunction(_) = {};    

@synopsis{ the kill function for reach definition analysis }  
private set[Definition] killFunction(assign(localVariable(v), _)) = localDefs[v]; 
private set[Definition] killFunction(_) = {}; 