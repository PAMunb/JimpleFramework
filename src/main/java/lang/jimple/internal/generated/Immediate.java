package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import lombok.EqualsAndHashCode; 
import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

@EqualsAndHashCode
public abstract class Immediate extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "Immediate";
   } 

   
   
   public static Immediate local(String localName)  {
     return new c_local(localName);
   }
   
   public static Immediate intValue(Integer iv)  {
     return new c_intValue(iv);
   }
   
   public static Immediate longValue(Long lv)  {
     return new c_longValue(lv);
   }
   
   public static Immediate floatValue(Float fv)  {
     return new c_floatValue(fv);
   }
   
   public static Immediate doubleValue(Double fv)  {
     return new c_doubleValue(fv);
   }
   
   public static Immediate stringValue(String sv)  {
     return new c_stringValue(sv);
   }
   
   public static Immediate nullValue()  {
     return new c_nullValue();
   }
    

   
   @EqualsAndHashCode
   public static class c_local extends Immediate {
     
     public String localName;
     
   
       public c_local(String localName) {
        
          this.localName = localName;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_localName = vf.string(localName);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_localName 
               
                ); 
     }
   
     @Override
     public String getConstructor() {
       return "local";
     }
   }
   
   @EqualsAndHashCode
   public static class c_intValue extends Immediate {
     
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
     public String getConstructor() {
       return "intValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_longValue extends Immediate {
     
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
     public String getConstructor() {
       return "longValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_floatValue extends Immediate {
     
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
     public String getConstructor() {
       return "floatValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_doubleValue extends Immediate {
     
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
     public String getConstructor() {
       return "doubleValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_stringValue extends Immediate {
     
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
     public String getConstructor() {
       return "stringValue";
     }
   }
   
   @EqualsAndHashCode
   public static class c_nullValue extends Immediate {
     
   
       public c_nullValue() {
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
   
     @Override
     public String getConstructor() {
       return "nullValue";
     }
   }
    
    
}