module lang::jimple::analysis::FlowGraph

import analysis::graphs::Graph;

import lang::jimple::Syntax;


alias FlowGraph = Graph[Node]; 

data Node = startNode()
          | endNode()
          | stmtNode(Statement s)
          ;

public FlowGraph empty() = {}; 

public FlowGraph forwardFlowGraph(MethodBody body) {
  map[Label, Statement] labels = mapLabels(body); 
  
  switch(body) {
    case signatureOnly() : return empty();
    case methodBody(_, stmts, _): return buildGraph(labels, stmts, startNode(), {});  
  }
  
  return empty();
}

private FlowGraph buildGraph(map[Label, Statement] labels, list[Statement] stmts, Node current, FlowGraph g) {
  FlowGraph res = empty();  
  switch(stmts) {
    case [] : res = <current, endNode()> + g;
    case [N, *NS] : res = buildGraph(labels, [*NS], stmtNode(N), (<current, stmtNode(N)> + g));
  }
  return res;
} 

private map[Label, Statement] mapLabels(MethodBody body) = ( l:(label(l)) | label(Label l) <- body );