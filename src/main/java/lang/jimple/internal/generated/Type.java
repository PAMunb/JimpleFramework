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
 * Java representation of the Type construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 

@EqualsAndHashCode
public abstract class Type extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "Type";
   } 
   
   
   public static Type TByte()  {
     return new c_TByte();
   }
   
   public static Type TBoolean()  {
     return new c_TBoolean();
   }
   
   public static Type TShort()  {
     return new c_TShort();
   }
   
   public static Type TCharacter()  {
     return new c_TCharacter();
   }
   
   public static Type TInteger()  {
     return new c_TInteger();
   }
   
   public static Type TFloat()  {
     return new c_TFloat();
   }
   
   public static Type TDouble()  {
     return new c_TDouble();
   }
   
   public static Type TLong()  {
     return new c_TLong();
   }
   
   public static Type TObject(String name)  {
     return new c_TObject(name);
   }
   
   public static Type TArray(Type baseType)  {
     return new c_TArray(baseType);
   }
   
   public static Type TVoid()  {
     return new c_TVoid();
   }
   
   public static Type TString()  {
     return new c_TString();
   }
   
   public static Type TMethodValue()  {
     return new c_TMethodValue();
   }
   
   public static Type TClassValue()  {
     return new c_TClassValue();
   }
   
   public static Type TMethodHandle()  {
     return new c_TMethodHandle();
   }
   
   public static Type TFieldHandle()  {
     return new c_TFieldHandle();
   }
   
   public static Type TNull()  {
     return new c_TNull();
   }
   
   public static Type TUnknown()  {
     return new c_TUnknown();
   }
    
   
   @EqualsAndHashCode
   public static class c_TByte extends Type {
     
     public c_TByte() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TByte";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TBoolean extends Type {
     
     public c_TBoolean() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TBoolean";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TShort extends Type {
     
     public c_TShort() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TShort";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TCharacter extends Type {
     
     public c_TCharacter() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TCharacter";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TInteger extends Type {
     
     public c_TInteger() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TInteger";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TFloat extends Type {
     
     public c_TFloat() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TFloat";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TDouble extends Type {
     
     public c_TDouble() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TDouble";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TLong extends Type {
     
     public c_TLong() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TLong";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TObject extends Type {
     
     public String name;
     
     public c_TObject(String name) {
      
        this.name = name;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_name = vf.string(name);
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_name 
          
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
       return "TObject";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TArray extends Type {
     
     public Type baseType;
     
     public c_TArray(Type baseType) {
      
        this.baseType = baseType;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_baseType = baseType.createVallangInstance(vf);
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_baseType 
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         baseType.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "TArray";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TVoid extends Type {
     
     public c_TVoid() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TVoid";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TString extends Type {
     
     public c_TString() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TString";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TMethodValue extends Type {
     
     public c_TMethodValue() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TMethodValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TClassValue extends Type {
     
     public c_TClassValue() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TClassValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TMethodHandle extends Type {
     
     public c_TMethodHandle() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TMethodHandle";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TFieldHandle extends Type {
     
     public c_TFieldHandle() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TFieldHandle";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TNull extends Type {
     
     public c_TNull() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TNull";
     }
   }
   
   @EqualsAndHashCode
   public static class c_TUnknown extends Type {
     
     public c_TUnknown() {
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         
          return vf.constructor(getVallangConstructor()
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         
       };
     }
    
     @Override
     public String getConstructor() {
       return "TUnknown";
     }
   }
    
    
}