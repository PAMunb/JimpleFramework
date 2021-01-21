module lang::jimple::toolkit::ssa::VariableRenaming

import Set;
import Relation;
import analysis::graphs::Graph;
import Node;
import List;
import Type;
import util::Math;
import lang::jimple::util::Stack;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;

public FlowGraph applyVariableRenaming(FlowGraph flowGraph, map[&T, set[&T]] dominanceTree) {
	FlowGraph newFlowGraph = { graphNode | graphNode <- flowGraph };
	variableList = { getStmtVariable(graphNode) | <graphNode, _> <- flowGraph, isVariable(graphNode) };
	map[Immediate, Stack[int]] S = (); 
	map[Immediate, int] C = ();

	for(Variable variable <- variableList) {
		for(<variableNode, childNode> <- blocksWithVariable(flowGraph, variable)) {
			if(isOrdinaryAssignment(variableNode)) {
				for(rightHandSideImmediate <- getRightHandSideImmediates(variableNode)) {
					int variableVersion = rightHandSideImmediate in S ? peek(S[rightHandSideImmediate]) : 0;
					if(variableVersion == 0) S[rightHandSideImmediate] =  push(0, emptyStack()); // Initialize empty stack
					newFlowGraph = replaceRightVariableVersion(newFlowGraph, rightHandSideImmediate, variableNode, variableVersion);
				};
				
				if(isLeftHandSideVariable(variableNode)) {
					// Ajuste aqui, tem que ser dos dois lados do no o rename, pq tem a ligacao, ex: <a, b> <b, c>, se tiver o rename em b, tem que ser nos dois nós
					Variable V = getStmtVariable(variableNode);
					Immediate localVariable = local(V[0]);
					int i = localVariable in C ? C[localVariable] : 0;
					newFlowGraph = replaceLeftVariableVersion(newFlowGraph, variableNode, childNode, i);
					S[localVariable] = localVariable in S ? push(i, S[localVariable]) : push(i, emptyStack());  // Push new item or initialize empty stack
					C[localVariable] = i + 1;
				};
			};
		};
	};

	return newFlowGraph;
}

public FlowGraph replaceLeftVariableVersion(FlowGraph flowGraph, Node variableNode, Node childNode, int versionIndex) {
	FlowGraph filteredFlowGraph = { <origin, destination> | <origin, destination> <- flowGraph, (origin != variableNode) && (destination != variableNode) };

	Variable V = getStmtVariable(variableNode);
	String variableOriginalName = getVariableName(V);
	String newVersionName = variableOriginalName + "_version-" + toString(versionIndex);
	V[0] = newVersionName;
	
	stmtNode(assignStmt) = variableNode;
	assign(_, rightHandSide) = assignStmt;
	Node newAssingStmt = stmtNode(assign(V, rightHandSide));

	FlowGraph newPredecessorNodes = { <origin, newAssingStmt> | <origin, destination> <- flowGraph, (destination == variableNode) };
	FlowGraph newDestinations = { <newAssingStmt, destination> | <origin, destination> <- flowGraph, (origin == variableNode) };

	return filteredFlowGraph + newPredecessorNodes + newDestinations;
}

public FlowGraph replaceRightVariableVersion(FlowGraph flowGraph, Immediate variableToRename, Node variableNode, int versionVersion) {
	FlowGraph filteredFlowGraph = { <origin, destination> | <origin, destination> <- flowGraph, (origin != variableNode) && (destination != variableNode) };

	String variableOriginalName = getImmediateName(variableToRename);
	String newVersionName = variableOriginalName + "_version-" + toString(versionVersion);
	
	stmtNode(assignStmt) = variableNode;
	assign(leftHandSide, _) = assignStmt;
	Node newAssignStmt = stmtNode(assign(leftHandSide, immediate(local(newVersionName))));

	FlowGraph newPredecessorNodes = { <origin, newAssignStmt> | <origin, destination> <- flowGraph, (destination == variableNode) };
	FlowGraph newDestinations = { <newAssignStmt, destination> | <origin, destination> <- flowGraph, (origin == variableNode) };
		
	return filteredFlowGraph + newPredecessorNodes + newDestinations;
}

public String getVariableName(Variable variable) {
	switch(variable[0]) {
		case String variableName: return variableName;
	}
}

public String getImmediateName(Immediate immediate) {
	switch(immediate[0]) {
		case String immediateName: return immediateName;
	}
}

