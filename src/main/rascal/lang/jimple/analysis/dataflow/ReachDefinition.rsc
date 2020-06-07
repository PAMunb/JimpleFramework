module lang::jimple::analysis::dataflow::ReachDefinition  

import lang::jimple::Syntax;
import lang::jimple::analysis::FlowGraph;
extend lang::jimple::analysis::dataflow::Framework; 

@synopsis{ the set of transfer functions for reach definition analysis }  
private TransferFunctions[Statement] tf 
   = transfer( set[Statement] () { return boundaryFunction(); }
             , set[Statement] (Statement s) { return genFunction(s); } 
             , set[Statement] (Statement s) { return killFunction(s); } 
             , set[Statement] (MethodBody b) { return initFunction(b); }
             ); 

@synopsis{ an instance of the dataflow framework for reach definitions }  
public DFA[Statement] rd = dfa(Forward(), Union(), tf);

@synopsis{ the init function... only returning the empty set for every statement }  
private set[Statement] initFunction(MethodBody _) = {};


@synopsis{ the bottom function... only returning the empty set }  
private set[Statement] boundaryFunction() = {};

@synopsis{ the gen function for reach definition analysis }  
private set[Statement] genFunction(assign(localVariable(v), e)) = {assign(localVariable(v), e)}; 
private set[Statement] genFunction(_) = {};    

@synopsis{ the kill function for reach definition analysis }  
private set[Statement] killFunction(assign(localVariable(v), _)) = localDefs[v]; 
private set[Statement] killFunction(_) = {};