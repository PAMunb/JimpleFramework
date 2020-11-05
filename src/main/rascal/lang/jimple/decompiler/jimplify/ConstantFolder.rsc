module lang::jimple::decompiler::jimplify::ConstantFolder


import lang::jimple::core::Syntax;
import Prelude;


private MethodBody processConstantFolding(MethodBody mb){
	top-down visit(mb) {
		case assign(localVariable(n), e) => assign(localVariable(n),evalExpression(e))
		when !expRefsVariable(e)
	}
	return mb;
}


private Expression evalExpression(Expression e){
	switch(e){
		case plus(iValue(intValue(lhs)),iValue(intValue(rhs))): return iValue(intValue(lhs+rhs));
		case minus(iValue(intValue(lhs)),iValue(intValue(rhs))): return iValue(intValue(lhs-rhs));
		case mult(iValue(intValue(lhs)),iValue(intValue(rhs))): return iValue(intValue(lhs*rhs));
		case div(iValue(intValue(lhs)),iValue(intValue(rhs))): return iValue(intValue(lhs/rhs));
	}
	return e;
}


private bool expRefsVariable(Expression e){
	top-down visit(e){
		case local(_): return true;
	}
	return false;
}