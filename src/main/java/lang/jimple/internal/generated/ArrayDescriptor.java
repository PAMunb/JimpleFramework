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
 * Java representation of the ArrayDescriptor construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 

@EqualsAndHashCode
public abstract class ArrayDescriptor extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "ArrayDescriptor";
   } 
   
   
   public static ArrayDescriptor fixedSize(Integer size)  {
     return new c_fixedSize(size);
   }
   
   public static ArrayDescriptor variableSize()  {
     return new c_variableSize();
   }
    
   
   @EqualsAndHashCode
   public static class c_fixedSize extends ArrayDescriptor {
     
     public Integer size;
     
     public c_fixedSize(Integer size) {
      
        this.size = size;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
       IValue iv_size = vf.integer(size);
       
       
       IValue[] children = new IValue[] { 
         iv_size   
       };
     
       
       return vf.constructor(getVallangConstructor(), children);
        
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.integerType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "fixedSize";
     }
   }
   
   @EqualsAndHashCode
   public static class c_variableSize extends ArrayDescriptor {
     
     public c_variableSize() {
        
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
       return "variableSize";
     }
   }
    
    
}