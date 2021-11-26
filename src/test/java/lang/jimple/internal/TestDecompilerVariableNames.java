package lang.jimple.internal;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

import java.io.File;
import java.io.FileInputStream;

import org.junit.Test;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.impl.persistent.ValueFactory;

public class TestDecompilerVariableNames {

	@Test
	public void decompileClassWithIfStatement() {
		try {
			File classFile = new File("./target/test-classes/samples/pointsto/simple/FooBar.class");
			assertNotNull(classFile);

			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);

			assertNotNull(c);
			
//			System.out.println(">>> c.getName()="+c.getName());
//			System.out.println(">>> c.getType()="+c.getType());
//			System.out.println(">>> c.getClass()="+c.getClass());
//			System.out.println(">>> c.getConstructorType()="+c.getConstructorType());
//			System.out.println(">>> c.getChildrenTypes()="+c.getChildrenTypes());
//			System.out.println(">>> c.getUninstantiatedConstructorType()="+c.getUninstantiatedConstructorType());
//			System.out.println(c.defaultToString());
//			
//			c.iterator().forEachRemaining(i -> System.out.println(i+" :: "+i.getType()));
		} catch (Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}

}
