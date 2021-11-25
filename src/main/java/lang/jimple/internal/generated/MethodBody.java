package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import java.util.HashMap;

import lombok.*; 

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

/**
 * This class has been automatically generated from 
 * the JIMPLE AST definitions. It corresponds to a 
 * Java representation of the MethodBody construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 

@EqualsAndHashCode
public abstract class MethodBody extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "MethodBody";
   } 
   
   
   public static MethodBody methodBody(List<LocalVariableDeclaration> localVariableDecls, List<Statement> stmts, List<CatchClause> catchClauses)  {
     return new c_methodBody(localVariableDecls, stmts, catchClauses);
   }
   
   public static MethodBody signatureOnly()  {
     return new c_signatureOnly();
   }
    
   
   @EqualsAndHashCode
   public static class c_methodBody extends MethodBody {
     
     public List<LocalVariableDeclaration> localVariableDecls;
     
     public List<Statement> stmts;
     
     public List<CatchClause> catchClauses;
     
     public c_methodBody(List<LocalVariableDeclaration> localVariableDecls, List<Statement> stmts, List<CatchClause> catchClauses) {
      
        this.localVariableDecls = localVariableDecls;  
      
        this.stmts = stmts;  
      
        this.catchClauses = catchClauses;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       IList iv_localVariableDecls = vf.list();
       
       for(LocalVariableDeclaration v: localVariableDecls) {
        iv_localVariableDecls = iv_localVariableDecls.append(v.createVallangInstance(vf));   
       }
       map.put("localVariableDecls", iv_localVariableDecls);
               
       
       IList iv_stmts = vf.list();
       
       for(Statement v: stmts) {
        iv_stmts = iv_stmts.append(v.createVallangInstance(vf));   
       }
       map.put("stmts", iv_stmts);
               
       
       IList iv_catchClauses = vf.list();
       
       for(CatchClause v: catchClauses) {
        iv_catchClauses = iv_catchClauses.append(v.createVallangInstance(vf));   
       }
       map.put("catchClauses", iv_catchClauses);
               
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.listType(tf.valueType()), tf.listType(tf.valueType()), tf.listType(tf.valueType())
       };
     }
    
     @Override
     public String getConstructor() {
       return "methodBody";
     }
   }
   
   @EqualsAndHashCode
   public static class c_signatureOnly extends MethodBody {
     
     public c_signatureOnly() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "signatureOnly";
     }
   }
    
    
}