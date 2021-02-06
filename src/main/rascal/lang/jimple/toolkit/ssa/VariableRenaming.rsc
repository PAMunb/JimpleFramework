module lang::jimple::toolkit::ssa::VariableRenaming

import Set;
import Map;
import Relation;
import analysis::graphs::Graph;
import Node;
import List;
import Type;
import String;
import util::Math;
import lang::jimple::util::Stack;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;

map[Immediate, Stack[int]] S = ();
map[Immediate, int] C = ();
set[Node] RENAMED_NODES = {};

public FlowGraph applyVariableRenaming(FlowGraph flowGraph, map[Node, list[Node]] blockTree) {
	map[Node, list[Node]] newBlockTree = replace(blockTree, entryNode());

	FlowGraph newFlowGraph = {};

	for(fatherNode <- newBlockTree) {
		newFlowGraph = newFlowGraph + { <fatherNode, nodeChild> | nodeChild <- newBlockTree[fatherNode]};
	};

	return newFlowGraph;
}

public map[Node, list[Node]] replace(map[Node, list[Node]] blockTree, Node X) {
	if((X == exitNode())) return blockTree;

	Node oldNode = X;

	if(!isRenamed(X) && !isOrdinaryAssignment(X) && !ignoreNode(X) && !isPhiFunctionAssigment(X)) {
		stmtNode(statement) = X;
		Node renamedStatement = stmtNode(replaceImmediateUse(statement));

		blockTree = replaceBlockTreeWithRenamedBlock(blockTree, X, renamedStatement);
		X = renamedStatement;
	};

	if(isOrdinaryAssignment(X)) {
		for(rightHandSideImmediate <- getRightHandSideImmediates(X)) {
			int variableVersion = rightHandSideImmediate in S ? peekIntValue(S[rightHandSideImmediate]) : 0;
			if(variableVersion == 0 && !(rightHandSideImmediate in S)) S[rightHandSideImmediate] = push(0, emptyStack()); // Initialize empty stack
			newAssignStmt = replaceRightVariableVersion(blockTree, rightHandSideImmediate, X, variableVersion);

			blockTree = replaceBlockTreeWithRenamedBlock(blockTree, X, newAssignStmt);
			X = newAssignStmt;
		};

		if(isLeftHandSideVariable(X)) {
			Variable V = getStmtVariable(X);
			Immediate localVariableImmediate = local(V[0]);
			int i = localVariableImmediate in C ? C[localVariableImmediate] : 0;
			newAssignStmt = replaceLeftVariableVersion(blockTree, X, i);

			blockTree = replaceBlockTreeWithRenamedBlock(blockTree, X, newAssignStmt);
			X = newAssignStmt;

			S[localVariableImmediate] = localVariableImmediate in S ? push(i, S[localVariableImmediate]) : push(i, emptyStack());  // Push new item or initialize empty stack
			C[localVariableImmediate] = i + 1;
		};
	}

	for(successor <- blockTree[X]) {
		int j = indexOf(blockTree[X], successor);

		if(isPhiFunctionAssigment(successor)){
			blockTree = replacePhiFunctionVersion(blockTree, successor);
		};
	};

	for(child <- blockTree[X]) {
		blockTree = replace(blockTree, child);
	};

	if(!ignoreNode(oldNode) && isVariable(oldNode)) popOldNode(oldNode);

	return blockTree;
}

public map[Node, list[Node]] replaceBlockTreeWithRenamedBlock(map[Node, list[Node]] blockTree, Node oldNode, Node newRenamedNode) {
	for(key <- blockTree) {
		if(oldNode in blockTree[key]) {
			blockTree[key] = blockTree[key] - [oldNode] + [newRenamedNode];
		};
	};

	blockTree[newRenamedNode] = blockTree[oldNode];
	blockTree = delete(blockTree, oldNode);
	RENAMED_NODES = RENAMED_NODES + {newRenamedNode};

	return blockTree;
}

public Statement replaceImmediateUse(Statement statement) {
	int i = 0;

	for(stmtArgument <- statement) {
		if(isSkipableStatement(stmtArgument)) {
			statement[i] = stmtArgument;
		} else {
			statement[i] = replaceImmediateUse(stmtArgument);
		};

		i = i + 1;
	};

	return statement;
}

public Expression replaceImmediateUse(Expression expression) {
	int i = 0;

	for(stmtArgument <- expression) {
		if(isSkipableStatement(stmtArgument)) {
			expression[i] = stmtArgument;
		} else {
			expression[i] = replaceImmediateUse(stmtArgument);
		};

		i = i + 1;
	};

	return expression;
}

public Immediate replaceImmediateUse(Immediate immediate) {
	local(variableName) = immediate;
	int versionIndex = peekIntValue(S[immediate]);
	str newVariableName = buildVersionName(variableName, versionIndex);

	return local(newVariableName);
}

public bool isRenamed(Node stmtNode) {
	return stmtNode in RENAMED_NODES;
}

public bool isSkipableStatement(stmtArgument) {
	switch(stmtArgument) {
		case str stringArgument: return true;
		case gotoStmt(_): return true;
		case iValue(_): return true;
		case caughtException(): return true;
	};

	return false;
}

public Stack[int] popOldNode(Node oldNode) {
	Variable V = getStmtVariable(oldNode);
	Immediate localVariableImmediate = local(V[0]);
	newStackTuple = pop(S[localVariableImmediate])[1];

	S[localVariableImmediate] = newStackTuple;

	return newStackTuple;
}

public map[Node, list[Node]] replacePhiFunctionVersion(map[Node, list[Node]] blockTree, Node variableNode) {
	stmtNode(phiFunctionVariables) = variableNode;
	phiFunction(phiFunctionVariable, variableVersionList) = phiFunctionVariables;
	variableName = phiFunctionVariable[0];
	Immediate localVariableImmediate = local(variableName);
	versionIndex = peek(S[localVariableImmediate])[0];

	str newVariableName = buildVersionName(variableName, versionIndex);

	list[Variable] newVariableList = variableVersionList + [localVariable(newVariableName)];
	Node renamedPhiFunction = stmtNode(phiFunction(phiFunctionVariable, newVariableList));

	for(key <- blockTree) {
		if(variableNode in blockTree[key]) {
			blockTree[key] = blockTree[key] - [variableNode] + [renamedPhiFunction];
		};
	};

	blockTree[renamedPhiFunction] = blockTree[variableNode];

	return delete(blockTree, variableNode);
}

public Node replaceLeftVariableVersion(map[Node, list[Node]] blockTree, Node variableNode, int versionIndex) {
	Variable V = getStmtVariable(variableNode);
	String variableOriginalName = getVariableName(V);
	String newVersionName = buildVersionName(variableOriginalName, versionIndex);
	V[0] = newVersionName;

	stmtNode(assignStmt) = variableNode;
	assign(_, rightHandSide) = assignStmt;
	Node newAssignStmt = stmtNode(assign(V, rightHandSide));

	return newAssignStmt;
}

public Node replaceRightVariableVersion(map[Node, list[Node]] blockTree, Immediate variableToRename, Node variableNode, int versionVersion) {
	String variableOriginalName = getImmediateName(variableToRename);
	String newVersionName = buildVersionName(variableOriginalName, versionVersion);

	stmtNode(assignStmt) = variableNode;
	assign(leftHandSide, _) = assignStmt;
	Node newAssignStmt = stmtNode(assign(leftHandSide, immediate(local(newVersionName))));

	return newAssignStmt;
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
		case stmtNode(gotoStmt(_)): return true;
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
