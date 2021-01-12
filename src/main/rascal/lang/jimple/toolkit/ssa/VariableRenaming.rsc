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
	map[Variable, Stack[int]] S = (); 
	map[Variable, int] C = ();

	for(Variable variable <- variableList) {
		for(<variableNode, childNode> <- blocksWithVariable(flowGraph, variable)) {
			if(isOrdinaryAssignment(variableNode)) {
				for(rightHandSideImmediate <- getRightHandSideImmediates(variableNode)) {
					// replaceVariableVersion(newFlowGraph, peek(S[rhsVariable]));
				};
				
				if(isLeftHandSideVariable(variableNode)) {
					Variable V = getStmtVariable(variableNode);
					int i = V in C ? C[V] : 0;
					S[V] = V in S ? push(i, S[V]) : push(i, emptyStack());
					replaceVariableVersion(newFlowGraph, variableNode, childNode, S);
					C[V] = i + 1;
				};
			};
		};
	};

	return flowGraph;
}

public FlowGraph replaceVariableVersion(FlowGraph flowGraph, Node variableNode, Node childNode, map[Variable, Stack[int]] S) {
	FlowGraph filteredFlowGraph = { <origin, destination> | <origin, destination> <- flowGraph, (origin != variableNode) && (destination != childNode) };

	// Replace use of V by use of Vi where i = Top(S(V))	
	Variable V = getStmtVariable(variableNode);
	String variableOriginalName = getVariableName(V);
	int versionIndex = peekIntValue(S[V]);
	String newVersionName = variableOriginalName + "_version-" + toString(versionIndex);
	V[0] = newVersionName;
	
	stmtNode(assignStmt) = variableNode;
	assign(_, rightHandSide) = assignStmt;
	newAssignStmt = assign(V, rightHandSide);
	variableNode[0] = newAssignStmt;

	return filteredFlowGraph + <variableNode, childNode>;;
}

public String getVariableName(Variable variable) {
	switch(variable[0]) {
		case String variableName: return variableName;
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
	Immediate variablesCount = size([ immediate | immediate <- immediates, getVariableImmediateName(immediate) != ""]);

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