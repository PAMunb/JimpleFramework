module lang::jimple::toolkit::PrettyPrinter

import lang::jimple::Syntax;
import lang::jimple::core::Context; 

/*
 * TODO PP: 
 *	Indentation must be made easier, configurable and less error prone.
 *	Methods in interfaces are printed in a diferent way than in classes; interfaces have a ';' and no {}.
 *	 
 * TODO Jimple Decompiler:
 * 	Missing <clinit> method (static initialization blocks for the class, and static field initialization).
 *  Missing local variable decl (the one with $ symbol.
 *  Sort LocalVariableDeclaration by variable name.
 *  Changes in .classpath file  made the test-classes dir, on target, disappear. This broke the Test*.rsc files. 
 */

/* 
	Value 
*/
str prettyPrint(Value::intValue(Int iv)) = "<iv>";
str prettyPrint(Value::longValue(Long lv)) = "<lv>";
str prettyPrint(Value::floatValue(Float fv)) = "<fv>";
str prettyPrint(Value::doubleValue(Double fv)) = "<fv>";
str prettyPrint(Value::stringValue(String sv)) = "\"<sv>\"";
str prettyPrint(Value::booleanValue(bool bl)) = "<bl>";
str prettyPrint(Value::classValue(str name)) = name;
str prettyPrint(Value::methodValue(Type returnType, list[Type] formals)) = "TODO";
str prettyPrint(Value::fieldHandle(FieldSignature fieldSig)) = "TODO";
str prettyPrint(Value::nullValue()) = "null";

/* 
	Immediate
*/
str prettyPrint(Immediate::local(String localName)) = "<localName>";
str prettyPrint(Immediate::iValue(Value v)) = "<prettyPrint(v)>";

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
str prettyPrint(Type::TObject(name)) = "<name>";
str prettyPrint(TArray(baseType)) = "<prettyPrint(baseType)>[]"; 
str prettyPrint(Type::TVoid()) = "void";
str prettyPrint(Type::TUnknown()) = "unknown";

/* 
 * Statements
 */
str prettyPrint(Statement::label(Label label)) = "\b\b\b<label>:";
str prettyPrint(Statement::breakpoint()) = "breakpoint;";
str prettyPrint(Statement::enterMonitor(Immediate immediate)) = "entermonitor <prettyPrint(immediate)>;";
str prettyPrint(Statement::exitMonitor(Immediate immediate)) = "exitmonitor <prettyPrint(immediate)>;";
str prettyPrint(Statement::tableSwitch(Immediate immediate, int min, int max, list[CaseStmt] stmts)) = 
	"tableswitch(<prettyPrint(immediate)>)
	'{<for(s <- stmts) {>
	'    <prettyPrint(s)><}>
	'}";
str prettyPrint(Statement::lookupSwitch(Immediate immediate, list[CaseStmt] stmts)) = 
	"lookupswitch(<prettyPrint(immediate)>)
	'{<for(s <- stmts) {>
	'    <prettyPrint(s)><}>
	'}";
str prettyPrint(Statement::identity(Name local, Name identifier, Type idType)) = "<local> := <identifier>: <prettyPrint(idType)>;";
str prettyPrint(Statement::identityNoType(Name local, Name identifier)) = "<local> := <identifier>;";
str prettyPrint(Statement::assign(Variable var, Expression expression)) = "<prettyPrint(var)> = <prettyPrint(expression)>;";
str prettyPrint(Statement::ifStmt(Expression exp, Label target)) = "if <prettyPrint(exp)> goto <target>;";
str prettyPrint(Statement::retEmptyStmt()) = "ret;";
str prettyPrint(Statement::retStmt(Immediate immediate)) = "ret <prettyPrint(immediate)>;";
str prettyPrint(Statement::returnEmptyStmt()) = "return;";
str prettyPrint(Statement::returnStmt(Immediate immediate)) = "return <prettyPrint(immediate)>;";
str prettyPrint(Statement::throwStmt(Immediate immediate)) = "throw <prettyPrint(immediate)>;";
str prettyPrint(Statement::invokeStmt(InvokeExp invokeExpression)) = "<prettyPrint(invokeExpression)>;";
str prettyPrint(Statement::gotoStmt(Label target)) = "goto <target>;";
str prettyPrint(Statement::nop()) = "nop;";

