/**
 * This module declares an execution context for 
 * the analysis. Note: this is trully experimental, 
 * and only works as a first attempt to implement a 
 * general framework for running the static analysis. 
 * 
 * @author: rbonifacio
 */ 
module lang::jimple::core::Context

import lang::jimple::Syntax; 
import lang::jimple::Decompiler; 

import io::IOUtil;

import List; 
import String; 

data ClassType = ApplicationClass()
               | LibraryClass()
               | PhantomClass()
               ; 
               
data DeclaredMethod = Method(Method method, bool entryPoint); 
               
data DeclaredClass = Class(ClassOrInterfaceDeclaration, ClassType); 

alias ClassTable = map[Type, DeclaredClass];
alias MethodTable = map[Name, DeclaredMethod];

data ExecutionContext = ExecutionContext(ClassTable ct, MethodTable mt);  

data ClassDecompiler  = Success(ClassOrInterfaceDeclaration) 
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
                  

public &T execute(list[str] classPath, list[str] entryPoints, Analysis[&T] analysis) {
	locations = mapper(classPath, toLocation); 
	return execute(locations, entryPoints, analysis); 
}

public &T execute(list[loc] classPath, list[str] entryPoints, Analysis[&T] analysis) {
	list[ClassDecompiler] classes = loadClasses(classPath);
	
	ClassTable ct  = (n : Class(classDecl(n, ms, s, is, fs, mss), ApplicationClass()) | Success(classDecl(n, ms, s, is, fs, mss)) <- classes);
	
	MethodTable mt =  (n : Method(method(ms, r, n, args, es, b), n in entryPoints) | /method(ms, r, n, args, es, b) <- classes);
		
	return analysis.run(ExecutionContext(ct, mt));
} 

public list[ClassDecompiler] loadClasses([]) = [];
public list[ClassDecompiler] loadClasses([c, *cs]) 
  = mapper(findClassFiles(c), safeDecompile) + loadClasses(cs); 

public list[loc] findClassFiles(str classPathEntry) = findAllFiles(toLocation(classPathEntry), "class");
public list[loc] findClassFiles(loc location) = findAllFiles(location, "class");

public loc toLocation(str c) { 
  if(endsWith(c, ".jar")) return |jar:///| + c + "!" ; 
  else return |file:///| + c;
}