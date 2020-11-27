package lang.jimple.internal;

import lang.jimple.internal.generated.Immediate;
import lang.jimple.internal.generated.LocalVariableDeclaration;
import lang.jimple.internal.generated.Type;
import lang.jimple.internal.generated.Value;
import lang.jimple.util.Pair;

public class Operand {
	
	public Type type; 
	public Immediate immediate; 
	
	Operand(Type type, Immediate immediate) {
		this.type = type;
		this.immediate = immediate;
	}

	Operand(LocalVariableDeclaration localDeclaration) {
		this.type = localDeclaration.varType;
		this.immediate = Immediate.local(localDeclaration.local);
	}

	Operand(Pair<Type, Value> typedValue) {
		this.type = typedValue.getFirst();
		this.immediate = Immediate.iValue(typedValue.getSecond());
	}
}