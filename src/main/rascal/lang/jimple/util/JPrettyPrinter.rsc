module lang::jimple::util::JPrettyPrinter

import lang::jimple::core::Syntax;

import String;

/*
 * TODO PP: 
 *	Indentation must be made easier, configurable and less error prone.
 *	Methods in interfaces are printed in a diferent way than in classes; interfaces have a ';' and no {}.
 *  Local variables must be grouped during printting (example: java.io.PrintStream $r0, $r1, $r2, $r3) 
 *	 
 * TODO Jimple Decompiler:
 *  Missing local variable decl (the one with $ symbol.
 *  Sort LocalVariableDeclaration by variable name.
 */

str cleanClassName(str className) = replaceAll(className, "/","."); //TODO: do this in the decompiler

/* 
	Value 
*/
public str prettyPrint(Value::intValue(Int iv)) = "<iv>";
public str prettyPrint(Value::longValue(Long lv)) = "<lv>L";
public str prettyPrint(Value::floatValue(Float fv)) = "<fv>";
public str prettyPrint(Value::doubleValue(Double fv)) = "<fv>";
public str prettyPrint(Value::stringValue(String sv)) = "\"<sv>\"";
public str prettyPrint(Value::booleanValue(bool bl)) = "<bl>";
public str prettyPrint(Value::classValue(str name)) = name;
public str prettyPrint(Value::methodValue(Type returnType, list[Type] formals)) = "TODO";
public str prettyPrint(Value::fieldHandle(FieldSignature fieldSig)) = "TODO";
public str prettyPrint(Value::nullValue()) = "null";

/* 
	Immediate
*/
public str prettyPrint(Immediate::local(String localName)) = "<localName>";
public str prettyPrint(Immediate::iValue(Value v)) = "<prettyPrint(v)>";
public str prettyPrint(Immediate::caughtException()) = "@caughtexception";

/* 
	Modifiers 
*/
public str prettyPrint(Modifier::Public()) = "public";
public str prettyPrint(Modifier::Protected()) = "protected";
public str prettyPrint(Modifier::Private()) = "private";
public str prettyPrint(Modifier::Abstract()) = "abstract";
public str prettyPrint(Modifier::Static()) = "static";
public str prettyPrint(Modifier::Final()) = "final";
public str prettyPrint(Modifier::Strictfp()) = "strictfp";
public str prettyPrint(Modifier::Native()) = "native";
public str prettyPrint(Modifier::Synchronized()) = "synchronized";
public str prettyPrint(Modifier::Transient()) = "transient";
public str prettyPrint(Modifier::Volatile()) =  "volatile";
public str prettyPrint(Modifier::Enum()) =  "enum";
public str prettyPrint(Modifier::Annotation()) =  "annotation";
public str prettyPrint(Modifier::Synthetic()) =  "TODO";

/* 
	Types 
*/
public str prettyPrint(Type::TByte()) = "byte";
public str prettyPrint(Type::TBoolean()) = "boolean";
public str prettyPrint(Type::TShort()) = "short";
public str prettyPrint(Type::TCharacter()) = "char";
public str prettyPrint(Type::TInteger()) = "int";
public str prettyPrint(Type::TFloat()) = "float";
public str prettyPrint(Type::TDouble()) = "double";
public str prettyPrint(Type::TLong()) = "long";
public str prettyPrint(Type::TObject(name)) = "<name>";
public str prettyPrint(TArray(baseType)) = "<prettyPrint(baseType)>[]";
public str prettyPrint(Type::TVoid()) = "void";
public str prettyPrint(Type::TUnknown()) = "unknown";

/* 
 * Statements
 */
public str prettyPrint(Statement::label(Label label)) = "<label>:";
public str prettyPrint(Statement::breakpoint()) = "breakpoint;";
public str prettyPrint(Statement::enterMonitor(Immediate immediate)) = "entermonitor <prettyPrint(immediate)>;";
public str prettyPrint(Statement::exitMonitor(Immediate immediate)) = "exitmonitor <prettyPrint(immediate)>;";
public str prettyPrint(Statement::tableSwitch(Immediate immediate, int min, int max, list[CaseStmt] stmts)) = 
	"tableswitch(<prettyPrint(immediate)>)
	'{<for(s <- stmts) {>
	'    <prettyPrint(s)><}>
	'}";
