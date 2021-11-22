package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 

import lombok.*; 

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

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
      
        
          IValue iv_className = vf.string(className);
        
          IValue iv_returnType = returnType.createVallangInstance(vf);
        
          IValue iv_methodName = vf.string(methodName);
        
          IList iv_formals = vf.list();
          
          for(Type v: formals) {
           iv_formals = iv_formals.append(v.createVallangInstance(vf));   
          }
                  
        
          
        return vf.constructor(getVallangConstructor()
                 
                 , iv_className 
                
                 , iv_returnType 
                
                 , iv_methodName 
                
                 , iv_formals 
                
                 ); 
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