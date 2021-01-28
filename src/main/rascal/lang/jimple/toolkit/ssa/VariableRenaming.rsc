module lang::jimple::toolkit::ssa::VariableRenaming

import Set;
import Map;
import Relation;
import analysis::graphs::Graph;
import Node;
import List;
import Type;
import util::Math;
import lang::jimple::util::Stack;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;

public FlowGraph applyVariableRenaming(FlowGraph flowGraph, map[Node, set[Node]] blockTree) {
	map[Immediate, Stack[int]] S = (); 
	map[Immediate, int] C = ();

	map[Node, set[Node]] newBlockTree = replace(blockTree, entryNode(), S, C);
	
	FlowGraph newFlowGraph = {};
	
	for(fatherNode <- newBlockTree) {
		newFlowGraph = newFlowGraph + { <fatherNode, nodeChild> | nodeChild <- newBlockTree[fatherNode]};
	};

	return newFlowGraph;
}

public map[Node, set[Node]] replace(map[Node, set[Node]] blockTree, Node X, map[Immediate, Stack[int]] S, map[Immediate, int] C) {		
	map[Node, set[Node]] newBlockTree = blockTree;
	
	if(isOrdinaryAssignment(X)) {
		for(rightHandSideImmediate <- getRightHandSideImmediates(X)) {
			int variableVersion = rightHandSideImmediate in S ? peek(S[rightHandSideImmediate]) : 0;
			if(variableVersion == 0) S[rightHandSideImmediate] =  push(0, emptyStack()); // Initialize empty stack
			newBlockTree = replaceRightVariableVersion(blockTree, rightHandSideImmediate, X, variableVersion);
		};
		
		if(isLeftHandSideVariable(X)) {
			Variable V = getStmtVariable(X);
			Immediate localVariableImmediate = local(V[0]);
			int i = localVariableImmediate in C ? C[localVariableImmediate] : 0;
			newBlockTree = replaceLeftVariableVersion(blockTree, X, i);
			S[localVariableImmediate] = localVariableImmediate in S ? push(i, S[localVariableImmediate]) : push(i, emptyStack());  // Push new item or initialize empty stack
			C[localVariableImmediate] = i + 1;
		};
	}
	
	/*
	<_, destination> = X;
	list[tuple[Node, Node]] blockChildren = [<parent, child> | <parent, child> <- flowGraph, parent == destination];
	*/
	
	/*
	for(tuple[Node, Node] successorTuple <- blockChildren) {
		<leftHandSide, rightHandSide> = successorTuple;
		
		if(isPhiFunctionAssigment(rightHandSide)){
			sucessorNode = rightHandSide;
			stmtNode(phiFunctionVariables) = sucessorNode;
			phiFunction(phiFunctionVariable, variableVersionList) = phiFunctionVariables;
			variableName = phiFunctionVariable[0];
			Immediate localVariableImmediate = local(variableName);
			versionIndex = peek(S[localVariableImmediate])[0];
			
			str newVariableName = buildVersionName(variableName, versionIndex);
		
			list[Variable] newVariableList = variableVersionList + [localVariable(newVariableName)];
			tuple[Node, Node] renamedTuple = <leftHandSide, stmtNode(phiFunction(phiFunctionVariable, newVariableList))>;
			
			FlowGraph filteredFlowGraph = { graphRelation | graphRelation <- flowGraph, graphRelation != successorTuple };
			
			newFlowGraph = filteredFlowGraph + renamedTuple;
		};
		
		if(isPhiFunctionAssigment(leftHandSide)){
			sucessorNode = leftHandSide;
			stmtNode(phiFunctionVariables) = sucessorNode;
			phiFunction(phiFunctionVariable, variableVersionList) = phiFunctionVariables;
			variableName = phiFunctionVariable[0];
			Immediate localVariableImmediate = local(variableName);
			versionIndex = peek(S[localVariableImmediate])[0];
			
			str newVariableName = buildVersionName(variableName, versionIndex);
		
			list[Variable] newVariableList = variableVersionList + [localVariable(newVariableName)];
			tuple[Node, Node] renamedTuple = <stmtNode(phiFunction(phiFunctionVariable, newVariableList)), rightHandSide>;
			
			FlowGraph filteredFlowGraph = { graphRelation | graphRelation <- flowGraph, graphRelation != successorTuple };
			
			newFlowGraph = filteredFlowGraph + renamedTuple;
		};		
	};
	*/
	
	if((X == exitNode())) return newBlockTree;
	
	for(child <- blockTree[X]) {
		newBlockTree = replace(newBlockTree, child, S, C);
	};

	return newBlockTree;
}

public map[Node, set[Node]] replaceLeftVariableVersion(map[Node, set[Node]] blockTree, Node variableNode, int versionIndex) {
	Variable V = getStmtVariable(variableNode);
	String variableOriginalName = getVariableName(V);
	String newVersionName = buildVersionName(variableOriginalName, versionIndex);
	V[0] = newVersionName;
	
	stmtNode(assignStmt) = variableNode;
	assign(_, rightHandSide) = assignStmt;
	Node newAssignStmt = stmtNode(assign(V, rightHandSide));

	for(key <- blockTree) {
		if(variableNode in blockTree[key]) {
			blockTree[key] = blockTree[key] - variableNode + {newAssignStmt};
		};
	};
	
	blockTree[newAssignStmt] = blockTree[variableNode];
	
	return delete(blockTree, variableNode);
}

public map[Node, set[Node]] replaceRightVariableVersion(map[Node, set[Node]] blockTree, Immediate variableToRename, Node variableNode, int versionVersion) {
	String variableOriginalName = getImmediateName(variableToRename);
	String newVersionName = buildVersionName(variableOriginalName, versionVersion);
	
	stmtNode(assignStmt) = variableNode;
	assign(leftHandSide, _) = assignStmt;
	Node newAssignStmt = stmtNode(assign(leftHandSide, immediate(local(newVersionName))));
	
	for(key <- blockTree) {
		if(variableNode in blockTree[key]) {
			blockTree[key] = blockTree[key] - variableNode + {newAssignStmt};
		};
	};
	
	blockTree[newAssignStmt] = blockTree[variableNode];
	
	return delete(blockTree, variableNode);
}

public str buildVersionName(str variableOriginalName, int versionIndex) {
	return variableOriginalName + "_version-" + toString(versionIndex);
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

public bool ignoreNode(Node variableNode) {
	switch(variableNode) {
		case entryNode(): return true;
		case skipNode(): return true;
		case exitNode(): return true;
		default: return false;
	}
}

public bool isOrdinaryAssignment(Node variableNode) {
	if(ignoreNode(variableNode)) return false;

	stmtNode(statement) = variableNode;
	switch(statement) {
		case assign(_, _): return true; 
		default: return false;
	}
}

public bool isPhiFunctionAssigment(Node variableNode) {
	if(ignoreNode(variableNode)) return false;
	
	stmtNode(statement) = variableNode;
	switch(statement) {
		case phiFunction(_, _): return true; 
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