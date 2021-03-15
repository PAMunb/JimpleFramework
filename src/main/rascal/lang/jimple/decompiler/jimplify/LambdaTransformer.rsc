module lang::jimple::decompiler::jimplify::LambdaTransformer

import lang::jimple::core::Syntax; 

str bootstrapMethod = "bootstrap$"; 

public list[ClassOrInterfaceDeclaration] lambdaTransformer(ClassOrInterfaceDeclaration c) {
  list[ClassOrInterfaceDeclaration] classes = []; 
  
  c = visit(c) {
    case dynamicInvoke(_, bsmArgs, sig, args)=> generateStaticInvokeExp(mh, sig, args)
     when iValue(methodHandle(mh)):= bsmArgs[1] 
  }
  
  classes += c;
  return classes; 
}

private InvokeExp generateStaticInvokeExp(MethodSignature sig1, MethodSignature sig2, list[Immediate] args) {
  MethodSignature sig = methodSignature("<className(sig1)>$<methodName(sig1)>", returnType(sig2), bootstrapMethod, formals(sig2)); 
  
  return staticMethodInvoke(sig, args);
} 

private str className(methodSignature(name, _, _, _)) = name;
private str methodName(methodSignature(_, _, name,_)) = name;
private Type returnType(methodSignature(_, aType, _, _)) = aType; 
private list[Type] formals(methodSignature(_, _, _, formalArgs)) = formalArgs;
