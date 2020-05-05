package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import java.util.HashMap;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

public abstract class Immediate extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "Immediate";
   } 

   
   public static Immediate local(String localName)  {
     return new c_local(localName);
   }
   
   public static Immediate intValue(Integer iValue)  {
     return new c_intValue(iValue);
   }
   
   public static Immediate floatValue(Float fv)  {
     return new c_floatValue(fv);
   }
   
   public static Immediate stringValue(String sv)  {
     return new c_stringValue(sv);
   }
   
   public static Immediate nullValue()  {
     return new c_nullValue();
   }
    

   
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
   
   public static class c_intValue extends Immediate {
     
     public Integer iValue;
     
   
     public c_intValue(Integer iValue) {
      
        this.iValue = iValue;  
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       IValue iv_iValue = vf.integer(iValue);
       
       
       return vf.constructor(getVallangConstructor()
                
                , iv_iValue 
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "intValue";
     }
   }
   
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