/* 
 * Variable
 */
str prettyPrint(Variable::localVariable(Name local)) = "<local>";
str prettyPrint(Variable::arrayRef(Name reference, Immediate idx)) = "<reference> [<prettyPrint(idx)>]";
str prettyPrint(Variable::fieldRef(Name reference, FieldSignature field)) = "<reference>.<prettyPrint(field)>";
str prettyPrint(Variable::staticFieldRef(FieldSignature field)) = "<prettyPrint(field)>";

/* 
 * FieldSignature
 */
str prettyPrint(FieldSignature::fieldSignature(Name className, Type fieldType, Name fieldName)) =
	"\<<className>: <prettyPrint(fieldType)> <fieldName>\>";

/* 
 * Case
 */
str prettyPrint(CaseStmt::caseOption(Int option, Label targetStmt)) = "case <option>: goto <targetStmt>;";
str prettyPrint(CaseStmt::defaultOption(Label targetStmt)) = "default: goto <targetStmt>;";

str prettyPrint(ArrayDescriptor::fixedSize(Int size)) = "[<size>]";
str prettyPrint(ArrayDescriptor::variableSize()) = "[]";

/* 
 * Expression
 */
str prettyPrint(Expression::newInstance(Type instanceType)) = "new <prettyPrint(instanceType)>";
str prettyPrint(Expression::newArray(Type baseType, list[ArrayDescriptor] dims)) = "newarray (<prettyPrint(baseType)>)<prettyPrint(dims)>";
str prettyPrint(Expression::cast(Type toType, Immediate immeadiate)) = "(<prettyPrint(toType)>) <prettyPrint(immeadiate)>";
str prettyPrint(Expression::instanceOf(Type baseType, Immediate immediate)) = "<prettyPrint(immediate)> instanceof <prettyPrint(baseType)>";
str prettyPrint(Expression::invokeExp(InvokeExp expression)) = "<prettyPrint(expression)>";
str prettyPrint(Expression::arraySubscript(Name name, Immediate immediate)) = "<name>[<prettyPrint(immediate)>]";
str prettyPrint(Expression::stringSubscript(String string, Immediate immediate)) = "\"<string>\"[<prettyPrint(immediate)>]";
str prettyPrint(Expression::localFieldRef(Name local, Name className, Type fieldType, Name fieldName)) = "<local>.\<<className>: <prettyPrint(fieldType)> <fieldName>\>";
str prettyPrint(Expression::fieldRef(Name className, Type fieldType, Name fieldName)) = "\<<className>: <prettyPrint(fieldType)> <fieldName>\>";
str prettyPrint(Expression::and(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> & <prettyPrint(rhs)>";
str prettyPrint(Expression::or(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> | <prettyPrint(rhs)>";
str prettyPrint(Expression::xor(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> ^ <prettyPrint(rhs)>";
str prettyPrint(Expression::reminder(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> % <prettyPrint(rhs)>";
str prettyPrint(Expression::isNull(Immediate immediate)) = "<prettyPrint(immediate)> == null";
str prettyPrint(Expression::isNotNull(Immediate immediate)) = "<prettyPrint(immediate)> != null";
str prettyPrint(Expression::cmp(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> cmp <prettyPrint(rhs)>";
str prettyPrint(Expression::cmpg(Immediate lhs, Immediate rhs) ) = "<prettyPrint(lhs)> cmpg <prettyPrint(rhs)>";
str prettyPrint(Expression::cmpl(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> cmpl <prettyPrint(rhs)>";
str prettyPrint(Expression::cmpeq(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> == <prettyPrint(rhs)>";
str prettyPrint(Expression::cmpne(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> != <prettyPrint(rhs)>";
str prettyPrint(Expression::cmpgt(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \> <prettyPrint(rhs)>";
str prettyPrint(Expression::cmpge(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \>= <prettyPrint(rhs)>";
str prettyPrint(Expression::cmplt(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> != <prettyPrint(rhs)>";
str prettyPrint(Expression::cmple(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \< <prettyPrint(rhs)>";
str prettyPrint(Expression::shl(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \<\< <prettyPrint(rhs)>";
str prettyPrint(Expression::shr(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \>\> <prettyPrint(rhs)>";
str prettyPrint(Expression::ushr(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> \>\>\> <prettyPrint(rhs)>";
str prettyPrint(Expression::plus(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> + <prettyPrint(rhs)>";
str prettyPrint(Expression::minus(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> - <prettyPrint(rhs)>";
str prettyPrint(Expression::mult(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> * <prettyPrint(rhs)>";
str prettyPrint(Expression::div(Immediate lhs, Immediate rhs)) = "<prettyPrint(lhs)> / <prettyPrint(rhs)>";
str prettyPrint(Expression::lengthOf(Immediate immediate)) = "lengthof <prettyPrint(immediate)>";
str prettyPrint(Expression::neg(Immediate immediate)) = "neg <prettyPrint(immediate)>";
str prettyPrint(Expression::immediate(Immediate immediate)) = "<prettyPrint(immediate)>";


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

str prettyPrint(InvokeExp invoke) {
	  switch(invoke) {
	    case specialInvoke(local, sig, args):  
	    	return "specialinvoke <local>.\<<prettyPrint(sig)>\>(<prettyPrint(args)>)";
	    case virtualInvoke(local, sig, args): 
	    	return "virtualinvoke <local>.\<<prettyPrint(sig)>\>(<prettyPrint(args)>)";
	    case interfaceInvoke(local, sig, args): 
	    	return "interfaceinvoke <local>.\<<prettyPrint(sig)>\>(<prettyPrint(args)>)";
	    case staticMethodInvoke(sig,  args): 
	    	return "staticinvoke \<<prettyPrint(sig)>\>(<prettyPrint(args)>)";
	    case dynamicInvoke(bsmSig, bsmArgs, sig, args): //TODO 
	    	return "dynamicinvoke TODO";
	    default: return "error";    
	  }
	}

/* 
	Functions for printing ClassOrInterfaceDeclaration and its
	related upper parts.
*/
str prettyPrint(CatchClause::catchClause(Type exception, Label from, Label to, Label with)) = 
	"catch <prettyPrint(exception)> from <from> to <from> with <with>";

str prettyPrint(MethodSignature::methodSignature(Name className, Type returnType, Name methodName, list[Type] formals)) =
	"<className>: <prettyPrint(returnType)> <methodName>(<prettyPrint(formals,"")>)";

str prettyPrint(UnnamedMethodSignature::unnamedMethodSignature(Type returnType, list[Type] formals)) =
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
	'
	'   <prettyPrint(s)><}>";

public str prettyPrint(Method m: method(modifiers, returnType, name, formals, exceptions, body)) =
	"<prettyPrint(modifiers)> <prettyPrint(returnType)> <name>(<prettyPrint(formals,"")>) <prettyPrint(exceptions,"throws ")>
	'{<prettyPrint(body)>
	'}
	";

public str prettyPrint(list[Method] methods) =
	"<for(m <- methods){>
	'    <prettyPrint(m)><}>";

/*
Class or interface format:
	modifiers "class" typeName "extends" superClass  | "implements" interfaces | { }
	modifiers "interface" typeName "extends" superClass { }	
Example code:
	rascal>ClassOrInterfaceDeclaration x = classDecl(TObject("samples.Test"), [Public()], TObject("java.util.List"), [], [], []);
	rascal>prettyPrint(x);
*/

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


alias PrettyPrintMap = map[str, str]; 

data PrettyPrintModel = PrettyPrintModel(PrettyPrintMap ppMap);

PrettyPrintModel prettyPrint(ExecutionContext ctx) {
	PrettyPrintMap ppMap = ();
	
	top-down visit(ctx) {
		case classDecl(n, ms, s, is, fs, mss): ppMap[prettyPrint(n)] = prettyPrint(classDecl(n, ms, s, is, fs, mss)); 
	}	
	return PrettyPrintModel(ppMap);
}

