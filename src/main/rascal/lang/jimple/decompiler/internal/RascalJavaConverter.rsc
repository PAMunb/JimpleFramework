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
	  case (Declaration)`<Visibility _> data <UserType t> = <{Variant "|"}+ variants>;`: generateClass(aliases, t, variants);
	}
}

private void generateClass(map[str, str] aliases, UserType t, {Variant "|"}+ variants) {
  list[Variant] vs = [v | Variant v <- variants]; 
  str modifier = size(vs) > 1 ? "abstract" : ""; 
  str builder = size(vs) == 1 ? "@Builder" : ""; 
  str code = "package lang.jimple.internal.generated;
             '
             'import lang.jimple.internal.JimpleAbstractDataType; 
             'import java.util.List; 
             '
             'import lombok.*; 
             '
             'import io.usethesource.vallang.IConstructor;
             'import io.usethesource.vallang.IList;
             'import io.usethesource.vallang.IValue;
             'import io.usethesource.vallang.IValueFactory; 
             '
             '<builder>
             '@EqualsAndHashCode
             'public <modifier> class <unparse(t)> extends JimpleAbstractDataType {
             '   @Override 
             '   public String getBaseType() { 
             '     return \"<unparse(t)>\";
             '   } 
             '
             '   <if(size(vs) == 1){>
             '     <generateSingleton(aliases, unparse(t), head(vs))>               
             '   <} else {>
             '   <for(Variant v <- variants) {>
             '   <generateFactory(aliases, unparse(t), v)>
             '   <}> 
             '
             '   <for(Variant v <- variants) {>
             '   <generateSubClass(aliases, unparse(t), v)>
             '   <}> 
             '   <}> 
             '}"; 
  
  str classFileName = unparse(t) + ".java"; 
  writeFile(|project://JimpleFramework/src/main/java/lang/jimple/internal/generated| + classFileName, code);            
}

private str generateFactory(map[str, str] aliases, str base, Variant v) {
   str code = ""; 
   switch(v) {
     case (Variant)`<Name n>(<{TypeArg ","}* arguments>)` : 
       code = "public static <base> <n>(<intercalate(", ", [generateAttribute(aliases, arg, false) | TypeArg arg <- arguments])>)  {
              '  return new c_<n>(<intercalate(", ", [generateAttributeName(arg) | TypeArg arg <- arguments])>);
              '}"; 
   }
   return code;  
}

private str generateSingleton(map[str, str] aliases, str base, Variant v) {
   str code = ""; 
   switch(v) {
     case (Variant)`<Name n>(<{TypeArg ","}* arguments>)` : 
       code = "
              ' <for(TypeArg arg <- arguments){>
              '  <generateAttribute(aliases, arg, true)>;
              ' <}>
              '
              ' public static <base> <n>(<intercalate(", ", [generateAttribute(aliases, arg, false) | TypeArg arg <- arguments])>)  {
              '   return new <base>(<intercalate(", ", [generateAttributeName(arg) | TypeArg arg <- arguments])>);
              ' }
              ' 
              ' <generateConstructor(aliases, base, [arg | TypeArg arg <- arguments])> 
              ' <generateVallangInstance(aliases, [arg | TypeArg arg <- arguments])>
              '
              ' @Override
              ' public String getConstructor() {
              '    return \"<n>\";
              ' }
              '  
              "; 
   }
   return code; 
}

private str generateSubClass(map[str, str] aliases, str base, Variant v) {
   str code = ""; 
   switch(v) {
     case (Variant)`<Name n>(<{TypeArg ","}* arguments>)` : 
       code = "@EqualsAndHashCode
              'public static class c_<n> extends <base> {
              '  <for(TypeArg arg <- arguments){>
              '  <generateAttribute(aliases, arg, true)>;
              '  <}>
              '
              '  <generateConstructor(aliases, "c_" + unparse(n), [arg | TypeArg arg <- arguments])> 
              '  
              '  <generateVallangInstance(aliases, [arg | TypeArg arg <- arguments])>
              '
              '  @Override
              '  public String getConstructor() {
              '    return \"<n>\";
              '  }
              '}"; 
   }
   return code; 
}

private str generateConstructor(map[str, str] aliases, str cn, list[TypeArg] arguments)  
 = "  public <cn>(<intercalate(", ", [generateAttribute(aliases, arg, false) | TypeArg arg <- arguments])>) {
   '   <for(TypeArg arg <-arguments){>
   '     this.<generateAttributeName(arg)> = <generateAttributeName(arg)>;  
   '   <}>  
   '  }";
 

private str generateVallangInstance(map[str, str] aliases, list[TypeArg] arguments) 
 = "@Override
   'public IConstructor createVallangInstance(IValueFactory vf) {
   '
   '  <for(TypeArg arg <- arguments){>
   '    <populateMap(aliases, arg)>
   '  <}>
   '    
   '  return vf.constructor(getVallangConstructor()
   '           <for(TypeArg arg <- arguments){>
   '           , iv_<generateAttributeName(arg)> 
   '          <}>
   '           ); 
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

private str populateMap(map[str, str] aliases, TypeArg arg) {
  switch(arg) {
    case (TypeArg)`<Type t> <Name n>`: 
      switch(t) {
        case (Type)`str` : return populateBasicType("str", unparse(n));
        case (Type)`int` : return populateBasicType("int", unparse(n));
        case (Type)`bool`: return  populateBasicType("bool", unparse(n));
        case (Type)`real`: return populateBasicType("real", unparse(n));
        case (Type)`list[<TypeArg base>]`: return populateListType(aliases, unparse(base), unparse(n)); 
        default: return populateUserDefinedType(aliases, unparse(t), unparse(n)); 
      }
    default: return "error exporting the source code";  
  }
}

private str populateBasicType("str", str n)     = "IValue iv_<n> = vf.string(<n>);";
private str populateBasicType("int", str n)     = "IValue iv_<n> = vf.integer(<n>);";
private str populateBasicType("bool", str n)    = "IValue iv_<n> = vf.bool(<n>);";
private str populateBasicType("real", str n)    = "IValue iv_<n> = vf.real(<n>);";
private str populateBasicType("Double", str n)  = "IValue iv_<n> = vf.real(<n>);";
private str populateBasicType("Long", str n)    = "IValue iv_<n> = vf.integer(<n>);";


private str populateUserDefinedType(map[str, str] aliases, str base, str n) {
 str val = ""; 
 switch(resolve(aliases, base)) {
   case "String"  : val = "vf.string(<n>)";
   case "Integer" : val = "vf.integer(<n>)";
   case "Boolean" : val = "vf.boolean(<n>)";
   case "Float"    : val = "vf.real(<n>)";
   case "Double"  : val = "vf.real(<n>)";
   case "Long"    : val = "vf.integer(<n>)";
   default        : val = "<n>.createVallangInstance(vf)"; 
 }
 return "IValue iv_<n> = <val>;"; 
}

private str populateListType(map[str, str] aliases, str base, str n) {
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
        "; 
}

private str resolve(map[str, str] aliases, str t) {
  // these are two special cases here. 
  // lets do a workaround here, because 
  // we cannot differentiate int and long in Rascal. 
  // the same is true beteen real and double
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
    default: return replaceAll(t, "\\", "");
  }
}
