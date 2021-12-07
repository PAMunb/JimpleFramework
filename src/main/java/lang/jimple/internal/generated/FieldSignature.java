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
 * Java representation of the FieldSignature construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 
@Builder
@EqualsAndHashCode
public  class FieldSignature extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "FieldSignature";
   } 
   
   
    
    public String className;
    
    public Type fieldType;
    
    public String fieldName;
    
   
    public static FieldSignature fieldSignature(String className, Type fieldType, String fieldName)  {
      return new FieldSignature(className, fieldType, fieldName);
    }
    
    public FieldSignature(String className, Type fieldType, String fieldName) {
     
       this.className = className;  
     
       this.fieldType = fieldType;  
     
       this.fieldName = fieldName;  
       
    } 
    @Override
    public IConstructor createVallangInstance(IValueFactory vf) {
      
      IValue iv_className = vf.string(className);
      
      IValue iv_fieldType = fieldType.createVallangInstance(vf);
      
      IValue iv_fieldName = vf.string(fieldName);
      
      
      IValue[] children = new IValue[] { 
        iv_className, iv_fieldType, iv_fieldName   
      };
    
      
      return vf.constructor(getVallangConstructor(), children);
       
    }
   
   
    @Override
    public io.usethesource.vallang.type.Type[] children() {
      return new io.usethesource.vallang.type.Type[] { 
          tf.stringType(), fieldType.getVallangConstructor(), tf.stringType()
      };
    } 
   
    @Override
    public String getConstructor() {
       return "fieldSignature";
    }
     
                                
    
}