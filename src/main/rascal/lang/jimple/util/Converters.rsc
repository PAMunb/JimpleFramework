module lang::jimple::util::Converters

import String; 
import List; 

import lang::jimple::Syntax; 
import lang::jimple::toolkit::PrettyPrinter;

public str signature(methodSignature(cn, _, mn, args)) = signature(cn, mn, args); 
public str signature(Name cn, Name mn, list[Type] args) =  "<cn>.<mn>(<intercalate(",", [prettyPrint(arg) | arg <- args])>)";
