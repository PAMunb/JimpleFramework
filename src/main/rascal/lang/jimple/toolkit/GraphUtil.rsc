module lang::jimple::toolkit::GraphUtil

import Relation;
import Type;
import Set;
import List;
import String;
import analysis::graphs::Graph;

import vis::Figure;
import vis::ParseTree;
import vis::Render;

@doc{
Check if the (exact) path exists in the graph. 
}
public bool existPath(Graph[&T] graph, list[&T] path) {	
	calls = toRel(path);
	for(call <- calls) {
		if( !(call in graph) ){
			return false;
		}
	}
	return true;	
}

public Figure toFigure(Graph[&T] g){
	procs = toList(carrier(g));  
	nodes = [box(text(nn), id(nn), size(50), fillColor("lightgreen")) | nn <- procs];
    return toFigure(g, nodes);
}
public Figure toFigure(Graph[&T] g, map[str,str] namesMap){
	procs = toList(carrier(g));  
	nodes = [box(text(namesMap[nn]), id(nn), size(50), fillColor("lightgreen")) | nn <- procs];
    return toFigure(g, nodes);
}
private Figure toFigure(Graph[&T] g, Figures nodes){
    edges = [edge(c.from,c.to) | c <- g];   
    return scrollable(graph(nodes, edges, hint("layered"), std(size(20)), std(gap(10))));
}

public str toDot(Graph[&T] g) {
	return toDot(g, "classes");
}
public str toDot(Graph[&T] g, map[str,str] namesMap) {
	return toDot(g, "classes", namesMap);
}
public str toDot(Graph[&T] g, str title) {
	return "digraph <title> {
         '  fontname = \"Bitstream Vera Sans\"
         '  fontsize = 8
         '  node [ fontname = \"Bitstream Vera Sans\" fontsize = 8 shape = \"record\" ]
         '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
         '
         '  <for (call <- g) {>                  
         '  \"<call.from>\" -\> \"<call.to>\" <}>
         '}";	
         //'  \"<call.from>\" -\> \"<call.to>\" [arrowhead=\"empty\"]<}>
}
public str toDot(Graph[&T] g, str title, map[str,str] namesMap) {
	return "digraph <title> {
         '  fontname = \"Bitstream Vera Sans\"
         '  fontsize = 8
         '  node [ fontname = \"Bitstream Vera Sans\" fontsize = 8 shape = \"record\" ]
         '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
         '
         '  <for (call <- g) {>                  
         '  \"<replaceAll(namesMap[call.from], "\"","\'")>\" -\> \"<replaceAll(namesMap[call.to], "\"","\'")>\" <}>
         '}";	
}

