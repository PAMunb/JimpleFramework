package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import java.util.HashMap;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

public abstract class CatchClause extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "CatchClause";
   } 

   
   public static CatchClause catchClause(Type exception, String from, String to, String with)  {
     return new c_catchClause(exception, from, to, with);
   }
    

   
   public static class c_catchClause extends CatchClause {
     
     public Type exception;
     
     public String from;
     
     public String to;
     
     public String with;
     
   
     public c_catchClause(Type exception, String from, String to, String with) {
      
        this.exception = exception;  
      
        this.from = from;  
      
        this.to = to;  
      
        this.with = with;  
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       IValue iv_exception = exception.createVallangInstance(vf);
       
       IValue iv_from = vf.string(from);
       
       IValue iv_to = vf.string(to);
       
       IValue iv_with = vf.string(with);
       
       
       return vf.constructor(getVallangConstructor()
                
                , iv_exception 
                
                , iv_from 
                
                , iv_to 
                
                , iv_with 
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "catchClause";
     }
   }
    
}