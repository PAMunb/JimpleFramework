module TestConstantFolder

import lang::jimple::core::Syntax;
import lang::jimple::decompiler::jimplify::ConstantFolder;
import lang::jimple::decompiler::jimplify::ProcessLabels; 
import lang::jimple::decompiler::Decompiler; 
import Prelude;

test bool testFold() {
  return true;
}