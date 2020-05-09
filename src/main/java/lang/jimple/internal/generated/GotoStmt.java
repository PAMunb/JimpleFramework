package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import java.util.HashMap;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

public abstract class GotoStmt extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "GotoStmt";
   } 

   
   public static GotoStmt gotoStmt(String label)  {
     return new c_gotoStmt(label);
   }
    

   
   public static class c_gotoStmt extends GotoStmt {
     
     public String label;
     
   
     public c_gotoStmt(String label) {
      
        this.label = label;  
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       IValue iv_label = vf.string(label);
       
       
       return vf.constructor(getVallangConstructor()
                
                , iv_label 
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "gotoStmt";
     }
   }
    
}