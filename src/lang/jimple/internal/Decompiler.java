package lang.jimple.internal;

import static lang.jimple.internal.JimpleVallangInterface.isInterface;
import static lang.jimple.internal.JimpleVallangInterface.modifiers;
import static lang.jimple.internal.JimpleVallangInterface.objectConstructor;
import static lang.jimple.internal.JimpleVallangInterface.type;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Stack;

import org.objectweb.asm.ClassReader;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;
import org.objectweb.asm.tree.ClassNode;
import org.objectweb.asm.tree.LocalVariableNode;
import org.objectweb.asm.tree.MethodNode;
import org.objectweb.asm.tree.TryCatchBlockNode;
import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;
import org.rascalmpl.uri.URIResolverRegistry;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;
import lang.jimple.internal.generated.CatchClause;
import lang.jimple.internal.generated.ClassOrInterfaceDeclaration;
import lang.jimple.internal.generated.Field;
import lang.jimple.internal.generated.LocalVariableDeclaration;
import lang.jimple.internal.generated.Method;
import lang.jimple.internal.generated.MethodBody;
import lang.jimple.internal.generated.Modifier;
import lang.jimple.internal.generated.Statement;
import lang.jimple.internal.generated.Type;

/**
 * Decompiler used to convert Java byte code into Jimple representation. This is
 * an internal class, which should only be used through its Rascal counterpart.
 *
 * @author rbonifacio
 */
public class Decompiler {
	private final IValueFactory vf;
	private IConstructor _class;

	public Decompiler(IValueFactory vf) {
		this.vf = vf;
	}

	/*
	 * decompiles a Java byte code at <i>classLoc</i> into a Jimple representation.
	 */
	public IConstructor decompile(ISourceLocation classLoc) {
		try {
			ClassReader reader = new ClassReader(URIResolverRegistry.getInstance().getInputStream(classLoc));
			ClassNode cn = new ClassNode();
			reader.accept(cn, 0);
			reader.accept(new GenerateJimpleClassVisitor(cn), 0);
			return _class;
		} catch (IOException e) {
			throw RuntimeExceptionFactory.io(vf.string(e.getMessage()), null, null);
		}
	}

	/*
	 * an ASM class visitor that traverses a class byte code and generates a Jimple
	 * class.
	 */
	class GenerateJimpleClassVisitor extends ClassVisitor {
		private ClassNode cn;
		private List<Modifier> classModifiers;
		private Type type;
		private Type superClass;
		private List<Type> interfaces;
		private List<Field> fields;
		private List<Method> methods;
		private boolean isInterface;

		public GenerateJimpleClassVisitor(ClassNode cn) {
			super(Opcodes.ASM4);
			this.cn = cn;
		}

		@Override
		public void visit(int version, int access, String name, String signature, String superClass, String[] interfaces) {
			this.classModifiers = modifiers(access);
			this.type = objectConstructor(name);
			this.superClass = superClass != null ? objectConstructor(superClass) : objectConstructor("java.lang.Object");
			this.interfaces = new ArrayList<>();

			if (interfaces != null) {
				for (String anInterface : interfaces) {
					this.interfaces.add(objectConstructor(anInterface));
				}
			}

			this.fields = new ArrayList<>();
			this.methods = new ArrayList<>();

			isInterface = isInterface(access);
		}

		@Override
		public void visitEnd() {
			Iterator it = cn.methods.iterator();
			
			while(it.hasNext()) {
				visitMethod((MethodNode)it.next());
			}
			
			if (isInterface) {
				_class = ClassOrInterfaceDeclaration.interfaceDecl(type, classModifiers, interfaces, fields, methods)
						.createVallangInstance(vf);
			} else {
				_class = ClassOrInterfaceDeclaration
						.classDecl(type, classModifiers, superClass, interfaces, fields, methods)
						.createVallangInstance(vf);
			}
		}

