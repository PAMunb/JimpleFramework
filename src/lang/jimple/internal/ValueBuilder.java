package lang.jimple.internal;

import java.util.ArrayList;
import java.util.List;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IInteger;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IReal;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.Type;
import io.usethesource.vallang.type.TypeFactory;
import io.usethesource.vallang.type.TypeStore;

public class ValueBuilder {
	
	public static TypeStore typestore = new TypeStore();
	public static TypeFactory tf = TypeFactory.getInstance();

	private String type; 
	private String constructor; 
	private List<InternalValue> args; 
	
	/**
	 * Set a new string argument 
	 * 
	 * @param name name of the argument 
	 * @param str value 
	 * @return a new version of the builder
	 */
	public ValueBuilder withStringArgument(String name, IString str) { 
		args.add(new InternalValue(name, new TString(), str)); 
		return this; 
	} 
	
	public ValueBuilder withIntArgument(String name, IInteger iValue) {
		args.add(new InternalValue(name, new TInt(), iValue));
		return this; 
	}
	
	public ValueBuilder withRealArgument(String name, IReal rValue) {
		args.add(new InternalValue(name, new TReal(), rValue));
		return this; 
	}
	
	/**
	 * Set a new argument list. 
	 * 
	 * @param name name of the argument
	 * @param baseType base type of the list (string, int, bool, or an ADT) 
	 * @param values the argument values 
	 * 
	 * @return a new version of the builder 
	 */
	public ValueBuilder withListArgument(String name, String baseType, IList values) { 
		InternalType base; 
		switch(baseType) {
		 case "string" : base = new TString();
		 case "int"    : base = new TInt();
		 case "bool"   : base = new TBool();
		 default       : base = new TAlgebraicDataType(baseType);
		}
		args.add(new InternalValue(name, new TList(base), values)); 
		return this; 
	}
	
	/**
	 * Set a new constructor argument 
	 * @param name name of the argument 
	 * @param baseType name of the algebraic data type 
	 * @param value value of the argument 
	 * 
	 * @return a new version of the builder.
	 */
	public ValueBuilder withConstructorArgument(String name, String baseType, IConstructor value) { 
		args.add(new InternalValue(name, new TAlgebraicDataType(baseType), value));
		return this; 
	}
	
	class InternalValue {
		String name;
		InternalType type; 
		IValue value; 
		public InternalValue(String name, InternalType type, IValue value) {
			this.name = name; 
			this.type = type; 
			this.value = value; 
		}
	}
	
	abstract class InternalType {
		public abstract Type type(); 
	}
	
	class TString extends InternalType {
		public Type type() {
			return tf.stringType();
		}	
	}
	
	class TInt extends InternalType {
		public Type type() {
			return tf.integerType();
		}
	}
	
	class TReal extends InternalType {
		public Type type() {
			return tf.realType();
		}
	}
	
	class TBool extends InternalType {
		public Type type() {
			return tf.boolType();
		}
	}
	
	class TAlgebraicDataType extends InternalType {
		Type type; 
		
		public TAlgebraicDataType(String type) {
			this.type = tf.abstractDataType(typestore, type);
		}
		
		public Type type() {
			return type;
		}
	}
	
	class TList extends InternalType {
		Type type; 
		public TList(InternalType base) {
			this.type = tf.listType(base.type()); 
		}
		
		public Type type() {
			return type;
		}
	}
	
	private ValueBuilder() {
		args = new ArrayList<ValueBuilder.InternalValue>();
	} 
	
	private static ValueBuilder instance; 
	
	public static ValueBuilder instance() {
		instance = new ValueBuilder();
		return instance; 
	}
	
	public ValueBuilder withType(String type) {
		this.type = type;
		return this;
	}
	
	public ValueBuilder withConstructor(String constructor) {
		this.constructor = constructor; 
		return this; 
	}
	
	
	
	public IConstructor build(IValueFactory vf) {
		Type _type = tf.abstractDataType(typestore, type);
		Object[] typesAndLabels = new Object[args.size()*2]; 
		IValue[] values = new IValue[args.size()];
		
		for(int i = 0; i < args.size(); i++) {
			typesAndLabels[i*2] = args.get(i).type.type();
			typesAndLabels[i*2 + 1] = args.get(i).name;
			values[i] = args.get(i).value;
		}
		
		Type _constructor = tf.constructor(typestore, _type, constructor, typesAndLabels);
		
		return vf.constructor(_constructor, values);
	}
	
	
}
