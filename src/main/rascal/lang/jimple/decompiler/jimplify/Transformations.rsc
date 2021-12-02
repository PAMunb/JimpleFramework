module lang::jimple::decompiler::jimplify::Transformations

import lang::jimple::core::Syntax; 
import lang::jimple::decompiler::jimplify::ProcessLabels;
import lang::jimple::decompiler::jimplify::ConstantPropagator;

import Map; 
import Set;
import List;

//TODO remover imports temporarios
import Type;
import IO;			
						
data TransformationType = basic()
					| optimizations() 
					| given(list[CID (CID)] transformations)
					| givenByNames(list[str] labels)
					| full();
					
alias CID = ClassOrInterfaceDeclaration;

map[str,list[CID (CID)]] basicTransformationsMap = ("label" : [processJimpleLabels]);
map[str,list[CID (CID)]] optimizationTransformationsMap = ();


public CID jimplify(CID c) = jimplify(c, basic()); 
public CID jimplify(CID c, basic()) = jimplify(getTransformations(basicTransformationsMap), c);
public CID jimplify(CID c, given(list[CID (CID)] transformations)) = jimplify(transformations, c);
//TODO deixar assim por enquanto ... ate ter os outros casos 
public CID jimplify(CID c, _) = jimplify(c, basic()); 

private CID jimplify(list[CID (CID)] fs, CID c) { 
	switch(fs) {
		case [h, *t]: return jimplify(t, h(c));
		default: return c; 
	}
} 	

private list[CID (CID)] getTransformations(map[str,list[CID (CID)]] transformationsMap){
	set[CID (CID)] transformationsSet = {};
	set[list[CID (CID)]] listOfLists = range(transformationsMap);

	for(internalList <- listOfLists){		
		transformationsSet += {t | t <- internalList};
	}
	
	return toList(transformationsSet);
}	



/////////////////////////////////////////////////////////////////////
///TODO remover metodos temporarios para teste
public void teste(){
	map[str,list[CID (CID)]] mapa = 
					("label" : [processJimpleLabels], 
					"cte" : [processConstantPropagator, processJimpleLabels, novo]);

	set[ClassOrInterfaceDeclaration (ClassOrInterfaceDeclaration)] retorno = {};
	set[list[ClassOrInterfaceDeclaration (ClassOrInterfaceDeclaration)]] listaDeListas = range(mapa);
	
	println("listaDeListas=<listaDeListas>");
	for(listaInterna <- listaDeListas){		
		retorno = retorno + {t | t <- listaInterna};
	}
	
	for(r <- retorno){
		println("####=<r>");
	}

}

public ClassOrInterfaceDeclaration novo(ClassOrInterfaceDeclaration c) { 
  return c;   
}
									