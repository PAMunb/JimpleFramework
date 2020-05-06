package lang.jimple.internal;

import static lang.jimple.internal.JimpleObjectFactory.type;

import java.util.ArrayList;
import java.util.List;

import org.objectweb.asm.Opcodes;
import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;
// import io.usethesource.vallang.type.Type;
import io.usethesource.vallang.type.TypeFactory;
import io.usethesource.vallang.type.TypeStore;
import lang.jimple.internal.generated.Expression;
import lang.jimple.internal.generated.Immediate;
import lang.jimple.internal.generated.LocalVariableDeclaration;
import lang.jimple.internal.generated.Modifier;
import lang.jimple.internal.generated.Statement;
import lang.jimple.internal.generated.Type;
import lang.jimple.internal.generated.Variable;

public class JimpleObjectFactory {

	public static Type objectConstructor(String name) {
		return Type.TObject(name.replace("/", "."));
	}
	
	public static Statement assignmentStmt(Variable var, Expression expression) {
		return Statement.assign(var, expression);
	}
	
	public static Expression newPlusExpression(Immediate lhs, Immediate rhs) {
		return Expression.plus(lhs, rhs);
	}
	
	public static Expression newMinusExpression(Immediate lhs, Immediate rhs) {
		return Expression.minus(lhs, rhs);
	}
	
	public static Expression newMultExpression(Immediate lhs, Immediate rhs) {
		return Expression.mult(lhs, rhs);
	}
	
	public static Expression newDivExpression(Immediate lhs, Immediate rhs) {
		return Expression.div(lhs, rhs);
	}
	
	public static Expression newReminderExpression(Immediate lhs, Immediate rhs) {
		return Expression.reminder(lhs, rhs);
	}

	public static Expression newArraySubscript(String name, Immediate immediate) {
		return Expression.arraySubscript(name, immediate);
	}

	public static Immediate newIntValueImmediate(int value) {
		return Immediate.intValue(value);
	}

	public static Immediate newRealValueImmediate(float value) {
		return Immediate.floatValue(value);
	}

	public static Immediate newNullValueImmediate() {
		return Immediate.nullValue();
	}

	public static Immediate newLocalImmediate(String var) {
		return Immediate.local(var);
	}
	
	public static Type type(String descriptor) {
		// primitive types 
		switch(descriptor) {
		  case "Z" : return Type.TBoolean();
		  case "C" : return Type.TCharacter(); 
		  case "B" : return Type.TByte(); 
		  case "S" : return Type.TShort(); 
		  case "I" : return Type.TInteger(); 
		  case "F" : return Type.TFloat();
		  case "J" : return Type.TLong();
		  case "D" : return Type.TDouble(); 
		  case "V" : return Type.TVoid();
		  case "null_type" : return Type.TNull();
		  default  : /* do nothing */  
		}
		// object types 
		if(descriptor.startsWith("L")) {
			String objectName = descriptor.substring(1, descriptor.length()-1);
			return objectConstructor(objectName);
		}
		else if(descriptor.startsWith("[")) {  // array types 
			String baseType = descriptor.substring(0, descriptor.length());				
			return Type.TArray(type(baseType));	
		}
		
		// TODO: what should we do in this situation? For now, 
		// instead of throwing a runtime exception, lets return 
		// the unknown type. 
		return Type.TUnknown();
	}

	public static List<Modifier> modifiers(int access) {
		List<Modifier> list = new ArrayList<Modifier>();
		
		if((access & Opcodes.ACC_ABSTRACT) != 0) {
			list.add(Modifier.Abstract());
		}
		if((access & Opcodes.ACC_FINAL) != 0) {
			list.add(Modifier.Final());
		}
		if((access & Opcodes.ACC_PUBLIC) != 0) {
			list.add(Modifier.Public());
		}
		if((access & Opcodes.ACC_PRIVATE) != 0) {
			list.add(Modifier.Private());
		}
		if((access & Opcodes.ACC_PROTECTED) != 0) {
			list.add(Modifier.Protected());
		}
		if((access & Opcodes.ACC_STATIC) != 0) {
			list.add(Modifier.Static());
		}
		if((access & Opcodes.ACC_SYNCHRONIZED) != 0) {
			list.add(Modifier.Synchronized());
		}
		if((access & Opcodes.ACC_TRANSIENT) != 0) {
			list.add(Modifier.Transient());
		}
		if((access & Opcodes.ACC_VOLATILE) != 0) {
			list.add(Modifier.Volatile());
		}
		if((access & Opcodes.ACC_STRICT) != 0) {
			list.add(Modifier.Strictfp());
		}
		if((access & Opcodes.ACC_ENUM) != 0) {
			list.add(Modifier.Enum());
		}
		if((access & Opcodes.ACC_ANNOTATION) != 0) {
			list.add(Modifier.Annotation());
		}
		return list;
	}
	
	public static boolean isInterface(int access) {
		return (access & Opcodes.ACC_INTERFACE) != 0; 
	}

}
