/**
 * This module declares an execution context for 
 * the analysis. Note: this is trully experimental, 
 * and only works as a first attempt to implement a 
 * general framework for running the static analysis. 
 *
 * This code is trully experimental. We expect a lot of 
 * changes in its design. For instance, the name Context 
 * does not see the most suitable anymore. 
 * 
 * @author: rbonifacio, phtcosta, fcarvalho, and others. 
 */ 
module lang::jimple::core::Context

import lang::jimple::core::Syntax; 
import lang::jimple::decompiler::Decompiler; 
import lang::jimple::decompiler::jimplify::ProcessLabels;
import lang::jimple::decompiler::jimplify::FixStmtMethodSignature;
import lang::jimple::decompiler::jimplify::FixStmtId;
import lang::jimple::decompiler::jimplify::ConstantPropagator;
import lang::jimple::util::Converters;
import lang::jimple::util::IO;

import List; 
import String; 
import IO;

alias CID = ClassOrInterfaceDeclaration; 

data ClassType = ApplicationClass()
               | LibraryClass()
               | PhantomClass()
               ; 
               
data DeclaredMethod = Method(Method method, bool entryPoint); 
               
data DeclaredClass = Class(ClassOrInterfaceDeclaration dec, ClassType \type); 

alias ClassTable = map[Type, DeclaredClass];
alias MethodTable = map[Name, DeclaredMethod];

data ExecutionContext = ExecutionContext(ClassTable ct, MethodTable mt);  

data ClassDecompiler  = Success(CID) 
                      | Error(str message); 

                      
public ClassDecompiler safeDecompile(loc classFile) {
  try 
    return Success(decompile(classFile)); 
  catch : 
    return Error(classFile.path);
}   
               
/* 
 * The generic definition of an Analysis. 
 * Every analysis must be configured with an 
 * execution context (basically a class table and a 
 * method table) and a function that takes as an 
 * argument the execution context and returns a 
 * value of type T.  
 */ 
data Analysis[&T] = Analysis(&T (ExecutionContext) run);

//TODO not used yet ...
alias Transformation = Analysis[ExecutionContext];

/*
 * Create an ExecutionContext.
 *
 * It decompiles all classes in the <code>classPath</code>, 
 * and builds a class and method tables. We set all methods whose signature 
 * are in the <code>entryPoints</code> as being an "entry point" of 
 * the analysis. 
 *
 * TODO: we should compute the signature of the method before checking if it is 
 * in the <code>entryPoints</code>. 
 */
ExecutionContext createExecutionContext(list[loc] classPath, list[str] entryPoints) = createExecutionContext(classPath, entryPoints, false);
ExecutionContext createExecutionContext(list[loc] classPath, list[str] entryPoints, bool verbose) {
	list[ClassDecompiler] classes = loadClasses(classPath);
	
	errors = [f | Error(f) <- classes]; 
	
	if(verbose) {
		println(errors); 
	}
		
	ClassTable ct  = (n : Class(jimplify(classDecl(ms, n, s, is, fs, mss)), ApplicationClass()) | Success(classDecl(ms, n, s, is, fs, mss)) <- classes);
	ct = ct + (n : Class(jimplify(interfaceDecl(ms, n, is, fs, mss)), ApplicationClass()) | Success(interfaceDecl(ms, n, is, fs, mss)) <- classes);
	
	MethodTable mt = ();

	top-down visit(ct) {
    	case classDecl(_, TObject(cn), _, _, _, mss): mt = mt + toMethodsTable(cn, mss, entryPoints);   
        case interfaceDecl(_, TObject(cn),_, _, mss): mt = mt + toMethodsTable(cn, mss, entryPoints); 
   	}  
	return ExecutionContext(ct, mt);
}

private CID jimplify(CID c) = jimplify([processJimpleLabels, fixSignature, fixSignature], c); 

private CID jimplify(list[CID (CID)] fs, CID c) { 
  switch(fs) {
    case [h, *t]: return jimplify(t, h(c));
    default: return c; 
  }
} 

private map[Name, DeclaredMethod] toMethodsTable(Name cn, list[Method] methods, list[str] entryPoints) {
	return (signature(cn, mn, args) : Method(method(ms, r, mn, args, es, b), signature(cn, mn, args) in entryPoints) | /method(ms, r, mn, args, es, b) <- methods);
}

/*
 * This is our current execution framework. 
 *
 * It first creates an ExecutionContext. Then, it executes the analysis 
 * considering the resulting execution context. 
 * 
 */
public &T execute(list[loc] classPath, list[str] entryPoints, Analysis[&T] analysis) = execute(classPath, entryPoints, analysis, false); 
public &T execute(list[loc] classPath, list[str] entryPoints, Analysis[&T] analysis, bool verbose) {
	ExecutionContext ctx = createExecutionContext(classPath, entryPoints, verbose);
		
	return analysis.run(ctx);
} 

/* Instead of using a list of locations, the execute function 
 * also works when we define the <code>classPath</code>
 * as a list of strings.  
 */
public &T execute(list[str] classPath, list[str] entryPoints, Analysis[&T] analysis) = execute(classPath, entryPoints, analysis, false);
public &T execute(list[str] classPath, list[str] entryPoints, Analysis[&T] analysis, bool verbose) {
	locations = mapper(classPath, toLocation); 
	bool r1 = verbose;
	return execute(locations, entryPoints, analysis, r1); 
}

/* some auxiliarly functions to load all classes on a given class path */ 
public list[ClassDecompiler] loadClasses([]) = [];
public list[ClassDecompiler] loadClasses([c, *cs]) = mapper(findClassFiles(c), safeDecompile) + loadClasses(cs); 

public list[loc] findClassFiles(str classPathEntry) = findAllFiles(toLocation(classPathEntry), "class");
public list[loc] findClassFiles(loc location) = findAllFiles(location, "class");

public loc toLocation(str c) { 
  	if(endsWith(c, ".jar")) return |jar:///| + c + "!" ; 
  	else return |file:///| + c;
}