		private void visitMethod(MethodNode mn) {
			List<Modifier> methodModifiers = modifiers(mn.access);
			Type methodReturnType = type(org.objectweb.asm.Type.getReturnType(mn.desc).getDescriptor());
			String methodName = mn.name;
			
			List<Type> methodFormalArgs = new ArrayList<>();
			List<Type> methodExceptions = new ArrayList();
			
			for(org.objectweb.asm.Type t: org.objectweb.asm.Type.getArgumentTypes(mn.desc)) {
				methodFormalArgs.add(type(t.getDescriptor()));
			}
			
			if(mn.exceptions != null) {
			  Iterator it = mn.exceptions.iterator();
			
			  while(it.hasNext()) {
			     String str = (String)it.next();
				 methodExceptions.add(objectConstructor(str));
			  }
			}
						
			HashMap<LocalVariableNode, LocalVariableDeclaration> localVariables = visitLocalVariables(mn.localVariables);
			
			List<LocalVariableDeclaration> decls = new ArrayList<>();
			List<Statement> stmts = new ArrayList<>();
			List<CatchClause> catchClauses = visitTryCatchBlocks(mn.tryCatchBlocks);
			
			
			for(LocalVariableDeclaration var: localVariables.values()) {
				decls.add(var);
			}
			
			// TODO: Instructions
			// InstructionSetVisitor insVisitor = new InstructionSetVisitor(Opcodes.ASM4, localVariables);
			//
			// mn.instructions.accept(insVisitor);
			//
			
			MethodBody methodBody = MethodBody.methodBody(decls, stmts, catchClauses); 
			
			methods.add(Method.method(methodModifiers, methodReturnType, methodName, methodFormalArgs, methodExceptions, methodBody));
			
		}

		@Override
		public FieldVisitor visitField(int access, String name, String descriptor, String signature, Object value) {
			List<Modifier> fieldModifiers = modifiers(access);
			Type fieldType = type(descriptor);

			fields.add(Field.field(fieldModifiers, fieldType, name));

			return super.visitField(access, name, descriptor, signature, value);
		}

		private HashMap<LocalVariableNode, LocalVariableDeclaration> visitLocalVariables(List<LocalVariableNode> nodes) {
			HashMap<LocalVariableNode, LocalVariableDeclaration> localVariables = new HashMap<>();
			for(int i = 0; i < nodes.size(); i++) {
				LocalVariableNode var = nodes.get(i);
				Type type = type(var.desc);
			    String name = "l" + i;
			    localVariables.put(var, LocalVariableDeclaration.localVariableDeclaration(type, name));
			}
			return localVariables;
		}

		private List<CatchClause> visitTryCatchBlocks(List<TryCatchBlockNode> nodes) {
			List<CatchClause> tryCatchBlocks = new ArrayList<>();
			for(TryCatchBlockNode node: nodes) {
			  String from = node.start.getLabel().toString();
			  String to = node.end.getLabel().toString();
			  String with = node.handler.getLabel().toString();
			
			  Type exception = objectConstructor(node.type);
			
			  tryCatchBlocks.add(CatchClause.catchClause(exception, from, to, with));
			}
			return tryCatchBlocks;
		}

	}

	class InstructionSetVisitor extends MethodVisitor {
		class Operand {
			IConstructor type;
			IConstructor immediate;

			Operand(IConstructor type, IConstructor immediate) {
				this.type = type;
				this.immediate = immediate;
			}

			Operand(IConstructor localDeclaration) {
				this.type = (IConstructor) localDeclaration.get("type");
				this.immediate = newLocalImmediate((IString) localDeclaration.get("local"));
			}
		}

		Stack<Operand> operandStack;
		List<IConstructor> auxiliarlyLocalVariables;
		HashMap<LocalVariableNode, IConstructor> localVariables;
		int locals;

		IList instructions;

		public InstructionSetVisitor(int version, HashMap<LocalVariableNode, IConstructor> localVariables) {
			super(version);
			this.localVariables = localVariables;
			operandStack = new Stack<>();
			auxiliarlyLocalVariables = new ArrayList<>();
			locals = localVariables.size();
			instructions = vf.list();
		}

