module lang::jimple::tests::TestConstantFolder

import lang::jimple::core::Syntax;
import lang::jimple::decompiler::jimplify::ConstantPropagator;
import lang::jimple::decompiler::jimplify::ConstantFolder;
import lang::jimple::decompiler::jimplify::ProcessLabels; 
import lang::jimple::decompiler::Decompiler; 
import Prelude;

test bool testFoldCasePlus() {

  LocalVariableDeclaration v1 = localVariableDeclaration(TShort(), "$i1");
  LocalVariableDeclaration v2 = localVariableDeclaration(TShort(), "$i2");
  LocalVariableDeclaration v3 = localVariableDeclaration(TShort(), "$i3");
  LocalVariableDeclaration v4 = localVariableDeclaration(TInteger(), "$i4");
  LocalVariableDeclaration v5 = localVariableDeclaration(TShort(), "$i5");
  LocalVariableDeclaration v6 = localVariableDeclaration(TObject("samples.operators.ShortOps"), "r0");
  LocalVariableDeclaration v7 = localVariableDeclaration(TObject("java.io.PrintStream"), "$i6");
  
  list[LocalVariableDeclaration] vars = [v1, v2, v3, v4, v5, v6, v7];  

  Statement s1 = identity("r0","@this",TObject("samples.operators.ShortOps"));             
  Statement s2 = assign(localVariable("$i1"),immediate(iValue(intValue(5)))); // CONSTANT $i1
  Statement s3 = assign(localVariable("$i2"),immediate(iValue(intValue(5)))); // CONSTANT $i2
  Statement s4 = assign(localVariable("$i4"),plus(local("$i1"),local("$i2"))); // THIS WILL BECOME  $i4 = 5 + 5, after folding this value is update to $i4 = 10.
  Statement s5 = assign(localVariable("$i5"),cast(TShort(),local("$i4")));
  Statement s6 = assign(localVariable("$i3"),immediate(local("$i5")));                            
  Statement s7 = assign(localVariable("$i6"),fieldRef("java.lang.System",TObject("java.io.PrintStream"),"out"));              
  Statement s8 = invokeStmt(virtualInvoke("$i6",
              methodSignature(
                "java.io.PrintStream",
                TVoid(),
                "println",
                [TInteger()]),
              [local("$i3")]));
              
  Statement s9 = returnEmptyStmt();

  list[Statement] body = [s1, s2, s3, s4, s5, s6, s7, s8, s9];

  MethodBody b = methodBody(vars, body, []);
  
  m =  method([Public()],TVoid(),"addition",[],[],b);
  
  c = classDecl(TObject("samples.operators.ShortOps"),[Public()],TObject("java.lang.Object"),[],[],[m]);    	

  c = processJimpleLabels(c);
  
  c = processConstantPropagator(c);
  
  c = top-down visit(c){
  	case methodBody(ls, ss, cs) => processConstantFolding(methodBody(ls, ss, cs))
  }
  
  bool eval = false;
  top-down visit(c) {
    case assign(localVariable("$i4"),immediate(iValue(intValue(10)))) : eval = true;
  }

  return eval == true;
}