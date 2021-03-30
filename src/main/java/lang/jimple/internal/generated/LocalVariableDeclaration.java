package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType;
import lombok.*;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;

@Builder
@EqualsAndHashCode
public class LocalVariableDeclaration extends JimpleAbstractDataType {
	@Override
	public String getBaseType() {
		return "LocalVariableDeclaration";
	}

	public Type varType;

	public String local;

	public static LocalVariableDeclaration localVariableDeclaration(Type varType, String local) {
		return new LocalVariableDeclaration(varType, local);
	}

	public LocalVariableDeclaration(Type varType, String local) {

		this.varType = varType;

		this.local = local;

	}

	@Override
	public IConstructor createVallangInstance(IValueFactory vf) {

		IValue iv_varType = varType.createVallangInstance(vf);

		IValue iv_local = vf.string(local);

		return vf.constructor(getVallangConstructor()

				, iv_varType

				, iv_local

		);
	}

	@Override
	public String getConstructor() {
		return "localVariableDeclaration";
	}

}