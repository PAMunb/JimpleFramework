package lang.jimple.internal;


import static lang.jimple.internal.JimpleVallangInterface._classConstructor;
import static lang.jimple.internal.JimpleVallangInterface.fieldConstructor;
import static lang.jimple.internal.JimpleVallangInterface.methodConstructor;
import static lang.jimple.internal.JimpleVallangInterface.modifiers;
import static lang.jimple.internal.JimpleVallangInterface.objectConstructor;
import static lang.jimple.internal.JimpleVallangInterface.type;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.objectweb.asm.ClassReader;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.Opcodes;
import org.objectweb.asm.tree.ClassNode;
import org.objectweb.asm.tree.MethodNode;
import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;
import org.rascalmpl.uri.URIResolverRegistry;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;

/**
 * Decompiler used to convert Java byte code into 
 * Jimple representation. 
 * 
 * @author rbonifacio
 */
public class Decompiler {
	private final IValueFactory vf;
	private IConstructor _class;

	public Decompiler(IValueFactory vf) {
		this.vf = vf;
	}

	public IValue foo() {
		return vf.string("foo");
	}

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

	class GenerateJimpleClassVisitor extends ClassVisitor {
		
		
		private ClassNode cn; 
		private int classModifiers; 
		private String name;
		private String superClass;
		private String[] interfaces;
		private IList fields; 
		private IList methods; 

		public GenerateJimpleClassVisitor(ClassNode cn) {
			super(Opcodes.ASM4);
			this.cn = cn; 
		}

		@Override
		public void visit(int version, int access, String name, String signature, String superClass,
				String[] interfaces) {
			this.classModifiers = access;
			this.name = name;
			this.superClass = superClass;
			this.interfaces = interfaces;
			this.fields = vf.list();
			this.methods = vf.list();
		}

		
		@Override
		public void visitEnd() {
			Map<String, IValue> params = new HashMap<>();
			
			if(superClass != null) {
				params.put("super", objectConstructor(vf, superClass));
			}
			
			IList list = vf.list();
			
			if(interfaces != null) {
				for(String anInterface: interfaces) {
					list = list.append(objectConstructor(vf, anInterface));
				}
			}
			
			Iterator it = cn.methods.iterator();
			
			while(it.hasNext()) {
				visitMethod((MethodNode)it.next());
			}
			
			params.put("interfaces", list);
			params.put("modifiers", modifiers(vf, classModifiers));
			params.put("fields", fields);
			params.put("methods", methods);
			
			_class = vf.constructor(_classConstructor, objectConstructor(vf, name))
					.asWithKeywordParameters()
					.setParameters(params);
		}
		
		private void visitMethod(MethodNode mn) {
			Map<String, IValue> params = new HashMap<>();
			
			IList methodModifiers = modifiers(vf, mn.access);
			IConstructor methodReturnType = type(vf, org.objectweb.asm.Type.getReturnType(mn.desc).getDescriptor());
			IString methodName = vf.string(mn.name);
			IList methodFormalArgs = vf.list(); 
			
			for(org.objectweb.asm.Type t: org.objectweb.asm.Type.getArgumentTypes(mn.desc)) {
				methodFormalArgs = methodFormalArgs.append(type(vf, t.getDescriptor()));
			}
			
			params.put("modifiers", methodModifiers);
			params.put("formals", methodFormalArgs);
			
			methods = methods.append(methodConstructor(vf, methodReturnType, methodName)
					.asWithKeywordParameters()
					.setParameters(params)); 
		}

		@Override
		public FieldVisitor visitField(int access, String name, String descriptor, String signature, Object value) {
			Map<String, IValue> params = new HashMap<>();
			
			IString fieldName = vf.string(name);
			IList fieldModifiers = modifiers(vf, access);
			IConstructor type = type(vf, descriptor);

			params.put("modifiers", fieldModifiers);
			
			// TODO: what should we do with the attribute signature an
			//       value??? 			
			this.fields = fields.append(fieldConstructor(vf, type, fieldName)
					.asWithKeywordParameters()
					.setParameters(params));
			
			return super.visitField(access, name, descriptor, signature, value);
		}
		
	}

}
