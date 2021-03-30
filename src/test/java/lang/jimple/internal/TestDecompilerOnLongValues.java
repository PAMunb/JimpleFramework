package lang.jimple.internal;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

import java.io.File;
import java.io.FileInputStream;

import org.junit.Test;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.impl.persistent.ValueFactory;

public class TestDecompilerOnLongValues {

	@Test
	public void decompileInterface() {
		try {
			File classFile = new File("./target/test-classes/samples/LongValueSample.class");
			assertNotNull(classFile);

			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);

			assertNotNull(c);
		} catch (Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
}