		/*
		 * Visit a field instruction. The opcode must be one of: - GETSTATIC - PUTSTATIC
		 * - GETFIELD - PUTFIELD
		 */
		@Override
		public void visitFieldInsn(int opcode, String owner, String field, String descriptor) {
			switch (opcode) {
			case Opcodes.GETSTATIC:
				getStaticIns(owner, field, descriptor);
				break;
			case Opcodes.PUTSTATIC:
				break; // TODO not implemented yet
			case Opcodes.GETFIELD:
				getFieldIns(owner, field, descriptor);
				break;
			case Opcodes.PUTFIELD:
				break; // TODO not implemented yet
			}
			super.visitFieldInsn(opcode, owner, field, descriptor);
		}

		/*
		 * Visit an Int Increment Instruction. This instruction does not change the
		 * operand stack.
		 * 
		 * @param idx index of the local variable
		 * 
		 * @increment ammount of the increment.
		 * 
		 * (non-Javadoc)
		 * 
		 * @see org.objectweb.asm.MethodVisitor#visitIincInsn(int, int)
		 * 
		 * @see
		 * https://docs.oracle.com/javase/specs/jvms/se9/html/jvms-6.html#jvms-6.5.iinc
		 */
		@Override
		public void visitIincInsn(int idx, int increment) {
			IConstructor local = findLocalVariable(idx);

			IString var = (IString) local.get("local");

			IConstructor lhs = newLocalImmediate(var);
			IConstructor rhs = newIntValueImmediate(increment);
			IConstructor expression = newPlusExpression(lhs, rhs);

			instructions = instructions.append(assignmentStmt(var, expression));
		}

		private IConstructor findLocalVariable(int idx) {
			IConstructor local = null;
			for (LocalVariableNode node : localVariables.keySet()) {
				if (node.index == idx) {
					local = localVariables.get(node);
				}
			}
			if (local == null) {
				throw new RuntimeException("local variable not found");
			}
			return local;
		}

		@Override
		public void visitInsn(int opcode) {
			switch (opcode) {
			case Opcodes.NOP:
				nopIns();
				break;
			case Opcodes.ACONST_NULL:
				acconstNullIns();
				break;
			case Opcodes.ICONST_M1:
				loadIntConstIns(-1, "I");
				break;
			case Opcodes.ICONST_0:
				loadIntConstIns(0, "I");
				break;
			case Opcodes.ICONST_1:
				loadIntConstIns(1, "I");
				break;
			case Opcodes.ICONST_2:
				loadIntConstIns(2, "I");
				break;
			case Opcodes.ICONST_3:
				loadIntConstIns(3, "I");
				break;
			case Opcodes.ICONST_4:
				loadIntConstIns(4, "I");
				break;
			case Opcodes.ICONST_5:
				loadIntConstIns(5, "I");
				break;
			case Opcodes.LCONST_0:
				loadIntConstIns(0, "J");
				break;
			case Opcodes.LCONST_1:
				loadIntConstIns(1, "J");
				break;
			case Opcodes.FCONST_0:
				loadRealConstIns(0.0F, "F");
				break;
			case Opcodes.FCONST_1:
				loadRealConstIns(1.0F, "F");
				break;
			case Opcodes.FCONST_2:
				loadRealConstIns(2.0F, "F");
				break;
			case Opcodes.DCONST_0:
				loadRealConstIns(0.0F, "F");
				break;
			case Opcodes.DCONST_1:
				loadRealConstIns(1.0F, "F");
				break;
			case Opcodes.IALOAD:
				arraySubscript();
				break;
			case Opcodes.LALOAD:
				arraySubscript();
				break;
			case Opcodes.FALOAD:
				arraySubscript();
				break;
			case Opcodes.DALOAD:
				arraySubscript();
				break;

			case Opcodes.IADD:
				addIns("I");
				break;
			}
			// IALOAD, LALOAD, FALOAD, DALOAD, AALOAD, BALOAD, CALOAD, SALOAD, IASTORE,
			// LASTORE, FASTORE, DASTORE, AASTORE, BASTORE, CASTORE, SASTORE, POP, POP2,
			// DUP, DUP_X1, DUP_X2, DUP2, DUP2_X1, DUP2_X2, SWAP, IADD, LADD, FADD, DADD,
			// ISUB, LSUB, FSUB, DSUB, IMUL, LMUL, FMUL, DMUL, IDIV, LDIV, FDIV, DDIV, IREM,
			// LREM, FREM, DREM, INEG, LNEG, FNEG, DNEG, ISHL, LSHL, ISHR, LSHR, IUSHR,
			// LUSHR, IAND, LAND, IOR, LOR, IXOR, LXOR, I2L, I2F, I2D, L2I, L2F, L2D, F2I,
			// F2L, F2D, D2I, D2L, D2F, I2B, I2C, I2S, LCMP, FCMPL, FCMPG, DCMPL, DCMPG,
			// IRETURN, LRETURN, FRETURN, DRETURN, ARETURN, RETURN, ARRAYLENGTH, ATHROW,
			// MONITORENTER, or MONITOREXIT.
		}

