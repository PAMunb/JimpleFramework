module lang::jimple::toolkit::jimplify::ProcessLabels

import lang::jimple::Syntax;
 

/**
 * An auxiliarly function to process all Jimple labels and 
 * goto statements, translating them to a more user friendly 
 * format. 
 *
 * This is an example of source-to-source transformation used to 
 * jimplify Jimple code. 
 */ 
public ClassOrInterfaceDeclaration processJimpleLabels(ClassOrInterfaceDeclaration c) { 
  c = top-down visit(c) {
    case methodBody(ls, ss, cs) => processJimpleLabels(methodBody(ls, ss, cs))   
  }
  return c;   
}

/*
 * Process all jimple lables and references to make them
 * more user friendly.  
 */ 
private MethodBody processJimpleLabels(MethodBody mb) {
  map[str, int] labels = ();
  set[str] used = {}; 
  
  // compute used labels
  top-down visit(mb) {
    case gotoStmt(aLabel)     : used += aLabel; 
    case ifStmt(_, aLabel)    : used += aLabel;
    case caseOption(_, aLabel): used += aLabel; 
    case defaultOption(aLabel): used += aLabel; 
    case catchClause(_, from, to, with): {
    	used += from;
    	used += to; 
    	used += with; 
    }
  }
  
  // remove unused labels
  mb.stmts = [s | s <- mb.stmts, filterUnusedLabels(s, used)];
  
  int count = 1;
  
  // updates all labels to a more user friendly
  // string. 
  mb = top-down visit(mb) {
    case label(aLabel): {
     if(! (aLabel in labels)) {
        labels += (aLabel : count);       
        newLabel = label(createLabel(count)); 
        count = count + 1; 
        insert newLabel;
      }
    } 
  }
  
  // updates all goto stmts to point to the 
  // new labels. 
  mb = top-down visit(mb) {
  	case gotoStmt(aLabel)  => gotoStmt(fixReference(aLabel, labels))
  	 when aLabel in labels 
  	
  	case ifStmt(c, aLabel) => ifStmt(c, fixReference(aLabel, labels))
  	 when aLabel in labels 
  	
  	case caseOption(c, aLabel) => caseOption(c, fixReference(aLabel, labels))
  	 when aLabel in labels
  	
  	case defaultOption(aLabel) => defaultOption(fixReference(aLabel, labels))  
  	 when aLabel in labels 
  	 
  	case catchClause(e, from, to, with) => catchClause(e, fixReference(from, labels), fixReference(to, labels), fixReference(with, labels)) 
  	 when from in labels && to in labels && with in labels
  }
  return mb; 
}

/*
 * creates a label
 */ 
private str createLabel(int id) = "label<id>"; 

/* 
 * finds the correct reference to a label. 
 */ 
private str fixReference(str aLabel, map[str, int] labels) = "label<labels[aLabel]>"; 

/*
 * checks whether a label should be removed or not. 
 */  
private bool filterUnusedLabels(Statement s, set[str] used) {
	switch(s) {
	  case label(aLabel): return aLabel in used;
	  default: return true; 	
	}
}