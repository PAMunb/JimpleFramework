module lang::jimple::toolkit::CallGraph

import lang::jimple::core::Context; 
import lang::jimple::Syntax; 

import List; 
import Map; 

import String;
import IO;

/* ISSUES:
 * - #3: A new call graph analysis that starts from the entry points.
 *
 */

/* 
 * a map from method signatures 
 * to simple names (e.g., M1, M2, ...)
 */ 
alias MethodMap = map[str, str]; 

/*
 * The control flow graph is a 
 * set of pairs {<M1, M2>, <M1, M3>, <M2, M4>, ...} 
 * indicating that M1 calls M2, M1 call M3, M2 call M4, 
 * and so forth.
 *
 * This is the Rascal's approach for modelling 
 * graphs.  
 */ 
alias CG = rel[str from, str to];

/* 
 * The CGModel (call-graph model) is an algebraic 
 * data type with two components: a CG and a MethodMap. 
 */ 
data CGModel = CGModel(CG cg, MethodMap methodMap);

/* the empty call graph model */ 
CGModel emptyModel = CGModel({}, ()); 

/* Computes a "full" call graph from an 
 * execution context. A better approach 
 * is to build a call graph starting from 
 * the entry points. 
 *
 * Let's fix this implementation latter. 
 */ 
CGModel computeCallGraph(ExecutionContext ctx) {
   cg = emptyModel; 
   
   map[Type, list[Method]] methods = (); 
   
   top-down visit(ctx) {
     case classDecl(n, _, _, _, _, mss): methods[n] = mss; 
   }  
   
   for(c <- methods) {
     cg = computeCallGraph(c, methods[c], cg);
   }  	
   
   return cg;
}

CGModel computeCallGraphNovo(ExecutionContext ctx) {
   cg = emptyModel; 
   
   list[MethodSignature] methods = []; 
   
   top-down visit(ctx) {
     case classDecl(TObject(cn), _, _, _, _, mss): {
            //methods[n] = mss; 
            methods = methods + [methodSignature(cn, r,n,f) | /Method(method(m,r,n,f,e,b),true) <- ctx];
            //TODO methods = methods + [methodSignature(cn, r, n, f), method(m,r,n,f,e,b) in mss | /Method(method(m,r,n,f,e,b),true) <- ctx];
            //println("========= "); println([methodSignature(cn, r,n,f) | /Method(method(m,r,n,f,e,b),true) <- ctx]);            
            //println("====");//println({name | method(_,_,name,_,_,_) <- mss });
            //println({name | method(_,_,name,_,_,_) <- mss });
            //println("****");println(ctx.mt["A"]);
            //funciona !!!!!!!!!!!!!!!!
            //println("&&&&&");println([m | /Method(m,true) <- ctx]);
            //aaa = [method | \Method(mss, true)];
            //println(aaa);
        }
    //case Method(method(_, _, n, _, _, _),true): {
    //    print("...............");println(n);
    //    }
   }  
   
   for(m <- methods) {
     cg = computeCallGraphNovo(m, cg, ctx);
   }  	
   
   return cg;
}

CGModel computeCallGraphNovo(_, CGModel model, _) = model;
CGModel computeCallGraphNovo(methodSignature(cn, r, mn, args), CGModel model, ExecutionContext ctx) {
	println("\n\ncomputeCallGraphNovo ....");
	print("\tmethod=");println(mn);
  mm = model.methodMap; 
  cg = model.cg; 
  
  str sig1 = methodSignature(cn, mn, args);
  
  if(! (sig1 in mm)) {
  	mm[sig1] = "M" + "<size(mm) + 1>"; 
  }
  
  
  innermost visit(ctx.mt[mn].method.body) {
    case virtualInvoke(_, sig, _): {
      sig2 = methodSignature(sig); 
      if(! (sig2 in mm)) {
        mm[sig2] = "M" + "<size(mm) + 1>"; 
      }
      cg = cg + <mm[sig1], mm[sig2]>;   
      return computeCallGraphNovo(sig, CGModel(cg, mm), ctx);   
    } 
  }
  
  return CGModel(cg, mm); 
}

/* 
 * Computes the call graph for a specific class, 
 * given its list of methods. This is a recursive 
 * implementation, using the third argument as an 
 * acummulator.  
 */ 
CGModel computeCallGraph(_, [], CGModel model) = model;
CGModel computeCallGraph(TObject(cn), [method(_, _, mn, args, _, body), *ms], CGModel model) {
  mm = model.methodMap; 
  cg = model.cg; 
  
  str sig1 = methodSignature(cn, mn, args);
  
  if(! (sig1 in mm)) {
  	mm[sig1] = "M" + "<size(mm) + 1>"; 
  }
  
  top-down visit(body) {
    case virtualInvoke(_, sig, _): {
      sig2 = methodSignature(sig); 
      if(! (sig2 in mm)) {
        mm[sig2] = "M" + "<size(mm) + 1>"; 
      }
      cg = cg + <mm[sig1], mm[sig2]>;     
    } 
  }
  
  return computeCallGraph(TObject(cn), ms, CGModel(cg, mm)); 
}

//TODO: move methods
str methodSignature(methodSignature(cn, _, mn, args)) = methodSignature(cn, mn, args); 
str methodSignature(Name cn, Name mn, args) =  "<replaceAll(cn, "/", ".")>.<mn>(<intercalate(",", args)>)";