public str prettyPrint(Statement::lookupSwitch(Immediate immediate, list[CaseStmt] stmts)) = 
	"lookupswitch(<prettyPrint(immediate)>)
	'{<for(s <- stmts) {>
	'    <prettyPrint(s)><}>
	'}";
public str prettyPrint(Statement::identity(Name local, Name identifier, Type idType)) = "<local> := <identifier>: <prettyPrint(idType)>;";
public str prettyPrint(Statement::identityNoType(Name local, Name identifier)) = "<local> := <identifier>;";
public str prettyPrint(Statement::assign(Variable var, Expression expression)) = "<prettyPrint(var)> = <prettyPrint(expression)>;";
public str prettyPrint(Statement::ifStmt(Expression exp, Label target)) = "if <prettyPrint(exp)> goto <target>;";
public str prettyPrint(Statement::retEmptyStmt()) = "ret;";
public str prettyPrint(Statement::retStmt(Immediate immediate)) = "ret <prettyPrint(immediate)>;";
public str prettyPrint(Statement::returnEmptyStmt()) = "return;";
public str prettyPrint(Statement::returnStmt(Immediate immediate)) = "return <prettyPrint(immediate)>;";
public str prettyPrint(Statement::throwStmt(Immediate immediate)) = "throw <prettyPrint(immediate)>;";
public str prettyPrint(Statement::invokeStmt(InvokeExp invokeExpression)) = "<prettyPrint(invokeExpression)>;";
public str prettyPrint(Statement::gotoStmt(Label target)) = "goto <target>;";
public str prettyPrint(Statement::nop()) = "nop;";

/* 
 * Variable
 */
public str prettyPrint(Variable::localVariable(Name local)) = "<local>";
public str prettyPrint(Variable::arrayRef(Name reference, Immediate idx)) = "<reference>[<prettyPrint(idx)>]";
public str prettyPrint(Variable::fieldRef(Name reference, FieldSignature field)) = "<reference>.<prettyPrint(field)>";
public str prettyPrint(Variable::staticFieldRef(FieldSignature field)) = "<prettyPrint(field)>";

/* 
 * FieldSignature
 */
public str prettyPrint(FieldSignature::fieldSignature(Name className, Type fieldType, Name fieldName)) =
	"\<<cleanClassName(className)>: <prettyPrint(fieldType)> <fieldName>\>";

/* 
 * Case
 */
public str prettyPrint(CaseStmt::caseOption(Int option, Label targetStmt)) = "case <option>: goto <targetStmt>;";
public str prettyPrint(CaseStmt::defaultOption(Label targetStmt)) = "default: goto <targetStmt>;";

public str prettyPrint(ArrayDescriptor::fixedSize(Int size)) = "[<size>]";
public str prettyPrint(ArrayDescriptor::variableSize()) = "[]";

/* 
 * Expression
 */
