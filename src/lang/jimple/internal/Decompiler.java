package lang.jimple.internal;

	
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
import io.usethesource.vallang.type.Type;
import io.usethesource.vallang.type.TypeFactory;
import io.usethesource.vallang.type.TypeStore;

/**
 * Decompiler used to convert byte code into Jimple
 * 
 * @author rbonifacio
 */
public class Decompiler {
	private final IValueFactory vf;
	private IConstructor _class;

	private static TypeStore typestore = new TypeStore();
	private static TypeFactory tf = TypeFactory.getInstance();

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
		// Jimple AST types
		Type _classOrInterface = tf.abstractDataType(typestore, "ClassOrInterfaceDeclaration");
		Type _field = tf.abstractDataType(typestore, "Field");
		Type _method = tf.abstractDataType(typestore, "Method");
		Type _type = tf.abstractDataType(typestore, "Type");
		Type _modifier = tf.abstractDataType(typestore, "Modifier");
		
		
		// Jimple AST constructors 
		Type _classConstructor = tf.constructor(typestore, _classOrInterface, "class", _type, "type");
		Type _fieldConstructor = tf.constructor(typestore,_field,"field",_type,"type",tf.stringType(),"name");
		Type _methodConstructor = tf.constructor(typestore,_method,"method",_type,"type",tf.stringType(),"name");
		
		Type _byteConstructor = tf.constructor(typestore, _type, "byte");
		Type _booleanConstructor = tf.constructor(typestore, _type, "boolean");
		Type _shortConstructor = tf.constructor(typestore, _type, "short");
		Type _characterConstructor = tf.constructor(typestore, _type, "character");
		Type _integerConstructor = tf.constructor(typestore, _type, "integer");
		Type _floatConstructor = tf.constructor(typestore, _type, "float");
		Type _doubleConstructor = tf.constructor(typestore, _type, "double");
		Type _longConstructor = tf.constructor(typestore, _type, "long");
		Type _objectConstructor = tf.constructor(typestore, _type, "object", tf.stringType(), "name");
		Type _arrayConstructor = tf.constructor(typestore, _type, "array", _type, "arg");
		Type _voidConstructor = tf.constructor(typestore, _type, "void");
		Type _stringConstructor = tf.constructor(typestore, _type, "string");
		Type _nullTypeConstructor = tf.constructor(typestore, _type, "null_type");
		Type _unknownTypeConstructor = tf.constructor(typestore, _type, "unknown");
		
