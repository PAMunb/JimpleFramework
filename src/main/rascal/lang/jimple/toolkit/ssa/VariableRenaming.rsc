module lang::jimple::toolkit::ssa::VariableRenaming

import Set;
import Map;
import Relation;
import Node;
import List;
import Type;
import String;
import util::Math;

import analysis::graphs::Graph;

import lang::jimple::util::Stack;
import lang::jimple::toolkit::FlowGraph;
import lang::jimple::core::Syntax;
import lang::jimple::toolkit::ssa::DominanceTree;


map[str, Stack[int]] S = ();
map[str, int] C = ();
set[Node] REPLACED_NODES = {};
map[Node, Node] NODE_REPLACMENT = ();

map[Node, list[Node]] IDOM_TREE = ();
map[Node, list[Node]] ADJACENCIES_MATRIX = ();

public FlowGraph applyVariableRenaming(FlowGraph flowGraph) {
	ADJACENCIES_MATRIX = createAdjacenciesMatrix(flowGraph);
	IDOM_TREE = createIdomTree( createDominanceTree(flowGraph));	
	
	map[Node, list[Node]] newBlockTree = replace(entryNode());

	FlowGraph newFlowGraph = {};

	for(fatherNode <- newBlockTree) {
		newFlowGraph = newFlowGraph + { <fatherNode, nodeChild> | nodeChild <- ADJACENCIES_MATRIX[fatherNode]};
	};

	return newFlowGraph;
}

public map[Node, list[Node]] replace(Node X) {
	if((X == exitNode())) return ADJACENCIES_MATRIX;

	Node oldNode = X;

	if(!isReplaced(X) && !isOrdinaryAssignment(X) && !ignoreNode(X) && !isPhiFunctionAssigment(X)) {
		stmtNode(statement) = X;
		Node renamedStatement = stmtNode(replaceImmediateUse(statement));

		renameNodeOcurrecies(X, renamedStatement);
		
		X = renamedStatement;
	};

	if(isOrdinaryAssignment(X) && !isRenamed(X)) {
		list[Immediate] nodeImmediates = getRightHandSideImmediates(X);
		for(rightHandSideImmediate <- nodeImmediates) {
			int variableVersion = getVariableVersionStacked(rightHandSideImmediate);
			stackVariableVersion(rightHandSideImmediate, variableVersion);

			newAssignStmt = replaceRightVariableVersion(blockTree, rightHandSideImmediate, X, variableVersion);

			renameNodeOcurrecies(X, newAssignStmt);
			
			X = newAssignStmt;
		};

		if(isLeftHandSideVariable(X)) {
			Variable V = getStmtVariable(X);
			Immediate localVariableImmediate = local(V[0]);

			int i = returnAssignmentQuantity(localVariableImmediate);
			newAssignStmt = replaceLeftVariableVersion(ADJACENCIES_MATRIX, X, i);

			renameNodeOcurrecies(X, newAssignStmt);
			
			X = newAssignStmt;

			stackVariableVersion(localVariableImmediate, i);
			iterateAssignmentQuantity(localVariableImmediate);
		};
	}

	for(successor <- ADJACENCIES_MATRIX[X]) {
		// int j = indexOf(blockTree[X], successor);

		if(isPhiFunctionAssigment(successor)){
			oldPhiFunctionStmt = successor;
			newPhiFunctionStmt = replacePhiFunctionVersion(ADJACENCIES_MATRIX, successor);
			
			renameNodeOcurrecies(oldPhiFunctionStmt, newPhiFunctionStmt);
		};
	};

	for(child <- IDOM_TREE[X]) {
		nodeToRename = NODE_REPLACMENT[child]? ? NODE_REPLACMENT[child] : child;
		replace(nodeToRename);
	};

	if(!ignoreNode(oldNode) && isVariable(oldNode) && !isRenamed(X)) popOldNode(oldNode);

	return ADJACENCIES_MATRIX;
}

public void renameNodeOcurrecies(Node oldStmt, Node newStmt) {
	ADJACENCIES_MATRIX = replaceNodeOcurrenciesInTrees(ADJACENCIES_MATRIX, oldStmt, newStmt);
	IDOM_TREE = replaceNodeOcurrenciesInTrees(IDOM_TREE, oldStmt, newStmt);
	NODE_REPLACMENT[oldStmt] = newStmt;
}

public map[Node, list[Node]] replaceNodeOcurrenciesInTrees(map[Node, list[Node]] blockTree, Node oldNode, Node newRenamedNode) {
	for(key <- blockTree) {
		if(oldNode in blockTree[key]) {
			blockTree[key] = blockTree[key] - [oldNode] + [newRenamedNode];
		};
	};

	blockTree[newRenamedNode] = blockTree[oldNode];
	blockTree = delete(blockTree, oldNode);
	REPLACED_NODES = REPLACED_NODES + {newRenamedNode};

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
	variableName = returnLocalImmediateName(immediate);

	int versionIndex = getVariableVersionStacked(immediate);
	str newVariableName = buildVersionName(variableName, versionIndex);

	return local(newVariableName);
}

public bool isReplaced(Node stmtNode) {
	return stmtNode in REPLACED_NODES;
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

	str name = returnLocalImmediateName(localVariableImmediate);
	newStackTuple = pop(S[name])[1];
	S[name] = newStackTuple;

	return newStackTuple;
}

