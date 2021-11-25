package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 

import lombok.*; 

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

/**
 * This class has been automatically generated from 
 * the JIMPLE AST definitions. It corresponds to a 
 * Java representation of the Variable construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 

@EqualsAndHashCode
public abstract class Variable extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "Variable";
   } 
   
   
   public static Variable localVariable(String local)  {
     return new c_localVariable(local);
   }
   
   public static Variable arrayRef(String reference, Immediate idx)  {
     return new c_arrayRef(reference, idx);
   }
   
   public static Variable fieldRef(String reference, FieldSignature field)  {
     return new c_fieldRef(reference, field);
   }
   
   public static Variable staticFieldRef(FieldSignature field)  {
     return new c_staticFieldRef(field);
   }
    
   
   @EqualsAndHashCode
   public static class c_localVariable extends Variable {
     
     public String local;
     
     public c_localVariable(String local) {
      
        this.local = local;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_local = vf.string(local);
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_local 
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "localVariable";
     }
   }
   
   @EqualsAndHashCode
   public static class c_arrayRef extends Variable {
     
     public String reference;
     
     public Immediate idx;
     
     public c_arrayRef(String reference, Immediate idx) {
      
        this.reference = reference;  
      
        this.idx = idx;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_reference = vf.string(reference);
       
         IValue iv_idx = idx.createVallangInstance(vf);
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_reference 
          
            , iv_idx 
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType(), idx.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "arrayRef";
     }
   }
   
   @EqualsAndHashCode
   public static class c_fieldRef extends Variable {
     
     public String reference;
     
     public FieldSignature field;
     
     public c_fieldRef(String reference, FieldSignature field) {
      
        this.reference = reference;  
      
        this.field = field;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_reference = vf.string(reference);
       
         IValue iv_field = field.createVallangInstance(vf);
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_reference 
          
            , iv_field 
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType(), field.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "fieldRef";
     }
   }
   
   @EqualsAndHashCode
   public static class c_staticFieldRef extends Variable {
     
     public FieldSignature field;
     
     public c_staticFieldRef(FieldSignature field) {
      
        this.field = field;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_field = field.createVallangInstance(vf);
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_field 
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         field.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "staticFieldRef";
     }
   }
    
    
}