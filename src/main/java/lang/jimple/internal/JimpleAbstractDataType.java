package lang.jimple.internal;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.Type;
import io.usethesource.vallang.type.TypeFactory;
import io.usethesource.vallang.type.TypeStore;

/**
 * This class implements a couple of methods 
 * that help us to instantiate Vallang objects 
 * that match the JIMPLE AST. These (template) methods 
 * actually calls abstract methods that are automatically 
 * generated from the RascalJavaConverter 
 * 
 * @author rbonifacio
 */
public abstract class JimpleAbstractDataType {
	
	public static TypeStore typestore = new TypeStore();
	public static TypeFactory tf = TypeFactory.getInstance();
	
	public Type getVallangType() {
		return tf.abstractDataType(typestore, getBaseType());
	}
	
	public Type getVallangConstructor() {
		return tf.constructor(typestore, getVallangType(), getConstructor(), children());
	}
	
	public abstract String getBaseType();
	public abstract String getConstructor();
	public abstract IConstructor createVallangInstance(IValueFactory vf);
	public abstract Type[] children();

}