		Type _abstractConstructor = tf.constructor(typestore, _modifier, "Abstract");
		Type _finalConstructor = tf.constructor(typestore, _modifier, "Final");
		Type _nativeConstructor = tf.constructor(typestore, _modifier, "Native");
		Type _publicConstructor = tf.constructor(typestore, _modifier, "Public");
		Type _privateConstructor = tf.constructor(typestore, _modifier, "Private");
		Type _protectedConstructor = tf.constructor(typestore, _modifier, "Protected");
		Type _staticConstructor = tf.constructor(typestore, _modifier, "Static");
		Type _synchronizedConstructor = tf.constructor(typestore, _modifier, "Synchronized");
		Type _transientConstructor = tf.constructor(typestore, _modifier, "Transient");
		Type _volatileConstructor = tf.constructor(typestore, _modifier, "Volatile");
		Type _strictfpConstructor = tf.constructor(typestore, _modifier, "Strictfp");
		Type _enumConstructor = tf.constructor(typestore, _modifier, "Enum");
		Type _annotationConstructor = tf.constructor(typestore, _modifier, "Annotation");
		
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
				params.put("super", objectConstructor(superClass));
			}
			
			IList list = vf.list();
			
			if(interfaces != null) {
				for(String i: interfaces) {
					list = list.append(objectConstructor(i));
				}
			}
			
			Iterator it = cn.methods.iterator();
			
			while(it.hasNext()) {
				visitMethod((MethodNode)it.next());
			}
			
			params.put("interfaces", list);
			params.put("modifiers", modifiers(classModifiers));
			params.put("fields", fields);
			params.put("methods", methods);
			
			_class = vf.constructor(_classConstructor, objectConstructor(name))
					.asWithKeywordParameters()
					.setParameters(params);
		}
		
		private void visitMethod(MethodNode mn) {
			IList methodModifiers = modifiers(mn.access);
			IConstructor methodReturnType = type(org.objectweb.asm.Type.getReturnType(mn.desc).getDescriptor());
			IString methodName = vf.string(mn.name);
			IList methodFormalArgs = vf.list(); 
			
			for(org.objectweb.asm.Type t: org.objectweb.asm.Type.getArgumentTypes(mn.desc)) {
				methodFormalArgs = methodFormalArgs.append(type(t.getDescriptor()));
			}
			
			Map<String, IValue> params = new HashMap<>();
			
			params.put("formals", methodFormalArgs);
			
			methods = methods.append(methodConstructor(methodReturnType, methodName)
					.asWithKeywordParameters()
					.setParameters(params)); 
		}

		@Override
		public FieldVisitor visitField(int access, String name, String descriptor, String signature, Object value) {
			IString fieldName = vf.string(name);
			IList fieldModifiers = modifiers(access);
			IConstructor type = type(descriptor);
			
			// TODO: what should we do with the attribute signature an
			//       value??? 			
			this.fields = fields.append(fieldConstructor(type, fieldName));
			
			return super.visitField(access, name, descriptor, signature, value);
		}
		
		private IConstructor objectConstructor(String name) {
			return vf.constructor(_objectConstructor, vf.string(name.replace("/", ".")));
		}
		
		private IConstructor fieldConstructor(IConstructor type, IString name) {
			return vf.constructor(_field, type, name);
		}
		
		private IConstructor methodConstructor(IConstructor type, IString name) {
			return vf.constructor(_method, type, name); 
		}
		
		private IConstructor arrayConstructor(IConstructor baseType) {
			return vf.constructor(_arrayConstructor, baseType); 
		}
		
		private IConstructor type(String descriptor) {
			// primitive types 
			switch(descriptor) {
			  case "Z" : return vf.constructor(_booleanConstructor); 
			  case "C" : return vf.constructor(_characterConstructor); 
			  case "B" : return vf.constructor(_byteConstructor); 
			  case "S" : return vf.constructor(_shortConstructor); 
			  case "I" : return vf.constructor(_integerConstructor); 
			  case "F" : return vf.constructor(_floatConstructor);
			  case "J" : return vf.constructor(_longConstructor);
			  case "D" : return vf.constructor(_doubleConstructor); 
			  case "V" : return vf.constructor(_voidConstructor);
			  default  : /* do nothing */  
			}
			// object types 
			if(descriptor.startsWith("L")) {
				String objectName = descriptor.substring(1, descriptor.length()-1);
				return objectConstructor(objectName);
			}
			else if(descriptor.startsWith("[")) {  // array types 
				String baseType = descriptor.substring(0, descriptor.length());				
				return arrayConstructor(type(baseType));	
			}
			
			throw RuntimeExceptionFactory.illegalArgument(vf.string(descriptor), null, null);
			// TODO: perhaps we should not throw an exception here,	
			//       and then return "unknown type"
		}

		private IList modifiers(int access) {
			IList list = vf.list();
			
			if((access & Opcodes.ACC_ABSTRACT) != 0) {
				list = list.append(vf.constructor(_abstractConstructor));
			}
			if((access & Opcodes.ACC_FINAL) != 0) {
				list = list.append(vf.constructor(_finalConstructor));
			}
			if((access & Opcodes.ACC_PUBLIC) != 0) {
				list = list.append(vf.constructor(_publicConstructor));
			}
			if((access & Opcodes.ACC_PRIVATE) != 0) {
				list = list.append(vf.constructor(_privateConstructor));
			}
			if((access & Opcodes.ACC_PROTECTED) != 0) {
				list = list.append(vf.constructor(_protectedConstructor));
			}
			if((access & Opcodes.ACC_STATIC) != 0) {
				list = list.append(vf.constructor(_staticConstructor));
			}
			if((access & Opcodes.ACC_SYNCHRONIZED) != 0) {
				list = list.append(vf.constructor(_synchronizedConstructor));
			}
			if((access & Opcodes.ACC_TRANSIENT) != 0) {
				list = list.append(vf.constructor(_transientConstructor));
			}
			if((access & Opcodes.ACC_VOLATILE) != 0) {
				list = list.append(vf.constructor(_volatileConstructor));
			}
			if((access & Opcodes.ACC_STRICT) != 0) {
				list = list.append(vf.constructor(_strictfpConstructor));
			}
			if((access & Opcodes.ACC_ENUM) != 0) {
				list = list.append(vf.constructor(_enumConstructor));
			}
			if((access & Opcodes.ACC_ANNOTATION) != 0) {
				list = list.append(vf.constructor(_annotationConstructor));
			}
			return list;
		}
	}

}