		@Override
		public void visitVarInsn(int opcode, int var) {
			switch (opcode) {
			case Opcodes.ILOAD:
				loadIns(var);
				break;
			case Opcodes.ISTORE:
				storeIns(var);
				break;
			}
		}

		private void loadIns(int var) {
			IConstructor local = findLocalVariable(var);
			operandStack.push(new Operand(local));
		}

		/*
		 * assigns the expression at the top position of the stack into a variable.
		 */
		private void storeIns(int var) {
			IConstructor local = findLocalVariable(var);
			IConstructor immediate = operandStack.pop().immediate;

			instructions = instructions.append(assignmentStmt((IString) local.get("local"), immediate));
		}

		private void nopIns() {
			IConstructor nop = ValueBuilder.instance().withType("Statement").withConstructor("nop").build(vf);

			instructions = instructions.append(nop);
		}

		private void acconstNullIns() {
			// operandStack.add(new Operand(type(vf, "null_type"),
			// newNullValueImmediate()));
		}

		private void loadIntConstIns(int value, String descriptor) {
			// operandStack.add(new Operand(type(vf, descriptor),
			// newIntValueImmediate(value)));
		}

		private void loadRealConstIns(float value, String descriptor) {
			// operandStack.add(new Operand(type(vf, descriptor),
			// newRealValueImmediate(value)));
		}

		private void addIns(String descriptor) {
			Operand lhs = operandStack.pop();
			Operand rhs = operandStack.pop();

			IConstructor newLocal = createLocal(descriptor);

			IConstructor expression = newPlusExpression(lhs.immediate, rhs.immediate);

			instructions = instructions.append(assignmentStmt((IString) newLocal.get("local"), expression));

			operandStack.push(new Operand(newLocal));
		}

		private void arraySubscript() {
			// Operand idx = operandStack.pop();
			// Operand ref = operandStack.pop();
			//
			// IConstructor baseType = ref.type;
			// if(baseType.getConstructorType().equals(_arrayConstructor)) {
			// baseType = (IConstructor)baseType.get("baseType");
			// }
			// IConstructor newLocal =createLocal(baseType);
			//
			// instructions =
			// instructions.append(assignmentStmt((IString)newLocal.get("local"),
			// newArraySubscript((IString)ref.immediate.get("localName"), idx.immediate)));
			//
			// operandStack.push(new Operand(newLocal));
		}

