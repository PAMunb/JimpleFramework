package lang.jimple.internal;

import static lang.jimple.internal.JimpleObjectFactory.*;

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
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IValueFactory;
import lang.jimple.internal.generated.CatchClause;
import lang.jimple.internal.generated.ClassOrInterfaceDeclaration;
import lang.jimple.internal.generated.Expression;
import lang.jimple.internal.generated.Field;
import lang.jimple.internal.generated.Immediate;
import lang.jimple.internal.generated.LocalVariableDeclaration;
import lang.jimple.internal.generated.Method;
import lang.jimple.internal.generated.MethodBody;
import lang.jimple.internal.generated.Modifier;
import lang.jimple.internal.generated.Statement;
import lang.jimple.internal.generated.Type;
import lang.jimple.internal.generated.Variable;

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
			
			//TODO: uncomment the following lines to decompile the instructions. 
//			InstructionSetVisitor insVisitor = new InstructionSetVisitor(Opcodes.ASM4, localVariables);
//			mn.instructions.accept(insVisitor);
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
			
			if(nodes != null) {
				for(int i = 0; i < nodes.size(); i++) {
					LocalVariableNode var = nodes.get(i);
					Type type = type(var.desc);
				    String name = "l" + i;
				    localVariables.put(var, LocalVariableDeclaration.localVariableDeclaration(type, name));
				}
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
			Type type;
			Immediate immediate;

			Operand(Type type, Immediate immediate) {
				this.type = type;
				this.immediate = immediate;
			}

			Operand(LocalVariableDeclaration localDeclaration) {
				this.type = localDeclaration.varType;
				this.immediate = Immediate.local(localDeclaration.local);
			}
		}

		Stack<Operand> operandStack;
		List<LocalVariableDeclaration> auxiliarlyLocalVariables;
		HashMap<LocalVariableNode, LocalVariableDeclaration> localVariables;
		int locals;

		List<Statement> instructions;

		public InstructionSetVisitor(int version, HashMap<LocalVariableNode, LocalVariableDeclaration> localVariables) {
			super(version);
			this.localVariables = localVariables;
			operandStack = new Stack<>();
			auxiliarlyLocalVariables = new ArrayList<>();
			locals = localVariables.size();
			instructions = new ArrayList<>();
		}

		/*
		 * Visit a field instruction. The opcode must be one of: - GETSTATIC - PUTSTATIC
		 * - GETFIELD - PUTFIELD
		 */
		@Override
		public void visitFieldInsn(int opcode, String owner, String field, String descriptor) {
			switch (opcode) {
			 case Opcodes.GETSTATIC : getStaticIns(owner, field, descriptor); break;
			 case Opcodes.PUTSTATIC : break; // TODO not implemented yet
			 case Opcodes.GETFIELD  : getFieldIns(owner, field, descriptor); break;
			 case Opcodes.PUTFIELD  : break; // TODO not implemented yet
			}
			super.visitFieldInsn(opcode, owner, field, descriptor);
		}

		/*
		 * Visit an Int Increment Instruction. This instruction does not change the
		 * operand stack.
		 * 
		 * @param idx index of the local variable
		 * @increment ammount of the increment.
		 * 
		 * (non-Javadoc)
		 * @see org.objectweb.asm.MethodVisitor#visitIincInsn(int, int)
		 * @see
		 * https://docs.oracle.com/javase/specs/jvms/se9/html/jvms-6.html#jvms-6.5.iinc
		 */
		@Override
		public void visitIincInsn(int idx, int increment) {
			LocalVariableDeclaration local = findLocalVariable(idx);

			String var = local.local;

			Immediate lhs = newLocalImmediate(var);
			Immediate rhs = newIntValueImmediate(increment);
			Expression expression = newPlusExpression(lhs, rhs);

			instructions.add(assignmentStmt(Variable.localVariable(var), expression));
		}

		
		@Override
		public void visitInsn(int opcode) {
			switch (opcode) {
			 case Opcodes.NOP         : nopIns();                     break;
			 case Opcodes.ACONST_NULL : acconstNullIns();             break;
			 case Opcodes.ICONST_M1   : loadIntConstIns(-1,"I");      break;
			 case Opcodes.ICONST_0    : loadIntConstIns(0, "I");      break;
			 case Opcodes.ICONST_1    : loadIntConstIns(1, "I");      break;
			 case Opcodes.ICONST_2    : loadIntConstIns(2, "I");      break;
			 case Opcodes.ICONST_3    : loadIntConstIns(3, "I");      break;
			 case Opcodes.ICONST_4    : loadIntConstIns(4, "I");      break;
			 case Opcodes.ICONST_5    : loadIntConstIns(5, "I");      break; 
			 case Opcodes.LCONST_0    : loadIntConstIns(0, "J");      break;
			 case Opcodes.LCONST_1    : loadIntConstIns(1, "J");      break;
			 case Opcodes.FCONST_0    : loadRealConstIns(0.0F, "F");  break;
			 case Opcodes.FCONST_1    : loadRealConstIns(1.0F, "F");  break;
			 case Opcodes.FCONST_2    : loadRealConstIns(2.0F, "F");  break;
			 case Opcodes.DCONST_0    : loadRealConstIns(0.0F, "F");  break;
			 case Opcodes.DCONST_1    : loadRealConstIns(1.0F, "F");  break;
			 case Opcodes.IALOAD      : arraySubscriptIns();          break;
			 case Opcodes.LALOAD      : arraySubscriptIns();          break;
			 case Opcodes.FALOAD      : arraySubscriptIns();          break;
			 case Opcodes.DALOAD      : arraySubscriptIns();          break;
			 case Opcodes.AALOAD      : arraySubscriptIns();          break;
			 case Opcodes.BALOAD      : arraySubscriptIns();          break; 
			 case Opcodes.CALOAD      : arraySubscriptIns();          break; 
			 case Opcodes.SALOAD      : arraySubscriptIns();          break; 
			 case Opcodes.IASTORE     : storeIntoArrayIns();          break; 
			 case Opcodes.LASTORE     : storeIntoArrayIns();          break; 
			 case Opcodes.FASTORE     : storeIntoArrayIns();          break; 
			 case Opcodes.DASTORE     : storeIntoArrayIns();          break; 
			 case Opcodes.AASTORE     : storeIntoArrayIns();          break; 
			 case Opcodes.BASTORE     : storeIntoArrayIns();          break; 
			 case Opcodes.CASTORE     : storeIntoArrayIns();          break; 
			 case Opcodes.SASTORE     : storeIntoArrayIns();          break; 
			 case Opcodes.POP         : popIns();                     break;
			 case Opcodes.POP2        : pop2Ins();                    break; 
			 case Opcodes.DUP         : dupIns();                     break;
			 case Opcodes.IADD        : addIns("I");                  break;
			}
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
			 case Opcodes.ILOAD : loadIns(var);  break;
			 case Opcodes.ISTORE: storeIns(var); break;
			}
		}

		private LocalVariableDeclaration findLocalVariable(int idx) {
			for (LocalVariableNode node : localVariables.keySet()) {
				if (node.index == idx) {
					return localVariables.get(node);
				}
			}
			throw new RuntimeException("local variable not found");
		}
		
		/*
		 * Load a local variable into the top of the 
		 * operand stack. 
		 */
		private void loadIns(int var) {
			LocalVariableDeclaration local = findLocalVariable(var);
			operandStack.push(new Operand(local));
		}

		/*
		 * Assign the expression at the top position of the stack into a variable.
		 */
		private void storeIns(int var) {
			LocalVariableDeclaration local = findLocalVariable(var);
			Immediate immediate = operandStack.pop().immediate;
			instructions.add(assignmentStmt(Variable.localVariable(local.local), Expression.immediate(immediate)));
		}

		/*
		 * Add a nop instruction 
		 */
		private void nopIns() {
			instructions.add(Statement.nop());
		}

		/*
		 * Load a null value into the top of the 
		 * operand stack. 
		 */
		private void acconstNullIns() {
			operandStack.push(new Operand(Type.TNull(), Immediate.nullValue()));
		}

		/*
		 * Load an int const into the top of the 
		 * operand stack. 
		 */
		private void loadIntConstIns(int value, String descriptor) {
			operandStack.push(new Operand(type(descriptor), Immediate.intValue(value)));
		}

		/*
		 * Load a float const into the top of the 
		 * operand stack. 
		 */
		private void loadRealConstIns(float value, String descriptor) {
			operandStack.push(new Operand(type(descriptor), Immediate.floatValue(value)));
		}

		/*
		 * Add two operands (lhs and rhs), and push the result into the 
		 * top of the stack. 
		 */
		private void addIns(String descriptor) {
			Operand lhs = operandStack.pop();
			Operand rhs = operandStack.pop();

			LocalVariableDeclaration newLocal = createLocal(descriptor);

			Expression expression = newPlusExpression(lhs.immediate, rhs.immediate);

			instructions.add(assignmentStmt(Variable.localVariable(newLocal.local), expression));

			operandStack.push(new Operand(newLocal));
		}

		/*
		 * Update the top of the operand stack with 
		 * the value of a specific indexed element of an 
		 * array. The index and the array's reference 
		 * are popped up from the stack.  
		 */
		private void arraySubscriptIns() {
			Operand idx = operandStack.pop();
			Operand ref = operandStack.pop();
			
			Type baseType = ref.type;
			
			if(baseType instanceof Type.c_TArray) {
			   baseType = ((Type.c_TArray)baseType).baseType;
			}
			
			LocalVariableDeclaration newLocal =createLocal(baseType);
			
			instructions.add(assignmentStmt(Variable.localVariable(newLocal.local), newArraySubscript(((Immediate.c_local)ref.immediate).localName,idx.immediate)));
			
			operandStack.push(new Operand(newLocal));
		}
		
		/*
		 * Updates a position of an array with a 
		 * value. The stack must be with the values:
		 * 
		 *  [ value ]
		 *  [  idx  ]
		 *  [ array ]
		 *  [ ...   ]  
		 *  _________
		 *  
		 *  After popping value, idx, and array, 
		 *  no value is introduced into the stack. 
		 */
		private void storeIntoArrayIns() {
			Immediate value = operandStack.pop().immediate;
			Immediate idx = operandStack.pop().immediate;
			Immediate arrayRef = operandStack.pop().immediate;
			
			Variable var = Variable.arrayRef(((Immediate.c_local)arrayRef).localName, idx);
			
			instructions.add(assignmentStmt(var, Expression.immediate(value)));
		}
		
		/*
		 * Removes an operand from the stack. 
		 */
		private void popIns() {
			operandStack.pop();
		}
		
		/*
		 * Removes either one or two operand from the 
		 * top of the stack. If the type of the first 
		 * operand is either a long or a double, it 
		 * removes just one operand. 
		 */
		private void pop2Ins() {
			Operand op = operandStack.pop(); 
			
			if(! (op.type instanceof Type.c_TDouble || op.type instanceof Type.c_TLong)) {
				operandStack.pop();
			}
		}
		
		/*
		 * Duplicate the top operand stack value
		 */
		private void dupIns() {
			Operand value = operandStack.pop();
			
			operandStack.push(value);
			operandStack.push(value);
		}
		
		/*
		 * Duplicate the top operand stack value and insert 
		 * the copy two values down. 
		 */
		private void dupX1Ins() {
			Operand value1 = operandStack.pop();
			Operand value2 = operandStack.pop();
			
			operandStack.push(value1);
			operandStack.push(value2);
			operandStack.push(value1); 
		}
		
		/*
		 * Duplicate the top operand stack value and insert 
		 * the copy two or three values down. 
		 */
		private void dupX2Ins() {
			Operand value1 = operandStack.pop(); 
			
			if(! (value1.type instanceof Type.c_TDouble || value1.type instanceof Type.c_TLong)) {
				Operand value2 = operandStack.pop();
				Operand value3 = operandStack.pop();
				operandStack.push(value1);
				operandStack.push(value3);
				operandStack.push(value2);
				operandStack.push(value1);
			}
			else {
				Operand value2 = operandStack.pop();
				operandStack.push(value1);
				operandStack.push(value2);
				operandStack.push(value1); 
			}
		}

		/*
		 * Load the value of a static field into the top 
		 * of the operand stack. 
		 * 
		 * @param owner the field's owner class. 
		 * @param field the name of the field. 
		 * @param descriptor use to compute the field's type. 
		 */
		private void getStaticIns(String owner, String field, String descriptor) {
			LocalVariableDeclaration newLocal = createLocal(descriptor);
			Type fieldType = type(descriptor);
			Expression fieldRef = Expression.fieldRef(owner, fieldType, field);
		
			instructions.add(Statement.assign(Variable.localVariable(newLocal.local), fieldRef));

			operandStack.push(new Operand(newLocal));
		}

		/*
		 * Load the value of an instance field into the top 
		 * of the operand stack. The instance object is popped 
		 * from the stack. 
		 * 
		 * @param owner the field's owner class. 
		 * @param field the name of the field. 
		 * @param descriptor use to compute the field's type. 
		 */
		private void getFieldIns(String owner, String field, String descriptor) {
			Immediate instance = operandStack.pop().immediate;
			
			LocalVariableDeclaration newLocal = createLocal(descriptor);
			
			Type fieldType = type(descriptor);
			
			Expression fieldRef = Expression.localFieldRef(((Immediate.c_local)instance).localName, 
					owner, fieldType, field); 
			
			instructions.add(Statement.assign(Variable.localVariable(newLocal.local), fieldRef)); 
			
			operandStack.push(new Operand(newLocal));
		}

		private LocalVariableDeclaration createLocal(String descriptor) {
			return createLocal(type(descriptor));
		}

		private LocalVariableDeclaration createLocal(Type type) {
			String name = "l" + locals++;
			LocalVariableDeclaration local = LocalVariableDeclaration.localVariableDeclaration(type, name);
			auxiliarlyLocalVariables.add(local);
			return local;
		}

	}
}
