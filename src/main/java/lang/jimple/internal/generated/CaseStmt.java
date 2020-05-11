package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import lombok.EqualsAndHashCode; 
import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

@EqualsAndHashCode
public abstract class CaseStmt extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "CaseStmt";
   } 

   
   
   public static CaseStmt caseOption(Integer option, GotoStmt targetStmt)  {
     return new c_caseOption(option, targetStmt);
   }
   
   public static CaseStmt defaultOption(GotoStmt targetStmt)  {
     return new c_defaultOption(targetStmt);
   }
    

   
   @EqualsAndHashCode
   public static class c_caseOption extends CaseStmt {
     
     public Integer option;
     
     public GotoStmt targetStmt;
     
   
       public c_caseOption(Integer option, GotoStmt targetStmt) {
        
          this.option = option;  
        
          this.targetStmt = targetStmt;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_option = vf.integer(option);
       
         IValue iv_targetStmt = targetStmt.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_option 
               
                , iv_targetStmt 
               
                ); 
     }
   
     @Override
     public String getConstructor() {
       return "caseOption";
     }
   }
   
   @EqualsAndHashCode
   public static class c_defaultOption extends CaseStmt {
     
     public GotoStmt targetStmt;
     
   
       public c_defaultOption(GotoStmt targetStmt) {
        
          this.targetStmt = targetStmt;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_targetStmt = targetStmt.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_targetStmt 
               
                ); 
     }
   
     @Override
     public String getConstructor() {
       return "defaultOption";
     }
   }
    
    
}