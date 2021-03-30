package lang.jimple.internal;

import java.util.List;

import lang.jimple.internal.generated.Immediate;
import lang.jimple.internal.generated.InvokeExp;
import lang.jimple.internal.generated.MethodSignature;

public interface InvokeExpressionFactory {

	public InvokeExp createInvokeExpression(String owner, MethodSignature signature, List<Immediate> args);

}
