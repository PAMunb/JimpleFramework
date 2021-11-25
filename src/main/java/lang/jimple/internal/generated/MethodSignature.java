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
 * Java representation of the MethodSignature construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 
@Builder
@EqualsAndHashCode
public  class MethodSignature extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "MethodSignature";
   } 
   
   
    
    public String className;
    
    public Type returnType;
    
    public String methodName;
    
    public List<Type> formals;
    
   
    public static MethodSignature methodSignature(String className, Type returnType, String methodName, List<Type> formals)  {
      return new MethodSignature(className, returnType, methodName, formals);
    }
    
    public MethodSignature(String className, Type returnType, String methodName, List<Type> formals) {
     
       this.className = className;  
     
       this.returnType = returnType;  
     
       this.methodName = methodName;  
     
       this.formals = formals;  
       
    } 
    @Override
    public IConstructor createVallangInstance(IValueFactory vf) {
      HashMap<String, IValue> map = new HashMap<>(); 
      
      
      map.put("className", vf.string(className));
      
      map.put("returnType", returnType.createVallangInstance(vf));
      
      map.put("methodName", vf.string(methodName));
      
      IList iv_formals = vf.list();
      
      for(Type v: formals) {
       iv_formals = iv_formals.append(v.createVallangInstance(vf));   
      }
      map.put("formals", iv_formals);
              
      
        
      return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
    }
   
   
    @Override
    public io.usethesource.vallang.type.Type[] children() {
      return new io.usethesource.vallang.type.Type[] { 
          tf.stringType(), returnType.getVallangConstructor(), tf.stringType(), tf.listType(tf.valueType())
      };
    } 
   
    @Override
    public String getConstructor() {
       return "methodSignature";
    }
     
                                
    
}