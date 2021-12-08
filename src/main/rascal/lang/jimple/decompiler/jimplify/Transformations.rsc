module lang::jimple::decompiler::jimplify::Transformations

import lang::jimple::core::Syntax; 
import lang::jimple::decompiler::jimplify::ProcessLabels;
import lang::jimple::decompiler::jimplify::FixStmtId;
import lang::jimple::decompiler::jimplify::FixStmtMethodSignature;
import lang::jimple::decompiler::jimplify::ConstantPropagator;
import lang::jimple::decompiler::jimplify::RemoveModifiers;

import Map; 
import List;

						
data TransformationType = basic()
					| optimizations() 
					| given(list[CID (CID)] transformations)
					| givenByNames(list[str] labels)
					| full();
					
alias CID = ClassOrInterfaceDeclaration;

map[str,list[CID (CID)]] basicTransformationsMap = ("label" : [processJimpleLabels],
													"stmt" : [fixSignature, fixStmtId],
													"modifier" : [processModifiers]);
map[str,list[CID (CID)]] optimizationTransformationsMap = ();


public CID jimplify(CID c) = jimplify(c, basic()); 
public CID jimplify(CID c, basic()) = jimplify(getTransformations(basicTransformationsMap), c);
public CID jimplify(CID c, optimizations()) = jimplify(getTransformations(optimizationTransformationsMap), c);
public CID jimplify(CID c, given(list[CID (CID)] transformations)) = jimplify(transformations, c);
public CID jimplify(CID c, givenByNames(list[str] labels)) = jimplify(getTransformations(labels), c);
public CID jimplify(CID c, full()) = jimplify(getTransformations(basicTransformationsMap) + getTransformations(optimizationTransformationsMap), c);

public CID jimplify(CID c, _) = jimplify(c, basic()); 

private CID jimplify(list[CID (CID)] fs, CID c) { 
	switch(fs) {
		case [h, *t]: return jimplify(t, h(c));
		default: return c; 
	}
} 	
 
private list[CID (CID)] getTransformations(map[str,list[CID (CID)]] transformationsMap){
	list[CID (CID)] transformationsList = [];
	set[list[CID (CID)]] listOfLists = range(transformationsMap);

	for(internalList <- listOfLists){		
		transformationsList += [t | t <- internalList];
	}
	
	return transformationsList;
}	

private list[CID (CID)] getTransformations(list[str] labels){
	list[CID (CID)] transformationsList = [];
	
	map[str,list[CID (CID)]] transformationsMap = basicTransformationsMap + optimizationTransformationsMap;
	
	for(label <- labels){
		if(label in transformationsMap){
			transformationsList += transformationsMap[label];
		}
	}
	
	return transformationsList;
}
									