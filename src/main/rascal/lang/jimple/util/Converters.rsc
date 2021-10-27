module lang::jimple::util::Converters

import lang::jimple::core::Syntax;
import lang::jimple::util::JPrettyPrinter;  

import String; 
import List; 


public str signature(MethodSignature sig) = signature(sig.className, sig.methodName, sig.formals); 
public str signature(methodSignature(cn, _, mn, args)) = signature(cn, mn, args); 
public str signature(Name cn, Name mn, list[Type] args) =  "<cn>.<mn>(<intercalate(",", [prettyPrint(arg) | arg <- args])>)";

//public Type getVarType(MethodBody body, str var) = top([t.varType | t <- body.localVariableDecls, t.local == var]);
public Type getVarType(MethodBody body, str var) = top([t | localVariableDeclaration(t, l) <- body.localVariableDecls, l == var]);
