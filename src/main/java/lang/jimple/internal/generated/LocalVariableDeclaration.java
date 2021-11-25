package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import java.util.HashMap;

import lombok.*; 

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

/**
 * This class has been automatically generated from 
 * the JIMPLE AST definitions. It corresponds to a 
 * Java representation of the LocalVariableDeclaration construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 
@Builder
@EqualsAndHashCode
public  class LocalVariableDeclaration extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "LocalVariableDeclaration";
   } 
   
   
    
    public Type varType;
    
    public String local;
    
   
    public static LocalVariableDeclaration localVariableDeclaration(Type varType, String local)  {
      return new LocalVariableDeclaration(varType, local);
    }
    
    public LocalVariableDeclaration(Type varType, String local) {
     
       this.varType = varType;  
     
       this.local = local;  
       
    } 
    @Override
    public IConstructor createVallangInstance(IValueFactory vf) {
      HashMap<String, IValue> map = new HashMap<>(); 
      
      
      map.put("varType", varType.createVallangInstance(vf));
      
      map.put("local", vf.string(local));
      
        
      return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
    }
   
   
    @Override
    public io.usethesource.vallang.type.Type[] children() {
      return new io.usethesource.vallang.type.Type[] { 
          varType.getVallangConstructor(), tf.stringType()
      };
    } 
   
    @Override
    public String getConstructor() {
       return "localVariableDeclaration";
    }
     
                                
    
}