public Node replacePhiFunctionVersion(map[Node, list[Node]] blockTree, Node variableNode) {
	stmtNode(assignStatement) = variableNode;
	assign(assignVariable, assignPhiFunction) = assignStatement;
	phiFunction(phiFunctionVariable, variableVersionList) = assignPhiFunction;
	variableName = phiFunctionVariable[0];
	Immediate localVariableImmediate = local(variableName);
	versionIndex = getVariableVersionStacked(localVariableImmediate);

	str newVariableName = buildVersionName(variableName, versionIndex);

	list[Variable] newVariableList = variableVersionList + [localVariable(newVariableName)];
	Node renamedPhiFunction = stmtNode(assign(assignVariable, phiFunction(phiFunctionVariable, newVariableList)));

	return renamedPhiFunction;
}

public Node replaceLeftVariableVersion(map[Node, list[Node]] blockTree, Node variableNode, int versionIndex) {
	Variable V = getStmtVariable(variableNode);
	String variableOriginalName = getVariableName(V);
	String newVersionName = buildVersionName(variableOriginalName, versionIndex);
	V[0] = newVersionName;

	rightHandSide = returnRightHandSideExpression(variableNode);
	Node newAssignStmt = stmtNode(assign(V, rightHandSide));

	return newAssignStmt;
}

public Node replaceRightVariableVersion(map[Node, list[Node]] blockTree, Immediate variableToRename, Node variableNode, int versionVersion) {
	String variableOriginalName = getImmediateName(variableToRename);
	String newVersionName = buildVersionName(variableOriginalName, versionVersion);

	leftHandSide = returnLeftHandSideVariable(variableNode);
	Node newAssignStmt = stmtNode(assign(leftHandSide, immediate(local(newVersionName))));

	return newAssignStmt;
}

public bool isRenamed(Node assignNode) {
	if(ignoreNode(assignNode)) return false;

	stmtNode(assignStmt) = assignNode;

	switch(assignNode) {
		case stmtNode(assign(localVariable(name), _)) : return contains(name, "version");
	}
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
	leftHandSide = returnLeftHandSideVariable(variableNode);
	typeOfVariableArg = typeOf(leftHandSide);

	return size(typeOfVariableArg[..]) != 0 && typeOfVariableArg.name == "Variable";
}

public list[Immediate] getRightHandSideImmediates(Node variableNode) {
	rightHandSide = returnRightHandSideExpression(variableNode);
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
		case stmtNode(identity(_, _, _)):  return true;
		case stmtNode(invokeStmt(_)): return true;
		case stmtNode(returnEmptyStmt()): return true;
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

	stmtNode(assignStatement) = variableNode;
	if(size(assignStatement[..]) != 2) return false;

	possiblePhiFunction = assignStatement[1];
	switch(possiblePhiFunction) {
		case phiFunction(_, _): return true;
		default: return false;
	}
}

public Variable getStmtVariable(Node graphNode) {
	stmtNode(assignStatement) = graphNode;
	variableArg = assignStatement[0];

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
	  case cast(Type toType, local(name)): return [];
	  case instanceOf(Type baseType, local(name)): return [local(name)];
	  case invokeExp(InvokeExp expression): return [];
	  case arraySubscript(Name name, local(name)): return [local(name)];
	  case stringSubscript(String string, local(name)): return [local(name)];
	  case localFieldRef(Name local, Name className, Type fieldType, Name fieldName): return [];
	  case fieldRef(Name className, Type fieldType, Name fieldName): return [];
	  case and(local(lhs_name), local(rhs_name)): return [lhs_name, rhs_name];
	  case or(local(lhs_name), local(rhs_name)): return [lhs_name, rhs_name];
	  case xor(local(lhs_name), local(rhs_name)): return [lhs_name, rhs_name];
	  case reminder(local(lhs_name), local(rhs_name)): return [lhs_name, rhs_name];
	  case isNull(local(name)): return [local(name)];
	  case isNotNull(local(name)): return [local(name)];
	  case cmp(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case cmpg(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case cmpl(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case cmpeq(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case cmpne(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case cmpgt(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case cmpge(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case cmplt(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case cmple(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case shl(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case shr(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case ushr(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case plus(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case minus(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case mult(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case div(local(lhs_name), local(rhs_name)): return [local(lhs_name), local(rhs_name)];
	  case lengthOf(local(name)): return [local(name)];
	  case neg(local(name)): return [local(name)];
	  case immediate(local(name)): return [local(name)];
	  default: return [];
	}
}

public Variable returnLeftHandSideVariable(Node stmtNode) {
	switch(stmtNode) {
		case stmtNode(assign(leftHandSide, _)): return leftHandSide;
	}
}

public Expression returnRightHandSideExpression(Node stmtNode) {
	switch(stmtNode) {
		case stmtNode(assign(_, rightHandSide)): return rightHandSide;
	}
}

public str returnLocalImmediateName(Immediate immediate) {
	switch(immediate) {
		case local(name): return name;
	}
}

public int returnAssignmentQuantity(Immediate immediate) {
	str name = returnLocalImmediateName(immediate);

	if(name in C) return C[name];

	C[name] = 0;
	return C[name];
}

public int iterateAssignmentQuantity(Immediate immediate) {
	str name = returnLocalImmediateName(immediate);

	C[name] = C[name] + 1;

	return C[name];
}

public str stackVariableVersion(Immediate immediate, int renameIndex) {
	str name = returnLocalImmediateName(immediate);

	S[name] = name in S ? push(renameIndex, S[name]) : push(0, emptyStack());

	return name;
}

public int getVariableVersionStacked(Immediate immediate) {
	str name = returnLocalImmediateName(immediate);

	if(name in S) return peekIntValue(S[name]);

	S[name] = push(0, emptyStack());
	return 0;
}
