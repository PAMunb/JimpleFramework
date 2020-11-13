module lang::jimple::tests::TestSignatureAsString

import lang::jimple::core::Syntax; 
import lang::jimple::util::Converters;

MethodSignature sig01 = methodSignature("lang.jimple.Method", TObject("java.lang.String"), "signature", [TObject("java.lang.String")]); 
MethodSignature sig02 = methodSignature("java.util.List", TInteger(), "size", []); 
MethodSignature sig03 = methodSignature("java.lang.String", TObject("java.lang.String"), "replace", [TObject("java.lang.String"), TObject("java.lang.String"), TInteger()]); 

test bool testSig01() = "lang.jimple.Method.signature(java.lang.String)" == signature(sig01); 

test bool testSig02() = "java.util.List.size()" == signature(sig02); 

test bool testSig03() = "java.lang.String.replace(java.lang.String,java.lang.String,int)" == signature(sig03);
