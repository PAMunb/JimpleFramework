package lang.jimple.internal;

import org.objectweb.asm.Opcodes;
import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.Type;
import io.usethesource.vallang.type.TypeFactory;
import io.usethesource.vallang.type.TypeStore;

public class JimpleVallangInterface {

	public static TypeStore typestore = new TypeStore();
	public static TypeFactory tf = TypeFactory.getInstance();

	// Jimple AST types
	public static Type _classOrInterface = tf.abstractDataType(typestore, "ClassOrInterfaceDeclaration");
	public static Type _field = tf.abstractDataType(typestore, "Field");
	public static Type _method = tf.abstractDataType(typestore, "Method");
	public static Type _methodBody = tf.abstractDataType(typestore, "MethodBody");
	public static Type _type = tf.abstractDataType(typestore, "Type");
	public static Type _modifier = tf.abstractDataType(typestore, "Modifier");

	// Jimple AST constructors
	public static Type _classConstructor = tf.constructor(typestore, _classOrInterface, "class", _type, "type");
	public static Type _fieldConstructor = tf.constructor(typestore, _field, "field", _type, "type", tf.stringType(), "name");
	public static Type _methodConstructor = tf.constructor(typestore, _method, "method", _type, "type", tf.stringType(), "name");
	
	public static Type _byteConstructor = tf.constructor(typestore, _type, "byte");
	public static Type _booleanConstructor = tf.constructor(typestore, _type, "boolean");
	public static Type _shortConstructor = tf.constructor(typestore, _type, "short");
	public static Type _characterConstructor = tf.constructor(typestore, _type, "character");
	public static Type _integerConstructor = tf.constructor(typestore, _type, "integer");
	public static Type _floatConstructor = tf.constructor(typestore, _type, "float");
	public static Type _doubleConstructor = tf.constructor(typestore, _type, "double");
	public static Type _longConstructor = tf.constructor(typestore, _type, "long");
	public static Type _objectConstructor = tf.constructor(typestore, _type, "object", tf.stringType(), "name");
	public static Type _arrayConstructor = tf.constructor(typestore, _type, "array", _type, "arg");
	public static Type _voidConstructor = tf.constructor(typestore, _type, "void");
	public static Type _stringConstructor = tf.constructor(typestore, _type, "string");
	public static Type _nullTypeConstructor = tf.constructor(typestore, _type, "null_type");
	public static Type _unknownTypeConstructor = tf.constructor(typestore, _type, "unknown");

	public static Type _abstractConstructor = tf.constructor(typestore, _modifier, "Abstract");
	public static Type _finalConstructor = tf.constructor(typestore, _modifier, "Final");
	public static Type _nativeConstructor = tf.constructor(typestore, _modifier, "Native");
	public static Type _publicConstructor = tf.constructor(typestore, _modifier, "Public");
	public static Type _privateConstructor = tf.constructor(typestore, _modifier, "Private");
	public static Type _protectedConstructor = tf.constructor(typestore, _modifier, "Protected");
	public static Type _staticConstructor = tf.constructor(typestore, _modifier, "Static");
	public static Type _synchronizedConstructor = tf.constructor(typestore, _modifier, "Synchronized");
	public static Type _transientConstructor = tf.constructor(typestore, _modifier, "Transient");
	public static Type _volatileConstructor = tf.constructor(typestore, _modifier, "Volatile");
	public static Type _strictfpConstructor = tf.constructor(typestore, _modifier, "Strictfp");
	public static Type _enumConstructor = tf.constructor(typestore, _modifier, "Enum");
	public static Type _annotationConstructor = tf.constructor(typestore, _modifier, "Annotation");
	
	public static IConstructor objectConstructor(IValueFactory vf, String name) {
		return vf.constructor(_objectConstructor, vf.string(name.replace("/", ".")));
	}
	
	public static IConstructor fieldConstructor(IValueFactory vf, IConstructor type, IString name) {
		return vf.constructor(_field, type, name);
	}
	
	public static IConstructor methodConstructor(IValueFactory vf, IConstructor type, IString name) {
		return vf.constructor(_method, type, name); 
	}
	
	public static IConstructor arrayConstructor(IValueFactory vf, IConstructor baseType) {
		return vf.constructor(_arrayConstructor, baseType); 
	}
	
	public static IConstructor type(IValueFactory vf, String descriptor) {
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
			return objectConstructor(vf, objectName);
		}
		else if(descriptor.startsWith("[")) {  // array types 
			String baseType = descriptor.substring(0, descriptor.length());				
			return arrayConstructor(vf, type(vf, baseType));	
		}
		
		throw RuntimeExceptionFactory.illegalArgument(vf.string(descriptor), null, null);
		// TODO: perhaps we should not throw an exception here,	
		//       and then return "unknown type"
	}

	public static IList modifiers(IValueFactory vf, int access) {
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
