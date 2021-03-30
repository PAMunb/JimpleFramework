package lang.jimple.internal;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.objectweb.asm.Handle;
import org.objectweb.asm.Opcodes;

import lang.jimple.internal.generated.Expression;
import lang.jimple.internal.generated.FieldSignature;
import lang.jimple.internal.generated.Immediate;
import lang.jimple.internal.generated.MethodSignature;
import lang.jimple.internal.generated.Modifier;
import lang.jimple.internal.generated.Statement;
import lang.jimple.internal.generated.Type;
import lang.jimple.internal.generated.Value;
import lang.jimple.internal.generated.Variable;
import lang.jimple.util.Pair;

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
		return Immediate.iValue(Value.intValue(value));
	}

	public static Immediate newRealValueImmediate(float value) {
		return Immediate.iValue(Value.floatValue(value));
	}

	public static Immediate newNullValueImmediate() {
		return Immediate.iValue(Value.nullValue());
	}

	public static Immediate newLocalImmediate(String var) {
		return Immediate.local(var);
	}

	public static MethodSignature methodSignature(String owner, String name, String descriptor) {
		org.objectweb.asm.Type methodType = org.objectweb.asm.Type.getMethodType(descriptor);

		Type returnType = type(methodType.getReturnType().getDescriptor());

		List<Type> formals = new ArrayList();

		for (org.objectweb.asm.Type t : methodType.getArgumentTypes()) {
			formals.add(type(t.getDescriptor()));
		}

		return MethodSignature.methodSignature(owner, returnType, name, formals);
	}

	public static Type methodReturnType(String descriptor) {
		return type(org.objectweb.asm.Type.getReturnType(descriptor).getDescriptor());
	}

	public static List<Type> methodArgumentTypes(String descriptor) {
		org.objectweb.asm.Type[] args = org.objectweb.asm.Type.getArgumentTypes(descriptor);

		List<Type> res = new ArrayList<>();
		for (org.objectweb.asm.Type t : args) {
			res.add(type(t.getDescriptor()));
		}
		return res;
	}

	public static String localVariableName(boolean isStackVariable, String type, int idx) {
		String infix = "r";

		switch (type) {
		case "TLong":
			infix = "l";
			break;
		case "TChar":
			infix = "c";
			break;
		case "TByte":
			infix = "b";
			break;
		case "TShort":
			infix = "s";
			break;
		case "TFloat":
			infix = "f";
			break;
		case "TDouble":
			infix = "d";
			break;
		}

		return isStackVariable ? "$" + (infix + idx) : (infix + idx);
	}

	public static Type type(String descriptor) {
		// primitive types
		switch (descriptor) {
		case "Z":
			return Type.TBoolean();
		case "C":
			return Type.TCharacter();
		case "B":
			return Type.TByte();
		case "S":
			return Type.TShort();
		case "I":
			return Type.TInteger();
		case "F":
			return Type.TFloat();
		case "J":
			return Type.TLong();
		case "D":
			return Type.TDouble();
		case "V":
			return Type.TVoid();
		case "null_type":
			return Type.TNull();
		default: /* do nothing */
		}
		// object types
		if (descriptor.startsWith("L")) {
			String objectName = descriptor.substring(1, descriptor.length() - 1);
			return objectConstructor(objectName);
		} else if (descriptor.startsWith("[")) { // array types
			String baseType = descriptor.substring(1, descriptor.length());
			Type base = objectConstructor(baseType);
			return Type.TArray(type(baseType));
		}

		// TODO: what should we do in this situation? For now,
		// instead of throwing a runtime exception, lets return
		// the unknown type.
		return Type.TUnknown();
	}

	public static MethodSignature methodSignature(Handle handle) {
		return MethodSignature.methodSignature(handle.getOwner(), methodReturnType(handle.getDesc()), handle.getName(),
				methodArgumentTypes(handle.getDesc()));
	}

	public static List<Modifier> modifiers(int access) {
		List<Modifier> list = new ArrayList<Modifier>();

		if ((access & Opcodes.ACC_PUBLIC) != 0) {
			list.add(Modifier.Public());
		}
		if ((access & Opcodes.ACC_PROTECTED) != 0) {
			list.add(Modifier.Protected());
		}
		if ((access & Opcodes.ACC_PRIVATE) != 0) {
			list.add(Modifier.Private());
		}
		if ((access & Opcodes.ACC_ABSTRACT) != 0) {
			list.add(Modifier.Abstract());
		}
		if ((access & Opcodes.ACC_STATIC) != 0) {
			list.add(Modifier.Static());
		}
		if ((access & Opcodes.ACC_FINAL) != 0) {
			list.add(Modifier.Final());
		}
		if ((access & Opcodes.ACC_SYNCHRONIZED) != 0) {
			list.add(Modifier.Synchronized());
		}
		if ((access & Opcodes.ACC_STRICT) != 0) {
			list.add(Modifier.Strictfp());
		}
		if ((access & Opcodes.ACC_TRANSIENT) != 0) {
			list.add(Modifier.Transient());
		}
		if ((access & Opcodes.ACC_VOLATILE) != 0) {
			list.add(Modifier.Volatile());
		}
		if ((access & Opcodes.ACC_ENUM) != 0) {
			list.add(Modifier.Enum());
		}
		if ((access & Opcodes.ACC_ANNOTATION) != 0) {
			list.add(Modifier.Annotation());
		}
		if ((access & Opcodes.ACC_SYNTHETIC) != 0) {
			list.add(Modifier.Synthetic());
		}
		return list;
	}

	public static Pair<Type, Value> toJimpleTypedValue(Object value) {
		if ((value instanceof Integer)) {
			return new Pair<Type, Value>(Type.TInteger(), Value.intValue((Integer) value));
		} else if (value instanceof Float) {
			return new Pair<Type, Value>(Type.TFloat(), Value.floatValue((Float) value));
		} else if (value instanceof Long) {
			return new Pair<Type, Value>(Type.TLong(), Value.longValue((Long) value));
		} else if (value instanceof Double) {
			return new Pair<Type, Value>(Type.TDouble(), Value.doubleValue((Double) value));
		} else if (value instanceof String) {
			return new Pair<Type, Value>(Type.TString(), Value.stringValue((String) value));
		} else if (value instanceof org.objectweb.asm.Type) {
			org.objectweb.asm.Type t = (org.objectweb.asm.Type) value;
			if (t.getSort() == org.objectweb.asm.Type.METHOD) {
				Type returnType = methodReturnType(t.getDescriptor());
				List<Type> formals = methodArgumentTypes(t.getDescriptor());

				return new Pair<Type, Value>(Type.TMethodValue(), Value.methodValue(returnType, formals));
			} else {
				return new Pair<Type, Value>(Type.TClassValue(), Value.classValue(t.getDescriptor()));
			}
		} else if (value instanceof org.objectweb.asm.Handle) {
			org.objectweb.asm.Handle h = (org.objectweb.asm.Handle) value;

			if (isMethodHandle(h.getTag())) {
				MethodSignature sig = MethodSignature.methodSignature(h.getOwner(), methodReturnType(h.getDesc()),
						h.getName(), methodArgumentTypes(h.getDesc()));
				return new Pair<Type, Value>(Type.TMethodHandle(), Value.methodHandle(sig));
			} else {
				FieldSignature sig = FieldSignature.fieldSignature(h.getOwner(), type(h.getDesc()), h.getName());
				return new Pair<Type, Value>(Type.TFieldHandle(), Value.fieldHandle(sig));
			}
		}
		throw new RuntimeException("Unknown constant type " + value.getClass());
	}

	public static boolean isInterface(int access) {
		return (access & Opcodes.ACC_INTERFACE) != 0;
	}

	private static boolean isMethodHandle(int tag) {
		return methodTags.contains(tag);
	}

	private static Set<Integer> methodTags = methodTags();
	private static Set<Integer> fieldTags = fieldTags();

	private static Set<Integer> methodTags() {
		Set<Integer> tags = new HashSet<>();

		tags.add(Opcodes.H_INVOKEVIRTUAL);
		tags.add(Opcodes.H_INVOKESTATIC);
		tags.add(Opcodes.H_INVOKESPECIAL);
		tags.add(Opcodes.H_NEWINVOKESPECIAL);
		tags.add(Opcodes.H_INVOKEINTERFACE);

		return tags;
	}

	private static Set<Integer> fieldTags() {
		Set<Integer> tags = new HashSet<>();

		tags.add(Opcodes.H_GETFIELD);
		tags.add(Opcodes.H_GETSTATIC);
		tags.add(Opcodes.H_GETSTATIC);
		tags.add(Opcodes.H_PUTSTATIC);

		return tags;
	}

}
