package lang.jimple.internal;

import lang.jimple.internal.generated.Expression;
import lang.jimple.internal.generated.Immediate;

public interface BinOperatorFactory {
	
	public Expression createExpression(Immediate lhs, Immediate rhs);
	
}
