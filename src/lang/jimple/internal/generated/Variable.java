package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import java.util.HashMap;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

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
     public String getConstructor() {
       return "localVariable";
     }
   }
   
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
     public String getConstructor() {
       return "arrayRef";
     }
   }
   
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
     public String getConstructor() {
       return "fieldRef";
     }
   }
   
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
     public String getConstructor() {
       return "staticFieldRef";
     }
   }
    
}