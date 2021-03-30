package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType;
import lombok.*;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;

@Builder
@EqualsAndHashCode
public class GotoStmt extends JimpleAbstractDataType {
	@Override
	public String getBaseType() {
		return "GotoStmt";
	}

	public String label;

	public static GotoStmt gotoStmt(String label) {
		return new GotoStmt(label);
	}

	public GotoStmt(String label) {

		this.label = label;

	}

	@Override
	public IConstructor createVallangInstance(IValueFactory vf) {

		IValue iv_label = vf.string(label);

		return vf.constructor(getVallangConstructor()

				, iv_label

		);
	}

	@Override
	public String getConstructor() {
		return "gotoStmt";
	}

}