package lang.jimple.internal;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.impl.fast.ValueFactory;
import io.usethesource.vallang.type.Type;
import io.usethesource.vallang.type.TypeFactory;
import io.usethesource.vallang.type.TypeStore;

public abstract class AbstractJimpleConstructor {
	
	public static TypeStore typestore = new TypeStore();
	public static TypeFactory tf = TypeFactory.getInstance();
	
	protected Type getVallangType() {
		return tf.abstractDataType(typestore, getBaseType());
	}
	
	protected Type getVallangConstructor() {
		return tf.constructor(typestore, getVallangConstructor(), getConstructor());
	}
	
	public abstract String getBaseType();
	public abstract String getConstructor();
	public abstract IConstructor createVallangInstance(ValueFactory vf); 

}
