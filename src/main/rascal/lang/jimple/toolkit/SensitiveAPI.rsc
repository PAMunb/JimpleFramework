module lang::jimple::toolkit::SensitiveAPI

import List;


list[str] sensitiveFind(list[str] listSignature,list[str] listFileSensitive){
	list[str] listResult =  listSignature & listFileSensitive;
	return listResult;
}