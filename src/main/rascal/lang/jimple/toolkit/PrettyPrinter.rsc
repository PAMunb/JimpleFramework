module lang::jimple::toolkit::PrettyPrinter

import lang::jimple::Syntax;
import lang::jimple::core::Context; 


/* 
	Modifiers 
*/
str prettyPrint(Modifier::Public()) = "public";
str prettyPrint(Modifier::Protected()) = "protected";
str prettyPrint(Modifier::Private()) = "private";
str prettyPrint(Modifier::Abstract()) = "abstract";
str prettyPrint(Modifier::Static()) = "static";
str prettyPrint(Modifier::Final()) = "final";
str prettyPrint(Modifier::Strictfp()) = "strictfp";

str prettyPrint(Modifier::Native()) = "native";
str prettyPrint(Modifier::Synchronized()) = "synchronized";
str prettyPrint(Modifier::Transient()) = "transient";
str prettyPrint(Modifier::Volatile()) =  "volatile";

/* 
	Types 
*/

str prettyPrint(Type::TByte()) = "byte";
str prettyPrint(Type::TBoolean()) = "boolean";
str prettyPrint(Type::TShort()) = "short";
str prettyPrint(Type::TCharacter()) = "char";
str prettyPrint(Type::TInteger()) = "int";
str prettyPrint(Type::TFloat()) = "float";
str prettyPrint(Type::TDouble()) = "double";
str prettyPrint(Type::TLong()) = "long";
str prettyPrint(Type::TObject(name)) = name;
str prettyPrint(Type::TVoid()) = "void";

/* 
	Functions for printing ClassOrInterfaceDeclaration and its
	related uper parts.
*/
public str prettyPrint(ClassOrInterfaceDeclaration unit) {
  switch(unit) {
    case classDecl(_,_,_,_,_,_)       : return "class"; 
    case interfaceDecl(_,_,_,_,_) : return "interface";
    default: return "error";
  }   
}

public str prettyPrint(list[Modifier] modifiers) =
 "<for(ms<-modifiers){><prettyPrint(ms)> <}>";

public str prettyPrint(list[Type] interfaces) =
 "<for(ins<-interfaces){><prettyPrint(ins)> <}>";
