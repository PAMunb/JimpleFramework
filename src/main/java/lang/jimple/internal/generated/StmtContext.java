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
 * Java representation of the StmtContext construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 

@EqualsAndHashCode
public abstract class StmtContext extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "StmtContext";
   } 
   
   
   public static StmtContext noContext()  {
     return new c_noContext();
   }
   
   public static StmtContext stmtContext(Integer stmtId, String methodSignature, Integer sourceCodeLine)  {
     return new c_stmtContext(stmtId, methodSignature, sourceCodeLine);
   }
    
   
   @EqualsAndHashCode
   public static class c_noContext extends StmtContext {
     
     public c_noContext() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
       
       IValue[] children = new IValue[] { 
            
       };
     
       
       return vf.constructor(getVallangConstructor(), children);
        
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "noContext";
     }
   }
   
   @EqualsAndHashCode
   public static class c_stmtContext extends StmtContext {
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public Integer sourceCodeLine;
     
     public c_stmtContext(Integer stmtId, String methodSignature, Integer sourceCodeLine) {
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
      
        this.sourceCodeLine = sourceCodeLine;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
       IValue iv_stmtId = vf.integer(stmtId);
       
       IValue iv_methodSignature = vf.string(methodSignature);
       
       IValue iv_sourceCodeLine = vf.integer(sourceCodeLine);
       
       
       IValue[] children = new IValue[] { 
         iv_stmtId, iv_methodSignature, iv_sourceCodeLine   
       };
     
       
       return vf.constructor(getVallangConstructor(), children);
        
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.integerType(), tf.stringType(), tf.integerType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "stmtContext";
     }
   }
    
    
}