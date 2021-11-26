module lang::jimple::decompiler::internal::RascalJavaConverter

import IO; 
import List;
import String; 

import ParseTree; 
import lang::rascal::\syntax::Rascal; 

/**
 * From a Rascal module, it exports a set 
 * of Java classes corresponding to the Vallang algebraic 
 * data types. 
 * 
 * Status: This implementation is too experimental, and 
 * does not suppor all Rascal structured types (such as map).
 * Nonetheless, we can use it to generate all internal Java 
 * classes that are necessary to decompile Java byte code 
 * into Jimple.  
 */
public void generateJavaCode(loc location) {
  Module m = parse(#Module, location);
  map[str, str] aliases = collectAliases(m); 	
  generateCode(m, aliases);
}

private map[str, str] collectAliases(Module m) {
   map[str, str] aliases = (); 
   top-down visit(m) {
	 case (Declaration)`alias <UserType t> = <Type b>;`: aliases[unparse(t)] = unparse(b);
   }
   return aliases; 
}

private void generateCode(Module m, map[str, str] aliases) {
	top-down visit(m) {
	  case (Declaration)`<Visibility _> data <UserType t> <CommonKeywordParameters commons> = <{Variant "|"}+ variants>;`: generateClass(aliases, t, commons, variants);
	}
}

private void generateClass(map[str, str] aliases, UserType t, CommonKeywordParameters commons, {Variant "|"}+ variants) {
  list[Variant] vs = [v | Variant v <- variants]; 
  str modifier = size(vs) > 1 ? "abstract" : ""; 
  str builder = size(vs) == 1 ? "@Builder" : ""; 
  str code = "package lang.jimple.internal.generated;
             '
             'import lang.jimple.internal.JimpleAbstractDataType; 
             'import java.util.List; 
             'import java.util.HashMap;
             '
             'import lombok.*; 
             '
             'import io.usethesource.vallang.IConstructor;
             'import io.usethesource.vallang.ISourceLocation;
             'import io.usethesource.vallang.IList;
             'import io.usethesource.vallang.IValue;
             'import io.usethesource.vallang.IValueFactory; 
             '
             '/**
             ' * This class has been automatically generated from 
             ' * the JIMPLE AST definitions. It corresponds to a 
             ' * Java representation of the <unparse(t)> construct. 
             ' * 
             ' * @see lang::jimple::core::Syntax
             ' * @see lang::jimple::decompiler::internal::RascalJavaConverter
             ' */ 
             '<builder>
             '@EqualsAndHashCode
             'public <modifier> class <unparse(t)> extends JimpleAbstractDataType {
             '  
             '   @Override 
             '   public String getBaseType() { 
             '     return \"<unparse(t)>\";
             '   } 
             '   <if(size(vs) == 1){>
             '   <generateSingleton(aliases, unparse(t), commons, head(vs))>               
             '   <} else {>
             '   <for(Variant v <- variants) {>
             '   <generateFactory(aliases, unparse(t), commons, v)>
             '   <}> 
             '   <for(Variant v <- variants) {>
             '   <generateSubClass(aliases, unparse(t), commons, v)>
             '   <}> 
             '   <}> 
             '}"; 
  
  str classFileName = unparse(t) + ".java"; 
  writeFile(|project://JimpleFramework/src/main/java/lang/jimple/internal/generated| + classFileName, code);            
}

private str generateFactory(map[str, str] aliases, str base, CommonKeywordParameters commons, Variant v) {
   str code = ""; 
   switch(v) {
     case (Variant)`<Name n>(<{TypeArg ","}* arguments>)` : {
       list[TypeArg] args = [a | TypeArg a <- arguments] + fromCommonArguments(commons); 
       code = "public static <base> <n>(<intercalate(", ", [generateAttribute(aliases, arg, false) | TypeArg arg <- args])>)  {
              '  return new c_<n>(<intercalate(", ", [generateAttributeName(arg) | TypeArg arg <- args])>);
              '}"; 
     }
   }
   return code;  
}

private str generateSingleton(map[str, str] aliases, str base, CommonKeywordParameters commons, Variant v) {
   str code = ""; 
   switch(v) {
     case (Variant)`<Name n>(<{TypeArg ","}* arguments>)` : {
       list[TypeArg] args = [a | TypeArg a <- arguments] + fromCommonArguments(commons); 
       code = "
              ' <for(TypeArg arg <- args){>
              ' <generateAttribute(aliases, arg, true)>;
              ' <}>
              '
              ' public static <base> <n>(<intercalate(", ", [generateAttribute(aliases, arg, false) | TypeArg arg <- args])>)  {
              '   return new <base>(<intercalate(", ", [generateAttributeName(arg) | TypeArg arg <- args])>);
              ' }
              ' 
              ' <generateConstructor(aliases, base, [arg | TypeArg arg <- args])> 
              ' <generateVallangInstance(aliases, [arg | TypeArg arg <- arguments], fromCommonArguments(commons))>
              '
              '
              ' @Override
              ' public io.usethesource.vallang.type.Type[] children() {
              '   return new io.usethesource.vallang.type.Type[] { 
              '       <intercalate(", ", [extractTypeFactoryFromArgument(aliases, arg) | TypeArg arg <- args])>
              '   };
              ' } 
              '
              ' @Override
              ' public String getConstructor() {
              '    return \"<n>\";
              ' }
              '  
              "; 
         }
   }
   return code; 
}

private str generateSubClass(map[str, str] aliases, str base, CommonKeywordParameters commons, Variant v) {
   str code = ""; 
   switch(v) {
     case (Variant)`<Name n>(<{TypeArg ","}* arguments>)` : {
       list[TypeArg] args = [a | TypeArg a <- arguments] + fromCommonArguments(commons); 
       code = "@EqualsAndHashCode
              'public static class c_<n> extends <base> {
              '  <for(TypeArg arg <- args){>
              '  <generateAttribute(aliases, arg, true)>;
              '  <}>
              '  <generateConstructor(aliases, "c_" + unparse(n), [arg | TypeArg arg <- args])> 
              ' 
              '  <generateVallangInstance(aliases, [arg | TypeArg arg <- arguments], fromCommonArguments(commons))>
              '
              '  @Override
              '  public io.usethesource.vallang.type.Type[] children() {
              '    return new io.usethesource.vallang.type.Type[] { 
              '      <intercalate(", ", [extractTypeFactoryFromArgument(aliases, arg) | TypeArg arg <- args])>
              '    };
              '  }
              ' 
              '  @Override
              '  public String getConstructor() {
              '    return \"<n>\";
              '  }
              '}"; 
        }
   }
   return code; 
}

private str generateConstructor(map[str, str] aliases, str cn, list[TypeArg] arguments)  
 = "public <cn>(<intercalate(", ", [generateAttribute(aliases, arg, false) | TypeArg arg <- arguments])>) {
   ' <for(TypeArg arg <-arguments){>
   '   this.<generateAttributeName(arg)> = <generateAttributeName(arg)>;  
   ' <}>  
   '}";
 

private str generateVallangInstance(map[str, str] aliases, list[TypeArg] arguments, list[TypeArg] commons) 
 = "@Override
   'public IConstructor createVallangInstance(IValueFactory vf) {
   '  <for(TypeArg arg <- arguments){>
   '  <populateChildren(aliases, arg, false)>
   '  <}>
   '  
   '  IValue[] children = new IValue[] { 
   '    <intercalate(", ", ["iv_" + generateAttributeName(arg) | arg <- arguments])>   
   '  };
   '
   '  <if(size(commons) > 0) {>
   '  HashMap\<String, IValue\> map = new HashMap\<\>(); 
   '  <for(TypeArg arg <- commons){>
   '  <populateChildren(aliases, arg, true)>
   '  <}>
   '  return vf.constructor(getVallangConstructor(), children, map); 
   '  <} else {>
   '  return vf.constructor(getVallangConstructor(), children);
   '  <}> 
   '}";  
 
private str generateAttribute(map[str, str] aliases, TypeArg arg, bool isPublic) {
  str prefix = isPublic ? "public " : "";  
  switch(arg) {
    case (TypeArg)`<Type t> <Name n>`: return prefix + resolve(aliases, unparse(t)) + " " + unparse(n); 
    default: return ""; 
  } 
}

private str generateAttributeName(TypeArg arg) { 
  switch(arg) {
    case (TypeArg)`<Type _> <Name n>`: return unparse(n); 
    default: return ""; 
  } 
}

private str extractTypeFactoryFromArgument(map[str, str] aliases, TypeArg arg) {
  switch(arg) {
    case (TypeArg)`<Type t> <Name n>`: return callTypeFactory(aliases, t, n);
    default: return ""; 
  } 
}

private str callTypeFactory(map[str, str] aliases, Type t, Name n) {
  str namedType = unparse(t); 
  str field = unparse(n);
  switch(t) {
     case (Type)`str` : return "tf.stringType()"; 
     case (Type)`int` : return "tf.integerType()";
     case (Type)`bool`: return "tf.boolType()";
     case (Type)`real`: return "tf.realType()"; 
     case (Type)`loc` : return "tf.sourceLocationType()";
     case (Type)`list[<TypeArg _>]` : { 
       return "tf.listType(tf.valueType())";
     }
     default: return callTypeFactoryFromUserDefinedType(aliases, namedType, field);
  }
}

private str callTypeFactoryFromUserDefinedType(map[str, str] aliases, str base, str field) {
  switch(resolve(aliases, base)) {
    case "String"  : return "tf.stringType()";
    case "Integer" : return "tf.integerType()";
    case "Boolean" : return "tf.boolType()";
    case "Float"   : return "tf.realType()";
    case "Double"  : return "tf.realType()";
    case "Long"    : return "tf.integerType()";
    default        : return "<field>.getVallangConstructor()"; 
  }
}


private str populateChildren(map[str, str] aliases, TypeArg arg, bool isMap) {
  switch(arg) {
    case (TypeArg)`<Type t> <Name n>`: 
      switch(t) {
        case (Type)`str` : return populateBasicType("str", unparse(n), isMap);
        case (Type)`int` : return populateBasicType("int", unparse(n), isMap);
        case (Type)`bool`: return populateBasicType("bool", unparse(n), isMap);
        case (Type)`real`: return populateBasicType("real", unparse(n), isMap);
        case (Type)`list[<TypeArg base>]`: return populateListType(aliases, unparse(base), unparse(n), isMap); 
        default: return populateUserDefinedType(aliases, unparse(t), unparse(n), isMap); 
      }
    default: {
      println(arg);
      return "error exporting the source code";  
    }
  }
}

private str populateBasicType("str", str n, bool isMap)    { return if(!isMap) "IValue iv_<n> = vf.string(<n>);"; else "map.put(\"<n>\", vf.string(<n>));"; }
private str populateBasicType("int", str n, bool isMap)    { return if(!isMap) "IValue iv_<n> = vf.integer(<n>);"; else "map.put(\"<n>\", vf.integer(<n>));"; }
private str populateBasicType("bool", str n, bool isMap)   { return if(!isMap) "IValue iv_<n> = vf.bool(<n>);"; else "map.put(\"<n>\", vf.bool(<n>));"; }
private str populateBasicType("real", str n, bool isMap)   { return if(!isMap) "IValue iv_<n> = vf.real(<n>);"; else "map.put(\"<n>\", vf.real(<n>));"; }
private str populateBasicType("Double", str n, bool isMap) { return if(!isMap) "IValue iv_<n> = vf.real(<n>);"; else "map.put(\"<n>\", vf.real(<n>));"; }
private str populateBasicType("Long", str n, bool isMap)   { return if(!isMap) "IValue iv_<n> = vf.integer(<n>);"; else "map.put(\"<n>\", vf.integer(<n>));"; }


private str populateUserDefinedType(map[str, str] aliases, str base, str n, bool isMap) {
 str val = ""; 
 switch(resolve(aliases, base)) {
   case "String"  : val = "vf.string(<n>)";
   case "Integer" : val = "vf.integer(<n>)";
   case "Boolean" : val = "vf.boolean(<n>)";
   case "Float"   : val = "vf.real(<n>)";
   case "Double"  : val = "vf.real(<n>)";
   case "Long"    : val = "vf.integer(<n>)";
   default        : val = "<n>.createVallangInstance(vf)"; 
 }
 return if(!isMap) "IValue iv_<n> = <val>;";  else "map.put(\"<n>\", <val>);"; 
}

private str populateListType(map[str, str] aliases, str base, str n, bool isMap) {
 str val = ""; 
 switch(resolve(aliases, base)) {
   case "String"  : val = "vf.string(v)";
   case "Integer" : val = "vf.integer(v)";
   case "Boolean" : val = "vf.boolean(v)";
   case "Float"   : val = "vf.real(v)";
   case "Double"  : val = "vf.real(v)";
   case "Long"    : val = "vf.integer(v)";
   default        : val = "v.createVallangInstance(vf)"; 
 }
 return "IList iv_<n> = vf.list();
        '
        'for(<base> v: <n>) {
        ' iv_<n> = iv_<n>.append(<val>);   
        '}
        '<if(isMap){>
        'map.put(\"<n>\", iv_<n>);
        '<}>
        "; 
}

private str resolve(map[str, str] aliases, str t) {
  // these are two special cases here. 
  // lets do a workaround here, because 
  // we cannot differentiate int and long in Rascal. 
  // the same is true between real and double
  switch(t) {
    case "Long"  : return "Long";
    case "Double": return "Double";  
  } 

  // this is the normal case. 
  if(t in aliases) {
    t = aliases[t]; 
  } 
  if(startsWith(t, "list["))  {
     t = replaceAll(t, "list[", "List\<");
     t = replaceAll(t, "]", "\>"); 
  }
  switch(t) {
    case "str"   : return "String"; 
    case "int"   : return "Integer";
    case "bool"  : return "Boolean";  
    case "real"  : return "Float"; 
    case "loc"   : return "ISourceLocation"; 
    default: return replaceAll(t, "\\", "");
  }
}

list[TypeArg] fromCommonArguments(CommonKeywordParameters commons) {
  list[TypeArg]	res = []; 
  switch(commons) {
    case (CommonKeywordParameters)`(<{KeywordFormal ","}+ args>)`: 
      res = [(TypeArg)`<Type t> <Name n>`| (KeywordFormal)`<Type t> <Name n> = <Expression _>` <- args];
    default: res = []; 
  };
  return res; 
}