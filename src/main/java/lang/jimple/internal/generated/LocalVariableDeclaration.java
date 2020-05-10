package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import java.util.HashMap;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

public abstract class LocalVariableDeclaration extends JimpleAbstractDataType {
	public Type varType;
    
    public String local;
    
	
   @Override 
   public String getBaseType() { 
     return "LocalVariableDeclaration";
   } 

   
   public static LocalVariableDeclaration localVariableDeclaration(Type varType, String local)  {
     return new c_localVariableDeclaration(varType, local);
   }
    

   
   public static class c_localVariableDeclaration extends LocalVariableDeclaration {
     
     
   
     public c_localVariableDeclaration(Type varType, String local) {
      
        this.varType = varType;  
      
        this.local = local;  
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       IValue iv_varType = varType.createVallangInstance(vf);
       
       IValue iv_local = vf.string(local);
       
       
       return vf.constructor(getVallangConstructor()
                
                , iv_varType 
                
                , iv_local 
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "localVariableDeclaration";
     }
   }
    
}