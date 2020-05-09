package lang.jimple.internal;

import lang.jimple.internal.generated.Expression;
import lang.jimple.internal.generated.Immediate;

public interface BinExpressionFactory {
	
	public Expression createExpression(Immediate lhs, Immediate rhs);
	
}
