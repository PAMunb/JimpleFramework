package lang.jimple.internal;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.impl.persistent.ValueFactory;
import org.junit.Test;

import java.io.File;
import java.io.FileInputStream;

import static org.junit.Assert.assertNotNull;

public class TestVanillaDecompiler {

    @Test
    public void testVanilla() throws Exception {
        File classFile = new File("./target/test-classes/samples/students/Vanilla.class");
        assertNotNull(classFile);

        IValueFactory vf = ValueFactory.getInstance();
        Decompiler decompiler = new Decompiler(vf);
        IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);

        assertNotNull(c);
    }
}