		private void getStaticIns(String owner, String field, String descriptor) {
			IConstructor newLocal = createLocal(descriptor);
			IString className = vf.string(owner);
			IString fieldName = vf.string(field);
			// IConstructor fieldType = type(vf, descriptor);

			// IConstructor fieldRef = ValueBuilder.instance()
			// .withType("Expression")
			// .withConstructor("fieldRef")
			// .withStringArgument("className", className)
			// .withConstructorArgument("fieldType", "Type", fieldType)
			// .withStringArgument("fieldName", fieldName)
			// .build(vf);
			//
			// instructions =
			// instructions.append(assignmentStmt((IString)newLocal.get("local"),
			// fieldRef));
			// operandStack.push(new Operand(newLocal));
		}

		private IConstructor assignmentStmt(IString local, IConstructor expression) {
			// return ValueBuilder.instance()
			// .withType("Statement")
			// .withConstructor("assign")
			// .withStringArgument("local", local)
			// .withConstructorArgument("expression", "Expression", expression)
			// .build(vf);
			return null;
		}

		private void getFieldIns(String owner, String field, String descriptor) {
			// IConstructor local = operandStack.pop().immediate;
			//
			// IConstructor newLocal = createLocal(descriptor);
			// IString className = vf.string(owner);
			// IString fieldName = vf.string(field);
			// IConstructor fieldType = type(vf, descriptor);
			//
			// IConstructor localFieldRef = ValueBuilder.instance()
			// .withType("Expression")
			// .withConstructor("localFieldRef")
			// .withStringArgument("local", (IString)local.get("localName"))
			// .withStringArgument("className", className)
			// .withConstructorArgument("fieldType", "Type", fieldType)
			// .withStringArgument("fieldName", fieldName)
			// .build(vf);
			//
			// IConstructor assignment = ValueBuilder.instance()
			// .withType("Statement")
			// .withConstructor("assign")
			// .withStringArgument("local", (IString)newLocal.get("local"))
			// .withConstructorArgument("expression", "Expression", localFieldRef)
			// .build(vf);
			//
			// instructions = instructions.append(assignment);
			// operandStack.push(new Operand(newLocal));
		}

		private IConstructor createLocal(String descriptor) {
			// return createLocal(type(vf, descriptor));
			return null;
		}

		private IConstructor createLocal(IConstructor type) {
			// String name = "l" + locals++;
			// IConstructor local = localVariableDeclaration(vf, type, vf.string(name));
			// auxiliarlyLocalVariables.add(local);
			// return local;
			return null;
		}

		private IConstructor newPlusExpression(IConstructor lhs, IConstructor rhs) {
			// return ValueBuilder.instance()
			// .withType("Expression")
			// .withConstructor("plus")
			// .withConstructorArgument("lhs", "Immediate", lhs)
			// .withConstructorArgument("rhs", "Immediate", rhs)
			// .build(vf);
			//
			return null;
		}

		private IConstructor newArraySubscript(IString name, IConstructor immediate) {
			// return ValueBuilder.instance()
			// .withType("Expression")
			// .withConstructor("arraySubscript")
			// .withStringArgument("name", name)
			// .withConstructorArgument("immediate", "Immediate", immediate)
			// .build(vf);

			return null;
		}

		private IConstructor newIntValueImmediate(int value) {
			// return ValueBuilder.instance()
			// .withType("Immediate")
			// .withConstructor("intValue")
			// .withIntArgument("iValue", vf.integer(value))
			// .build(vf);
			return null;
		}

		private IConstructor newRealValueImmediate(float value) {
			// return ValueBuilder.instance()
			// .withType("Immediate")
			// .withConstructor("intValue")
			// .withRealArgument("iValue", vf.real(value))
			// .build(vf);

			return null;
		}

		private IConstructor newNullValueImmediate() {
			// return ValueBuilder.instance()
			// .withType("Immediate")
			// .withConstructor("nullValue")
			// .build(vf);

			return null;
		}

		private IConstructor newLocalImmediate(IString var) {
			// return ValueBuilder.instance().
			// withType("Immediate")
			// .withConstructor("local")
			// .withStringArgument("localName", var)
			// .build(vf);

			return null;
		}

	}
}
