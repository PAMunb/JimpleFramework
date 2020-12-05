module util::RunSVFA

import IO;
import Map;
import Relation;
import Type;
import Set;
import List;
import util::Math;
import analysis::graphs::Graph;

import lang::jimple::core::Syntax;
import lang::jimple::core::Context;
import lang::jimple::analysis::svfa::SparseValueFlowAnalysis;
import lang::jimple::toolkit::ValueFlowGraph;
import lang::jimple::util::Converters;
import lang::jimple::toolkit::PrettyPrinter;


import lang::jimple::toolkit::FlowGraph;
import lang::jimple::analysis::dataflow::ReachDefinition;
import lang::jimple::util::JPrettyPrinter;


private tuple[list[loc] classPath, list[str] entryPoints, ValueFlowNodeType (Statement) analyze] runBasic11() {
	//TODO compile class before using: mvn test -DskipTests
	files = [|project://JimpleFramework/target/test-classes/samples/svfa/basic/Basic11.class|];
    es = ["samples.svfa.basic.Basic11.main(java.lang.String[])"];
    return <files, es, simpleSourceSinkAnalysis>;
}

private tuple[list[loc] classPath, list[str] entryPoints, ValueFlowNodeType (Statement) analyze] runArraySample() {
	files = [|project://JimpleFramework/target/test-classes/samples/svfa/ArraySample.class|];
    es = ["samples.svfa.ArraySample.main(java.lang.String[])"];
    return <files, es, simpleSourceSinkAnalysis>;
}

private tuple[list[loc] classPath, list[str] entryPoints, ValueFlowNodeType (Statement) analyze] runIfElseScenario() {
	files = [|project://JimpleFramework/target/test-classes/samples/svfa/IfElseScenario.class|];
    es = ["samples.svfa.IfElseScenario.main(java.lang.String[])"];
    return <files, es, simpleSourceSinkAnalysis>;
}

// method name based analysis
ValueFlowNodeType simpleSourceSinkAnalysis(Statement stmt) {
	return simpleSourceSinkAnalysis(stmt);	
}
// Statements
ValueFlowNodeType simpleSourceSinkAnalysis(assign(_, Expression expression)) = simpleSourceSinkAnalysis(expression);
ValueFlowNodeType simpleSourceSinkAnalysis(invokeStmt(InvokeExp invokeExpression)) = simpleSourceSinkAnalysis(invokeExpression);
ValueFlowNodeType simpleSourceSinkAnalysis(Statement stmt) = simpleNode();
// Expressions
ValueFlowNodeType simpleSourceSinkAnalysis(InvokeExp invokeExpression) = simpleSourceSinkAnalysis(invokeExpression);
ValueFlowNodeType simpleSourceSinkAnalysis(Expression _) = simpleNode();
// InvokeExpressions
ValueFlowNodeType simpleSourceSinkAnalysis(specialInvoke(Name local, methodSignature(_, _, Name mn, _), _)) = simpleSourceSinkAnalysis(mn);
ValueFlowNodeType simpleSourceSinkAnalysis(virtualInvoke(Name local, methodSignature(_, _, Name mn, _), _)) = simpleSourceSinkAnalysis(mn);
ValueFlowNodeType simpleSourceSinkAnalysis(interfaceInvoke(Name local, methodSignature(_, _, Name mn, _), _)) = simpleSourceSinkAnalysis(mn);
ValueFlowNodeType simpleSourceSinkAnalysis(staticMethodInvoke(methodSignature(_, _, Name mn, _), _)) = simpleSourceSinkAnalysis(mn);
ValueFlowNodeType simpleSourceSinkAnalysis(dynamicInvoke(MethodSignature bsmSig, _, MethodSignature sig, _)) = simpleNode();
// define node type
ValueFlowNodeType simpleSourceSinkAnalysis(Name methodName) {
	switch(methodName){
		case "source": return sourceNode();
		case "sink": return sinkNode();
		default: return simpleNode();
	}
}



public void main(){
	tuple[list[loc] cp, list[str] e, ValueFlowNodeType (Statement) analyze] t = runBasic11();
	//tuple[list[loc] cp, list[str] e, ValueFlowNodeType (Statement) analyze] t = runArraySample();
	//tuple[list[loc] cp, list[str] e, ValueFlowNodeType (Statement) analyze] t = runIfElseScenario();
    
    println("iniciando ....");
    
    SVFAModel model = execute(t.cp, t.e, Analysis(generateSVFGraph([], t.analyze)),true);
    
    println("model=<model>");
    
    
    //ExecutionContext ctx = createExecutionContext(files,es,true);	    
    //show(ctx);    
    //for(m <- ctx.mt){
    //	println(m);
    //}    
}




private void show(ExecutionContext ctx){			
	top-down visit(ctx.ct) {	 	
  		case ClassOrInterfaceDeclaration c:{
  			show(c);
  		}  			  		
  	}    
}

private void show(classDecl(TObject(name), _, _, _, _, list[Method] methods)){
	println("CLASS: <name>");
	show(methods);	
}

private void show(interfaceDecl(TObject(name), _, _, _, list[Method] methods)){
	println("INTERFACE: <name>");
	show(methods);	
}

private void show(list[Method] methods){
	for(Method m <- methods){
		show(m);
	}
}

private void show(method(_, _, Name name, list[Type] args, _, _)){
	println("\t - <name>(<intercalate(",", args)>)");
}







//TESTE ISOLADO ... remover antes do merge com master
private MethodBody getMethodBody(){
	Statement s1 = identity("i1","@parameter0",TArray(TObject("java.lang.String")));
	Statement s2 = assign(localVariable("s1"),invokeExp(staticMethodInvoke(methodSignature("samples.svfa.basic.Basic11",TObject("java.lang.String"),"source",[]),[])));
	Statement s3 = assign(localVariable("s2"),immediate(iValue(stringValue("abc"))));
	Statement s4 = assign(localVariable("s3"),invokeExp(virtualInvoke("s1",methodSignature("java.lang.String",TObject("java.lang.String"),"toUpperCase",[]),[])));
	Statement s5 = assign(localVariable("s4"),invokeExp(virtualInvoke("s2",methodSignature("java.lang.String",TObject("java.lang.String"),"toUpperCase",[]),[])));
	Statement s6 = invokeStmt(staticMethodInvoke(methodSignature("samples.svfa.basic.Basic11",TVoid(),"sink",[TObject("java.lang.String")]),[local("s3")]));
	Statement s7 = assign(localVariable("tmp"),newInstance(TUnknown()));
	Statement s8 = invokeStmt(specialInvoke("tmp",methodSignature("java.lang.StringBuilder",TVoid(),"\<init\>",[]),[]));
	Statement s9 = assign(localVariable("tmp"),invokeExp(virtualInvoke("tmp",methodSignature("java.lang.StringBuilder",TObject("java.lang.StringBuilder"),"append",[TObject("java.lang.String")]),[local("s1")])));
	Statement s10 = assign(localVariable("tmp"),invokeExp(virtualInvoke("tmp",methodSignature("java.lang.StringBuilder",TObject("java.lang.StringBuilder"),"append",[TObject("java.lang.String")]),[iValue(stringValue(";"))])));
	Statement s11 = assign(localVariable("tmp"),invokeExp(virtualInvoke("tmp",methodSignature("java.lang.StringBuilder",TObject("java.lang.String"),"toString",[]),[])));
	Statement s12 = invokeStmt(staticMethodInvoke(methodSignature("samples.svfa.basic.Basic11",TVoid(),"sink",[TObject("java.lang.String")]),[local("tmp")]));
	Statement s13 = invokeStmt(staticMethodInvoke(methodSignature("samples.svfa.basic.Basic11",TVoid(),"sink",[TObject("java.lang.String")]),[local("s4")]));
	Statement s14 = returnEmptyStmt();	
	
	list[Statement] ss = [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14]; 
	  
	MethodBody b = methodBody([], ss, []);
	
	return b;
}

