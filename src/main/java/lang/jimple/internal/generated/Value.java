package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 

import lombok.*; 

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 


@EqualsAndHashCode
public abstract class Value extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "Value";
   } 

   
   
   public static Value intValue(Integer iv)  {
     return new c_intValue(iv);
   }
   
   public static Value longValue(Long lv)  {
     return new c_longValue(lv);
   }
   
   public static Value floatValue(Float fv)  {
     return new c_floatValue(fv);
   }
   
   public static Value doubleValue(Double fv)  {
     return new c_doubleValue(fv);
   }
   
   public static Value stringValue(String sv)  {
     return new c_stringValue(sv);
   }
   
   public static Value booleanValue(Boolean bl)  {
     return new c_booleanValue(bl);
   }
   
   public static Value methodValue(Type returnType, List<Type> formals)  {
     return new c_methodValue(returnType, formals);
   }
   
   public static Value classValue(String name)  {
     return new c_classValue(name);
   }
   
   public static Value methodHandle(MethodSignature methodSig)  {
     return new c_methodHandle(methodSig);
   }
   
   public static Value fieldHandle(FieldSignature fieldSig)  {
     return new c_fieldHandle(fieldSig);
   }
   
   public static Value nullValue()  {
     return new c_nullValue();
   }
    

   
   @EqualsAndHashCode
   public static class c_intValue extends Value {
     
     public Integer iv;
     
   
       public c_intValue(Integer iv) {
        
          this.iv = iv;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_iv = vf.integer(iv);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_iv 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.integerType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "intValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_longValue extends Value {
     
     public Long lv;
     
   
       public c_longValue(Long lv) {
        
          this.lv = lv;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lv = vf.integer(lv);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lv 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.integerType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "longValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_floatValue extends Value {
     
     public Float fv;
     
   
       public c_floatValue(Float fv) {
        
          this.fv = fv;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_fv = vf.real(fv);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_fv 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.realType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "floatValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_doubleValue extends Value {
     
     public Double fv;
     
   
       public c_doubleValue(Double fv) {
        
          this.fv = fv;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_fv = vf.real(fv);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_fv 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.realType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "doubleValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_stringValue extends Value {
     
     public String sv;
     
   
       public c_stringValue(String sv) {
        
          this.sv = sv;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_sv = vf.string(sv);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_sv 
               
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
       return "stringValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_booleanValue extends Value {
     
     public Boolean bl;
     
   
       public c_booleanValue(Boolean bl) {
        
          this.bl = bl;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_bl = vf.bool(bl);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_bl 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.boolType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "booleanValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_methodValue extends Value {
     
     public Type returnType;
     
     public List<Type> formals;
     
   
       public c_methodValue(Type returnType, List<Type> formals) {
        
          this.returnType = returnType;  
        
          this.formals = formals;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_returnType = returnType.createVallangInstance(vf);
       
         IList iv_formals = vf.list();
         
         for(Type v: formals) {
          iv_formals = iv_formals.append(v.createVallangInstance(vf));   
         }
                 
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_returnType 
               
                , iv_formals 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           returnType.getVallangConstructor(), tf.listType(tf.valueType())
       };
     }
    
     @Override
     public String getConstructor() {
       return "methodValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_classValue extends Value {
     
     public String name;
     
   
       public c_classValue(String name) {
        
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
       return "classValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_methodHandle extends Value {
     
     public MethodSignature methodSig;
     
   
       public c_methodHandle(MethodSignature methodSig) {
        
          this.methodSig = methodSig;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_methodSig = methodSig.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_methodSig 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           methodSig.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "methodHandle";
     }
   }
   
   @EqualsAndHashCode
   public static class c_fieldHandle extends Value {
     
     public FieldSignature fieldSig;
     
   
       public c_fieldHandle(FieldSignature fieldSig) {
        
          this.fieldSig = fieldSig;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_fieldSig = fieldSig.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_fieldSig 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           fieldSig.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "fieldHandle";
     }
   }
   
   @EqualsAndHashCode
   public static class c_nullValue extends Value {
     
   
       public c_nullValue() {
          
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
       return "nullValue";
     }
   }
    
    
}