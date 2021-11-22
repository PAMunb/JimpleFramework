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
 * Java representation of the UnnamedMethodSignature construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 
@Builder
@EqualsAndHashCode
public  class UnnamedMethodSignature extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "UnnamedMethodSignature";
   } 
   
   
    
    public Type returnType;
    
    public List<Type> formals;
    
   
    public static UnnamedMethodSignature unnamedMethodSignature(Type returnType, List<Type> formals)  {
      return new UnnamedMethodSignature(returnType, formals);
    }
    
    public UnnamedMethodSignature(Type returnType, List<Type> formals) {
     
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
       return "unnamedMethodSignature";
    }
     
                                
    
}