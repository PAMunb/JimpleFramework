package lang.jimple.internal;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

import java.io.File;
import java.io.FileInputStream;

import org.junit.Test;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.impl.persistent.ValueFactory;

public class TestDecompilerSlf4j {

	@Test
	public void testDecompileLoggerFactory() {
		try {
			File classFile = new File("./src/test/resources/iris-core/br/unb/cic/iris/core/Configuration.class");
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
