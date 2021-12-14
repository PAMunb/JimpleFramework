module lang::jimple::util::Converters

import lang::jimple::core::Syntax;
import lang::jimple::util::JPrettyPrinter;  

import String; 
import List; 

public str signature(MethodSignature sig) = signature(sig.className, sig.methodName, sig.formals); 
public str signature(methodSignature(cn, _, mn, args)) = signature(cn, mn, args); 
public str signature(Name cn, Name mn, list[Type] args) =  "<cn>.<mn>(<intercalate(",", [prettyPrint(arg) | arg <- args])>)";

//public Type getVarType(MethodBody body, str var) = top([t.varType | t <- body.localVariableDecls, t.local == var]);
public Type getVarType(Method method, Immediate i) = getVarType(method.body, i.localName);
public Type getVarType(MethodBody body, str var) = top([t | localVariableDeclaration(t, l) <- body.localVariableDecls, l == var]);


/*
 * Retrieves the method signature from the method invocation info.
 */
public MethodSignature getMethodSignature(specialInvoke(_, ms, _)) = ms; 
public MethodSignature getMethodSignature(virtualInvoke(_, ms, _)) = ms; 
public MethodSignature getMethodSignature(interfaceInvoke(_, ms, _)) = ms;
public MethodSignature getMethodSignature(staticMethodInvoke(ms, _)) = ms; 
public MethodSignature getMethodSignature(dynamicInvoke(_,_,ms,_)) = ms; 

public list[Immediate] getArgs(specialInvoke(_, _, args)) = args;
public list[Immediate] getArgs(virtualInvoke(_, _, args)) = args;
public list[Immediate] getArgs(interfaceInvoke(_, _, args)) = args;
public list[Immediate] getArgs(staticMethodInvoke(_, args)) = args;
public list[Immediate] getArgs(dynamicInvoke(_, _, _, args)) = args;

