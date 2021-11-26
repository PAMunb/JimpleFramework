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
 * Java representation of the CaseStmt construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 

@EqualsAndHashCode
public abstract class CaseStmt extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "CaseStmt";
   } 
   
   
   public static CaseStmt caseOption(Integer option, String targetStmt)  {
     return new c_caseOption(option, targetStmt);
   }
   
   public static CaseStmt defaultOption(String targetStmt)  {
     return new c_defaultOption(targetStmt);
   }
    
   
   @EqualsAndHashCode
   public static class c_caseOption extends CaseStmt {
     
     public Integer option;
     
     public String targetStmt;
     
     public c_caseOption(Integer option, String targetStmt) {
      
        this.option = option;  
      
        this.targetStmt = targetStmt;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
       IValue iv_option = vf.integer(option);
       
       IValue iv_targetStmt = vf.string(targetStmt);
       
       
       IValue[] children = new IValue[] { 
         iv_option, iv_targetStmt   
       };
     
       
       return vf.constructor(getVallangConstructor(), children);
        
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.integerType(), tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "caseOption";
     }
   }
   
   @EqualsAndHashCode
   public static class c_defaultOption extends CaseStmt {
     
     public String targetStmt;
     
     public c_defaultOption(String targetStmt) {
      
        this.targetStmt = targetStmt;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
       IValue iv_targetStmt = vf.string(targetStmt);
       
       
       IValue[] children = new IValue[] { 
         iv_targetStmt   
       };
     
       
       return vf.constructor(getVallangConstructor(), children);
        
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "defaultOption";
     }
   }
    
    
}