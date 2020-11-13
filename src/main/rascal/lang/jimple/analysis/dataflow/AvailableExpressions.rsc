module lang::jimple::analysis::dataflow::AvailableExpressions

import lang::jimple::core::Syntax; 
import lang::jimple::toolkit::FlowGraph;
extend lang::jimple::analysis::dataflow::Framework; 

import List;

@synopsis{ the set of transfer functions for available expression analysis }  
private TransferFunctions[Expression] tf 
   = transfer( set[Expression] () { return boundaryFunction(); }
             , set[Expression] (Statement s) { return genFunction(s); } 
             , set[Expression] (Statement s) { return killFunction(s); } 
             , set[Expression] (MethodBody b) { return initFunction(b); }
             );

public DFA[Expression] ae = dfa(Forward(), Intersection(), tf); 

private set[Expression] boundaryFunction() = {}; 

private set[Expression] initFunction(MethodBody b) = allVariables 
  when allVariables := { e | /Expression e <- b, binArithmeticExpression(e) }; 

private set[Expression] genFunction(Statement s) 
   = { e | /Expression e <- s, binArithmeticExpression(e), size(localReferences(e)) > 0 };

private set[Expression] killFunction(assign(localVariable(v), e)) 
   = {e1 | Expression e1 <- binExpressions, useVariable(e1, v)}; 

private set[Expression] killFunction(_) = {}; 

private bool useVariable(Expression e, str v) = local(v) in localReferences(e); 

private list[Immediate] localReferences(Expression e) = [local(v) | /local(v) <- e];
