module lang::jimple::toolkit::BasicMetrics
import IO;
import lang::jimple::Syntax;
import lang::jimple::core::Context;
import List;
import lang::jimple::toolkit::CallGraph;
import String;
/**
 * Computes the number of classes from
 * an ExecutionContext.
 */
public int numberOfClasses(ExecutionContext ctx) {
  int total = 0;
  top-down visit(ctx) {
    case classDecl(_, _, _, _, _, _): total = total + 1;
  }	
  return total;
}
public list[str] classIdentification(ExecutionContext ctx) {
  list[str] cl = [];
  top-down visit(ctx) {
    case classDecl(_, _, _, _, _, list[Method] methods): cl = cl + ["classDecl(_, _, _, _, _, <methods>)"];
  }
  return cl;
}
public list[Method] methodsIdentification(ExecutionContext ctx) {
  list[Method] lm = [];
  top-down visit(ctx) {
    case classDecl(_, _, _, _, _, list[Method] methods): lm = lm + methods;
  }
  return lm;
}
public Method firstMethod(ExecutionContext ctx){
	list[Method] lm = methodsIdentification(ctx);
	Method m = head(lm);
	return m;
}
public list[str] methodsName(ExecutionContext ctx){
	list[str] name = [];
	top-down visit(ctx) {
    	
    	case method(_, _, nm, _, _, _): name = name+nm;
     	
    }
    return name;
}
public list[str] methodSignatureList(ExecutionContext ctx){
	list[str] mS = [];
	top-down visit(ctx) {
    	
    	case invokeStmt(specialInvoke(_,methodS,_)): mS = mS+methodSignature(methodS);
    	case invokeStmt(virtualInvoke(_,methodS,_)): mS = mS+methodSignature(methodS);
    	case invokeStmt(interfaceInvoke(_,methodS,_)): mS = mS+methodSignature(methodS);
    	case invokeStmt(staticMethodInvoke(methodS,_)): mS = mS+methodSignature(methodS);
    	case invokeStmt(dynamicInvoke(methodS,_,_,_)): mS = mS+methodSignature(methodS);
     	
    }
    return mS;
}
list[str] readFiles(loc location){
   res = [];
   list[str] lines = readFileLines(location);
   for (str l <- lines){
      res = res + changeLine(l);
   };
   return res;
}
str changeLine(str s){
	str stringFinal = replaceAll(s, "\<", "");
	stringFinal = replaceAll(stringFinal, "\>", "");
	
	list[str] partes = split(" ", stringFinal);	
	
	if (size(partes) >=3) {
		str caminho = replaceAll(partes[0], ":", "");
		caminho = replaceAll(caminho, ".", "/");
		
		str retorno = partes[1];
		retorno = replaceAll(retorno, ".", "/");
		
		str metodo = partes[2];
		list[str] args = split(",", metodo);
		if (size(args) == 0){
			list[str] args2 = split(",", metodo);
			str arg = replaceAll(args2[1] , ")", "");
			if (contains(arg, ".")){
				metodo = replaceAll(metodo, arg,"TObject(\""+arg+"\")");
			};
		};
		if (size(args) > 1) {	
			list[tuple[str s1, str s2]] types = getTypes();
			for (str arg <- args){ //pega os argumentos
				for (tuple[str s1, str s2] t <- types){ //verifica os tipos
					if (t.s2 == arg){
						arg = t.s1;
						metodo = replaceAll(metodo, t.s2, t.s1); //Substitui os tipos dos args
					};
				};
			};
		};
		
		return caminho + "." + metodo;
	};
	
	return "";
}list[tuple[str s1, str s2]] getTypes(){
	list[tuple[str s1, str s2]] types = [<"TInteger()", "int">];
	types = types + [<"TString()", "string">];
	types = types + [<"TVoid()", "void">];
/*	
	  = TByte()
  | TBoolean()
  | TShort()
  | TCharacter()
  | TInteger()
  | TFloat()
  | TDouble()
  | TLong()
  | TObject(Name name)
  | TArray(Type baseType)
  | TVoid()
  | TString()
  | TMethodValue()
  | TClassValue()
  | TMethodHandle()
  | TFieldHandle()
  | TNull()
  | TUnknown()
	*/
	
	
	//Adicionar mais tipos aqui
	return types;
}
/**
 * Computes the number of public methods from an
 * execution context.
 */
public int numberOfPublicMethods(ExecutionContext ctx) {
  int total = 0;
  top-down visit(ctx) {
    case method(ms, _, _, _, _, _): {
     if(Public() in ms) {
       total = total + 1;
     }
    }
  }	
  return total;
}