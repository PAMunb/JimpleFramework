package lang.jimple.internal;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import org.objectweb.asm.ClassReader;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.Opcodes;
import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;
import org.rascalmpl.uri.URIResolverRegistry;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IListWriter;
import io.usethesource.vallang.ISourceLocation;
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
			reader.accept(new GenerateJimpleClassVisitor(), 0);
			return _class;
		} catch (IOException e) {
			throw RuntimeExceptionFactory.io(vf.string(e.getMessage()), null, null);
		}
	}

	class GenerateJimpleClassVisitor extends ClassVisitor {
		// Jimple AST types
		Type _classOrInterface = tf.abstractDataType(typestore, "ClassOrInterfaceDeclaration");
		Type _type = tf.abstractDataType(typestore, "Type");
		
		// Jimple AST constructors 
		Type _classConstructor = tf.constructor(typestore, _classOrInterface, "class", _type, "type");
		Type _typeConstructor = tf.constructor(typestore, _type, "object", tf.stringType(), "name");
		
		private String name;
		private String superClass;
		private String[] interfaces;

		public GenerateJimpleClassVisitor() {
			super(Opcodes.ASM4);
		}

		@Override
		public void visit(int version, int access, String name, String signature, String superClass,
				String[] interfaces) {
			this.name = name;
			this.superClass = superClass;
			this.interfaces = interfaces;
		}

		@Override
		public void visitEnd() {
			Map<String, IValue> params = new HashMap<>();
			
			if(superClass != null) {
				params.put("super", objectConstructor(superClass));
			}
			
			IListWriter list = vf.listWriter();
			
			if(interfaces != null) {
				for(String i: interfaces) {
					list.append(objectConstructor(i));
				}
			}
			params.put("interfaces", list.done());
			
			_class = vf.constructor(_classConstructor, objectConstructor(name))
					.asWithKeywordParameters()
					.setParameters(params);
		}
		
		private IConstructor objectConstructor(String name) {
			return vf.constructor(_typeConstructor, vf.string(name.replace("/", ".")));
		}
	}

}
