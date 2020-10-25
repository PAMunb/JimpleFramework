module lang::jimple::util::Converters

import lang::jimple::core::Syntax;
import lang::jimple::util::JPrettyPrinter;  

import String; 
import List; 

public str signature(methodSignature(cn, _, mn, args)) = signature(cn, mn, args); 
public str signature(Name cn, Name mn, list[Type] args) =  "<cn>.<mn>(<intercalate(",", [prettyPrint(arg) | arg <- args])>)";
