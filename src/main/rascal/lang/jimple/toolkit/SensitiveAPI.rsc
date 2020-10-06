module lang::jimple::toolkit::SensitiveAPI

import lang::jimple::core::Context;
import lang::jimple::Syntax;
import lang::jimple::core::Context;
import lang::jimple::util::Converters;

import IO;
import List;
import String;

//list[str] sensitiveFind(list[str] listSignature,list[str] listFileSensitive){
//	list[str] listResult =  listSignature & listFileSensitive;
//	return listResult;
//}


public list[str] sensitiveFind(loc fileSensitive){
	es = [];
	list[str] listSignature = execute([|project://JimpleFramework/src/test/resources|], es, Analysis(methodSignatureList));
	
	list[str] listFileSensitive = readFiles(fileSensitive);
	
	//listFileSensitive = listFileSensitive + ["android/app/Activity.\<init\>()"];
	//listFileSensitive = listFileSensitive + ["android/content/Intent.\<init\>()"];
	//listFileSensitive = listFileSensitive + ["oms/wmessage/main.startActivity(android.content.Intent)"];
	//listFileSensitive = listFileSensitive + ["android/widget/Button.setOnClickListener(android.view.View$OnClickListener)"];

	list[str] listResult = listFileSensitive & listSignature;
	return listResult;
}


public list[str] methodSignatureList(ExecutionContext ctx){
	list[str] mS = [];
	top-down visit(ctx) {
    	case invokeStmt(specialInvoke(_,methodS,_)): mS = mS+signature(methodS);
    	case invokeStmt(virtualInvoke(_,methodS,_)): mS = mS+signature(methodS);
    	case invokeStmt(interfaceInvoke(_,methodS,_)): mS = mS+signature(methodS);
    	case invokeStmt(staticMethodInvoke(methodS,_)): mS = mS+signature(methodS);
    	case invokeStmt(dynamicInvoke(methodS,_,_,_)): mS = mS+signature(methodS);
    }
    return mS;
}

private list[str] readFiles(loc location){
   res = [];
   list[str] lines = readFileLines(location);
   for (str l <- lines){
      res = res + changeLine(l);
   };
   return res;
}

private str changeLine(str s){
	str stringFinal = replaceAll(s, "\<", "");
	stringFinal = replaceAll(stringFinal, "\>", "");
	
	list[str] partes = split(" ", stringFinal);	
	
	if (size(partes) >=3) {
		str caminho = replaceAll(partes[0], ":", "");
		caminho = replaceAll(caminho, ".", "/");
		
		str retorno = partes[1];
		retorno = replaceAll(retorno, ".", "/");
		
		str metodo = partes[2];
		return caminho + "." + metodo;
	};
	
	return "";
}