module lang::jimple::tests::TestJimpleParser

import ParseTree; 

import lang::jimple::core::ConcreteSyntax; 
import lang::jimple::core::Syntax; 


test bool testModifierParsers() {
  m1 = implode(#Modifier, parse(#JimpleModifier, "public")); 
  m2 = implode(#Modifier, parse(#JimpleModifier, "protected"));
  m3 = implode(#Modifier, parse(#JimpleModifier, "private")); 
  m4 = implode(#Modifier, parse(#JimpleModifier, "abstract"));
  m5 = implode(#Modifier, parse(#JimpleModifier, "static")); 
   
  return m1 == Public()    && 
         m2 == Protected() && 
         m3 == Private()   &&
         m4 == Abstract()  && 
         m5 == Static(); 
}

test bool testTypeParsers() {
  b1 = implode(#Type, parse(#JimpleType, "byte"));
  b2 = implode(#Type, parse(#JimpleType, "boolean")); 
  s1 = implode(#Type, parse(#JimpleType, "short"));
  c1 = implode(#Type, parse(#JimpleType, "BaseClass"));
  c2 = implode(#Type, parse(#JimpleType, "java.lang.String"));
  
  return b1 == TByte() &&
         b2 == TBoolean() &&
         s1 == TShort()   &&
         c1 == TObject("BaseClass") && 
         c2 == TObject("java.lang.String"); 
}

test bool testFieldParser() {
   f = implode(#Field, parse(#JimpleField, "private static final int VALUE;"));
   return f == field([Private(), Static(), Final()], TInteger(), "VALUE");
}

test bool testSignatureOnlyMethodParser() {
   methodDecl1 = "public static void init();";
   methodDecl2 = "public static void init(int);";
   methodDecl3 = "public static void init(java.lang.String, Boolean);";
   methodDecl4 = "public static void init() throws IOException, SQLException;";
   
   methodAST1 = implode(#Method, parse(#JimpleMethod, methodDecl1));
   methodAST2 = implode(#Method, parse(#JimpleMethod, methodDecl2));
   methodAST3 = implode(#Method, parse(#JimpleMethod, methodDecl3));
   methodAST4 = implode(#Method, parse(#JimpleMethod, methodDecl4));
   
   return methodAST1 == method([Public(), Static()], TVoid(), "init", [], [], signatureOnly()) &&
          methodAST2 == method([Public(), Static()], TVoid(), "init", [TInteger()], [], signatureOnly()) &&
          methodAST3 == method([Public(), Static()], TVoid(), "init", [TObject("java.lang.String"), TObject("Boolean")], [], signatureOnly()) &&
          methodAST4 == method([Public(), Static()], TVoid(), "init", [], [TObject("IOException"), TObject("SQLException")], signatureOnly())
          ;
}

test bool testClassDeclarationParser() {
  code = "public class Iterator extends java.lang.Object implements ABC {
         '  private int foo;  
         '  private Blah blah;
         '  public static void init();
         '}";  
  
  parseTree = parse(#JimpleClassOrInterfaceDeclaration, code);
  
  c = implode(#ClassOrInterfaceDeclaration, parseTree); 
  
  return c.classType   == TObject("Iterator")    && 
         c.modifiers   == [Public()]          && 
         c.superClass  == object()            && 
         c.interfaces  == [TObject("ABC")];                             
}


test bool testInterfaceDeclarationParser() {
  code = "public interface Iterator extends ABC, DEF {
         '  private int foo;  
         '  private Blah blah;
         '  public static void init();
         '}";  
  ;  
  
  parseTree = parse(#JimpleClassOrInterfaceDeclaration, code);
  
  c = implode(#ClassOrInterfaceDeclaration, parseTree); 
  
  return c.interfaceType   == TObject("Iterator")    && 
         c.modifiers       == [Public()]          && 
         c.interfaces      == [TObject("ABC"), TObject("DEF")];                             
}