public bool isLeftHandSideVariable(Node variableNode) {
	stmtNode(assignStatement) = variableNode;
	assign(leftHandSide, _) = assignStatement;
	typeOfVariableArg = typeOf(leftHandSide);

	return size(typeOfVariableArg[..]) != 0 && typeOfVariableArg.name == "Variable";
}

public list[Immediate] getRightHandSideImmediates(Node variableNode) {
	stmtNode(assignStatement) = variableNode;
	assign(_, rightHandSide) = assignStatement;
	typeOfVariableArg = typeOf(rightHandSide);

	if(typeOfVariableArg.name != "Expression") return [];

	list[Immediate] immediates = getExpressionImmediates(rightHandSide);
	int variablesCount = size([ immediate | immediate <- immediates, getVariableImmediateName(immediate) != ""]);

	if(variablesCount != 0) return immediates;

	return [];
}

public bool isOrdinaryAssignment(variableNode) {
	stmtNode(assignStatement) = variableNode;
	
	switch(assignStatement) {
		case assign(_, _): return true; 
		default: return false;
	}
}

public Variable getStmtVariable(Node graphNode) {
	stmtNode(assignStatement) = graphNode;
	temp = typeOf(assignStatement);
	variableArg = assignStatement[0];
	temp2 = typeOf(variableArg);
	
	switch(variableArg) {
		case Variable variable: return variable;
	}
}

public lrel[Node, Node] blocksWithVariable(FlowGraph flowGraph, Variable variable) {
	return [<fatherNode, childStmt> | <fatherNode, childStmt> <- flowGraph, isSameVariable(fatherNode, variable)];;
}

public bool isVariable(Node graphNode) {
	if (size(graphNode[..]) == 0) return false;
	
	stmtNode(assignStatement) = graphNode;
	variableArg = assignStatement[0];
	typeOfVariableArg = typeOf(variableArg);
	
	if (size(typeOfVariableArg[..]) == 0) return false;
	
	return typeOfVariableArg.name == "Variable";
}

public bool isSameVariable(Node graphNode, Variable variable) {
	if (size(graphNode[..]) == 0) return false;
	
	stmtNode(assignStatement) = graphNode;
	variableArg = assignStatement[0];
	typeOfVariableArg = typeOf(variableArg);
	
	if (size(typeOfVariableArg[..]) == 0) return false;
	
	return variableArg == variable;
}

public String getVariableImmediateName(Immediate immediate) {
	switch(immediate) {
		case local(String localName): return localName;
		default: return "";
	}
}

public list[Immediate] getExpressionImmediates(Expression expression) {
	switch(expression) {
	  case newInstance(Type instanceType): return [];
	  case newArray(Type baseType, list[ArrayDescriptor] dims): return [];
	  case cast(Type toType, Immediate immeadiate): return [];
	  case instanceOf(Type baseType, Immediate immediate): return [immediate];
	  case invokeExp(InvokeExp expression): return [];
	  case arraySubscript(Name name, Immediate immediate): return [immediate];
	  case stringSubscript(String string, Immediate immediate): return [immediate];
	  case localFieldRef(Name local, Name className, Type fieldType, Name fieldName): return [];
	  case fieldRef(Name className, Type fieldType, Name fieldName): return [];
	  case and(Immediate lhs, Immediate rhs): return [lhs, rhs];
	  case or(Immediate lhs, Immediate rhs): return [lhs, rhs];
	  case xor(Immediate lhs, Immediate rhs): return [lhs, rhs];
	  case reminder(Immediate lhs, Immediate rhs): return [lhs, rhs];
	  case isNull(Immediate immediate): return [immediate];
	  case isNotNull(Immediate immediate): return [immediate];
	  case cmp(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case cmpg(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case cmpl(Immediate lhs, Immediate rhs): return [lhs, rhs];
	  case cmpeq(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case cmpne(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case cmpgt(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case cmpge(Immediate lhs, Immediate rhs): return [lhs, rhs];
	  case cmplt(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case cmple(Immediate lhs, Immediate rhs): return [lhs, rhs];
	  case shl(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case shr(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case ushr(Immediate lhs, Immediate rhs): return [lhs, rhs];
	  case plus(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case minus(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case mult(Immediate lhs, Immediate rhs): return [lhs, rhs]; 
	  case div(Immediate lhs, Immediate rhs): return [lhs, rhs];
	  case lengthOf(Immediate immediate): return [immediate];
	  case neg(Immediate immediate): return [immediate]; 
	  case immediate(Immediate immediate): return [immediate];
	  default: return [];
	}
}