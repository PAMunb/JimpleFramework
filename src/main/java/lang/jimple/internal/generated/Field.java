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
 * Java representation of the Field construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 
@Builder
@EqualsAndHashCode
public  class Field extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "Field";
   } 
   
   
    
    public List<Modifier> modifiers;
    
    public Type fieldType;
    
    public String name;
    
   
    public static Field field(List<Modifier> modifiers, Type fieldType, String name)  {
      return new Field(modifiers, fieldType, name);
    }
    
    public Field(List<Modifier> modifiers, Type fieldType, String name) {
     
       this.modifiers = modifiers;  
     
       this.fieldType = fieldType;  
     
       this.name = name;  
       
    } 
    @Override
    public IConstructor createVallangInstance(IValueFactory vf) {
      
        IList iv_modifiers = vf.list();
        
        for(Modifier v: modifiers) {
         iv_modifiers = iv_modifiers.append(v.createVallangInstance(vf));   
        }
                
      
        IValue iv_fieldType = fieldType.createVallangInstance(vf);
      
        IValue iv_name = vf.string(name);
      
        
         return vf.constructor(getVallangConstructor()
         
           , iv_modifiers 
         
           , iv_fieldType 
         
           , iv_name 
         
         ); 
    }
   
   
    @Override
    public io.usethesource.vallang.type.Type[] children() {
      return new io.usethesource.vallang.type.Type[] { 
          tf.listType(tf.valueType()), fieldType.getVallangConstructor(), tf.stringType()
      };
    } 
   
    @Override
    public String getConstructor() {
       return "field";
    }
     
                                
    
}