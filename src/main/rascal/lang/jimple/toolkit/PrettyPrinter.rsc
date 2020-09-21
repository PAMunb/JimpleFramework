module lang::jimple::toolkit::PrettyPrinter

import lang::jimple::Syntax;
import lang::jimple::core::Context; 
import List;
import IO;

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
	related upper parts.
*/
public str prettyPrint(list[Modifier] modifiers) {
  str text = "";
  switch(modifiers) {
    case [] :  text = ""; 
    case [v] : text = prettyPrint(v); 
    case [v, *vs] : text = prettyPrint(v) + " " + prettyPrint(vs);
  }
  return text;
}

public str prettyPrint(list[Type] interfaces) {
  str text = "";
  switch(interfaces) {
    case [] :  text = ""; 
    case [v] : text = "implements " + prettyPrint(v); 
    case [v, *vs] : text = "implements " + prettyPrint(v) + " " + prettyPrint(vs);
  }
  return text;
}

/*
public str prettyPrint(list[Type] interfaces) =
 "<for(ins<-interfaces){><prettyPrint(ins)> <}>";
*/

public str prettyPrint(ClassOrInterfaceDeclaration unit) {
  switch(unit) {
    case classDecl(n,ms,super,infs,_,_): 
    	return 
			"<prettyPrint(ms)> class <prettyPrint(n)> extends <prettyPrint(super)> <prettyPrint(infs)>
			'{
			'}
			";    	 
    case interfaceDecl(n,ms,infs,_,_):
    	return
			"<prettyPrint(ms)> interface <prettyPrint(n)> extends <prettyPrint(infs)>
			'{
			'}
			";    	 
    default: return "error";
  }   
}

/*
	Class or interface format:
		modifiers "class" typeName "extends" superClass  | "implements" interfaces | { }
		modifiers "interface" typeName "extends" superClass { }	
	Example code:
		rascal>ClassOrInterfaceDeclaration x = classDecl(TObject("samples.Test"), [Public()], TObject("java.util.List"), [], [], []);
		rascal>prettyPrint(x);
*/
public void samplerun() {
	class1 = classDecl(TObject("samples.MyArrayListTest"), [Public(), Static()], TObject("java.util.List"), [], [], []);
	class2 = classDecl(TObject("samples.MyObjectTest"), [Private(), Static()], object(), [], [], []);
	inf1 = interfaceDecl(TObject("samples.IObject"), [Private(), Static()], [object(), TObject("java.lang.ArrayList")], [], []);	
	inf2 = interfaceDecl(TObject("samples.IObject"), [Public(), Final()], [object()], [], []);	
	writeFile(|file:///tmp/class1.jimple|, prettyPrint(class1));	
	writeFile(|file:///tmp/class2.jimple|, prettyPrint(class2));	
	writeFile(|file:///tmp/inf1.jimple|, prettyPrint(inf1));	
	writeFile(|file:///tmp/inf2.jimple|, prettyPrint(inf2));	
}