public str prettyPrint(Expression::newInstance(Type instanceType)) = "new <prettyPrint(instanceType)>";
public str prettyPrint(Expression::newArray(Type baseType, list[ArrayDescriptor] dims)) = "newarray (<prettyPrint(baseType)>)<prettyPrint(dims)>";
public str prettyPrint(Expression::cast(Type toType, Immediate immeadiate)) = "(<prettyPrint(toType)>) <prettyPrint(immeadiate)>";
public str prettyPrint(Expression::instanceOf(Type baseType, Immediate immediate)) = "<prettyPrint(immediate)> instanceof <prettyPrint(baseType)>";
public str prettyPrint(Expression::invokeExp(InvokeExp expression)) = "<prettyPrint(expression)>";
public str prettyPrint(Expression::arraySubscript(Name name, Immediate immediate)) = "<name>[<prettyPrint(immediate)>]";
public str prettyPrint(Expression::stringSubscript(String string, Immediate immediate)) = "\"<string>\"[<prettyPrint(immediate)>]";
public str prettyPrint(Expression::localFieldRef(Name local, Name className, Type fieldType, Name fieldName)) = "<local>.\<<cleanClassName(className)>: <prettyPrint(fieldType)> <fieldName>\>";
public str prettyPrint(Expression::fieldRef(Name className, Type fieldType, Name fieldName)) = "\<<cleanClassName(className)>: <prettyPrint(fieldType)> <fieldName>\>";
public str prettyPrint(Expression::and(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> & <prettyPrint(rhs)>";
public str prettyPrint(Expression::or(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> | <prettyPrint(rhs)>";
public str prettyPrint(Expression::xor(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> ^ <prettyPrint(rhs)>";
public str prettyPrint(Expression::reminder(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> % <prettyPrint(rhs)>";
public str prettyPrint(Expression::isNull(Immediate immediate)) = "<prettyPrint(immediate)> == null";
public str prettyPrint(Expression::isNotNull(Immediate immediate)) = "<prettyPrint(immediate)> != null";
public str prettyPrint(Expression::cmp(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> cmp <prettyPrint(rhs)>";
public str prettyPrint(Expression::cmpg(Immediate lhs, Immediate rhs) ) = "<prettyPrint(lhs)> cmpg <prettyPrint(rhs)>";
public str prettyPrint(Expression::cmpl(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> cmpl <prettyPrint(rhs)>";
public str prettyPrint(Expression::cmpeq(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> == <prettyPrint(rhs)>";
public str prettyPrint(Expression::cmpne(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> != <prettyPrint(rhs)>";
public str prettyPrint(Expression::cmpgt(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \> <prettyPrint(rhs)>";
public str prettyPrint(Expression::cmpge(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \>= <prettyPrint(rhs)>";
public str prettyPrint(Expression::cmplt(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> != <prettyPrint(rhs)>";
public str prettyPrint(Expression::cmple(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \< <prettyPrint(rhs)>";
public str prettyPrint(Expression::shl(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \<\< <prettyPrint(rhs)>";
public str prettyPrint(Expression::shr(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \>\> <prettyPrint(rhs)>";
public str prettyPrint(Expression::ushr(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \>\>\> <prettyPrint(rhs)>";
public str prettyPrint(Expression::plus(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> + <prettyPrint(rhs)>";
public str prettyPrint(Expression::minus(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> - <prettyPrint(rhs)>";
public str prettyPrint(Expression::mult(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> * <prettyPrint(rhs)>";
public str prettyPrint(Expression::div(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> / <prettyPrint(rhs)>";
public str prettyPrint(Expression::lengthOf(Immediate immediate)) = "lengthof <prettyPrint(immediate)>";
public str prettyPrint(Expression::neg(Immediate immediate)) = "neg <prettyPrint(immediate)>";
public str prettyPrint(Expression::immediate(Immediate immediate)) = "<prettyPrint(immediate)>";

public str prettyPrint(list[ArrayDescriptor] dims) {
	  str text = "";
	  switch(dims) {
	    case [] :  text = "";
	    case [v] : text = prettyPrint(v);
	    case [v, *vs] : text = prettyPrint(v) + prettyPrint(vs);
	  }
	  return text;
}

public str prettyPrint(list[Immediate] args) {
	  str text = "";
	  switch(args) {
	    case [] :  text = "";
	    case [v] : text = prettyPrint(v);
	    case [v, *vs] : text = prettyPrint(v) + ", " + prettyPrint(vs);
	  }
	  return text;
}

public str prettyPrint(InvokeExp invoke) {
	  switch(invoke) {
	    case specialInvoke(local, sig, args):
	    	return "specialinvoke <local>.\<<prettyPrint(sig)>\>(<prettyPrint(args)>)";
	    case virtualInvoke(local, sig, args):
	    	return "virtualinvoke <local>.\<<prettyPrint(sig)>\>(<prettyPrint(args)>)";
	    case interfaceInvoke(local, sig, args):
	    	return "interfaceinvoke <local>.\<<prettyPrint(sig)>\>(<prettyPrint(args)>)";
	    case staticMethodInvoke(sig,  args):
	    	return "staticinvoke \<<prettyPrint(sig)>\>(<prettyPrint(args)>)";
	    case dynamicInvoke(bsmSig, bsmArgs, sig, args):
	    	return "dynamicinvoke TODO";
	    default: return "error";    
	  }
	}

/* 
	Functions for printing ClassOrInterfaceDeclaration and its
	related upper parts.
*/
public str prettyPrint(CatchClause::catchClause(Type exception, Label from, Label to, Label with)) = 
	"catch <prettyPrint(exception)> from <from> to <to> with <with>;";

public str prettyPrint(MethodSignature::methodSignature(Name className, Type returnType, Name methodName, list[Type] formals)) =
	"<cleanClassName(className)>: <prettyPrint(returnType)> <methodName>(<prettyPrint(formals,"")>)";

public str prettyPrint(UnnamedMethodSignature::unnamedMethodSignature(Type returnType, list[Type] formals)) =
	"<prettyPrint(returnType)> (<prettyPrint(formals,"")>)";

public str prettyPrint(list[Modifier] modifiers) {
  str text = "";
  switch(modifiers) {
    case [] :  text = ""; 
    case [v] : text = prettyPrint(v); 
    case [v, *vs] : text = prettyPrint(v) + " " + prettyPrint(vs);
  }
  return text;
}

public str prettyPrint(list[Type] types, str n) {
  str text = "";
  switch(types) {
    case [] :  text = ""; 
    case [v] : text = n + prettyPrint(v); 
    case [v, *vs] : text = n + prettyPrint(v) + ", " + prettyPrint(vs, n);
  }
  return text;
}

public str prettyPrint(Field f: field(modifiers, fieldType, name)) =
	"<prettyPrint(modifiers)> <prettyPrint(fieldType)> <name>;";

public str prettyPrint(list[Field] fields) =
	"<for(f <- fields) {>
	'    <prettyPrint(f)><}>
	";

public str prettyPrint(LocalVariableDeclaration::localVariableDeclaration(Type varType, Identifier local)) = 
	"<prettyPrint(varType)> <local>;";

public str prettyPrint(MethodBody body: methodBody(localVars, stmts, catchClauses)) =
	"<for(l <- localVars){>
	'   <prettyPrint(l)><}>
	'<for(s <- stmts){>
	'<if (s is label) {>
	'<prettyPrint(s)><} else {>
	'   <prettyPrint(s)><}><}> <for(c <- catchClauses){>\n   <prettyPrint(c)><}>";

public str prettyPrint(Method m: method(modifiers, returnType, name, formals, exceptions, body)) =
	"<prettyPrint(modifiers)> <prettyPrint(returnType)> <name>(<prettyPrint(formals,"")>) <prettyPrint(exceptions,"throws ")>
	'{<prettyPrint(body)>
	'}
	";

public str prettyPrint(list[Method] methods) =
	"<for(m <- methods){>
	'    <prettyPrint(m)><}>";

public str prettyPrint(ClassOrInterfaceDeclaration unit) {
  switch(unit) {
    case classDecl(name,ms,super,infs,fields,methods): 
    	return 
			"<prettyPrint(ms)> class <prettyPrint(name)> extends <prettyPrint(super)> <prettyPrint(infs, "implements ")>
    		'{
    		'<prettyPrint(fields)> <prettyPrint(methods)>
			'}";
    case interfaceDecl(name,ms,infs,fields,methods):
    	return
			"<prettyPrint(ms)> interface <prettyPrint(name)> extends <prettyPrint(infs,"")>
			'{ 
        	'<prettyPrint(fields)> <prettyPrint(methods)>
			'}";
    default: return "error";
  }
}
