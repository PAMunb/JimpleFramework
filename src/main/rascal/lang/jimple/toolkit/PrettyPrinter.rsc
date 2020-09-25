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
str prettyPrint(Modifier::Enum()) =  "enum";
str prettyPrint(Modifier::Annotation()) =  "annotation";

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
str prettyPrint(TArray(baseType)) = "<prettyPrint(baseType)>[]"; 
str prettyPrint(Type::TVoid()) = "void";


/* 
 * Statements
 */

str prettyPrint(Statement::breakpoint()) = "breakpoint";
str prettyPrint(Statement::gotoStmt(Label target)) = "goto <target>";
str prettyPrint(Statement::label(Label label)) = "<label>";
str prettyPrint(Statement::returnEmptyStmt()) = "return";
str prettyPrint(Statement::nop()) = "nop";


/* 
 * Expression
 */
str prettyPrint(Expression::newInstance(Type instanceType)) = "new <prettyPrint(instanceType)>";

/* 
 * Value
 */

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
    case [v, *vs] : text = "implements " + prettyPrint(v) + ", " + prettyPrint(vs);
  }
  return text;
}

public str prettyPrint(Field f: field(modifiers, fieldType, name)) = 
	"<for(m <- modifiers){><prettyPrint(m)> <}><prettyPrint(fieldType)> <name>;";	

public str prettyPrint(list[Field] fields) =
	"<for(f <- fields) {>
	'    <prettyPrint(f)><}>";

/*
public str prettyPrint(list[Type] interfaces) =
 "<for(ins<-interfaces){><prettyPrint(ins)> <}>";
*/

public str prettyPrint(ClassOrInterfaceDeclaration unit) {
  switch(unit) {
    case classDecl(n,ms,super,infs,fields,_): 
    	return 
			"<prettyPrint(ms)> class <prettyPrint(n)> extends <prettyPrint(super)> <prettyPrint(infs)>
    		'{ 
    		'<prettyPrint(fields)>
    		'
			'}";
    case interfaceDecl(n,ms,infs,fields,_):
    	return
			"<prettyPrint(ms)> interface <prettyPrint(n)> extends <prettyPrint(infs)>
			'{
        	'<prettyPrint(fields)>    			
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

