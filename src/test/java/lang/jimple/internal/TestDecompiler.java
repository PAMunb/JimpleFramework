package lang.jimple.internal;

import java.io.File;
import java.io.FileInputStream;

import io.usethesource.vallang.IList;
import org.junit.Test;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.impl.persistent.ValueFactory;

import static org.junit.Assert.*;

public class TestDecompiler {
	@Test
	public void decompileClassWithIfStatement() {
		try {
			File classFile = new File("./target/test-classes/samples/IfStatement.class");
			assertNotNull(classFile);

			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);

			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}


	@Test
	public void decompileClassWithFields() {
		try {
			File classFile = new File("./target/test-classes/samples/ClassWithFields.class"); 
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test 
	public void decompileClassWithSimpleLambdaExpression() {
		try {
			File classFile = new File("./target/test-classes/samples/SimpleLambdaExpression.class"); 
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test 
	public void decompileInterface() {
		try {
			File classFile = new File("./target/test-classes/samples/InterfaceSample.class"); 
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test 
	public void decompileAutoIncrementClass() {
		try {
			File classFile = new File("./target/test-classes/samples/AutoIncrementSample.class"); 
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test 
	public void decompileWhileStmtSampleClass() {
		try {
			File classFile = new File("./target/test-classes/samples/WhileStmtSample.class"); 
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test 
	public void decompileSlf4JMDCClass() {
		try {
			File classFile = new File("./target/test-classes/slf4j/org/slf4j/MDC.class"); 
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test 
	public void decompileNestedInterface() {
		try {
			File classFile = new File("./target/test-classes/samples/NestedInterface.class"); 			
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}	
	
	@Test 
	public void decompileStreamAPI() {
		try {
			File classFile = new File("./target/test-classes/samples/StreamAPI.class"); 			
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}	
	
	@Test 
	public void decompileAndroidClass() {
		try {
			File classFile = new File("./target/test-classes/android-app/oms/wmessage/main.class"); 			
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test
	public void decompileSwitchCaseSample() {
		try {
			File classFile = new File("./target/test-classes/samples/SwitchCaseSample.class"); 			
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test
	public void decompileControlStatements() {
		try {
			File classFile = new File("./target/test-classes/samples/ControlStatements.class"); 			
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test 
	public void decompileImplicitParameter() {
		try {
			File classFile = new File("./target/test-classes/samples/ImplicitParameterSample.class"); 			
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}	
	
	@Test 
	public void decompileIntOpsClassFile() {
		try {
			File classFile = new File("./target/test-classes/samples/operators/IntOps.class"); 			
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
			assertExecuteMethodStmts(c, 17);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}	

	@Test
	public void decompileNewStatementSample() {
		try {
			File classFile = new File("./target/test-classes/samples/NewStatementSample.class"); 			
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test
	public void decompileAdditionalLongValueSample() {
		try {
			File classFile = new File("./target/test-classes/samples/AdditionalLongValueSample.class"); 			
			assertNotNull(classFile);
			
			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);
			
			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}

	@Test
	public void decompileDoWhileStatement() {
		try {
			File classFile = new File("./target/test-classes/samples/controlStatements/DoWhileStatement.class");
			assertNotNull(classFile);

			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);

			assertNotNull(c);
			assertExecuteMethodStmts(c, 15);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}

	@Test
	public void decompileWhileStatement() {
		try {
			File classFile = new File("./target/test-classes/samples/controlStatements/WhileStatement.class");
			assertNotNull(classFile);

			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);

			assertNotNull(c);
			assertExecuteMethodStmts(c, 16);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}

	@Test
	public void decompileStaticBlock() {
		try {
			File classFile = new File("./target/test-classes/samples/controlStatements/StaticBlock.class");
			assertNotNull(classFile);

			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);

			assertNotNull(c);
			assertExecuteMethodStmts(c, 9);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test
	public void decompileQuickSort() {
		try {
			File classFile = new File("./target/test-classes/samples/QuickSort.class");
			assertNotNull(classFile);

			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), null);

			assertNotNull(c);
		}
		catch(Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}
	
	@Test
	public void decompileKeepOriginalVarNames() {
		try {
			File classFile = new File("./target/test-classes/samples/pointsto/simple/FooBar.class");
			assertNotNull(classFile);

			IValueFactory vf = ValueFactory.getInstance();
			Decompiler decompiler = new Decompiler(vf);
			IConstructor c = decompiler.decompile(new FileInputStream(classFile), vf.bool(true), null);

			assertNotNull(c);			
		} catch (Exception e) {
			e.printStackTrace();
			fail(e.getLocalizedMessage());
		}
	}

	private void assertExecuteMethodStmts(IConstructor c, int size) {
		IList methods = (IList) c.get(5);


		IConstructor executeMethod = (IConstructor)methods.get(1);
		IList stmts = (IList) ((IConstructor)executeMethod.get(5)).get(1);
		assertEquals(size, stmts.size());
	}
}
