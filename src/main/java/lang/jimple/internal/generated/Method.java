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
 * Java representation of the Method construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 
@Builder
@EqualsAndHashCode
public  class Method extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "Method";
   } 
   
   
    
    public List<Modifier> modifiers;
    
    public Type returnType;
    
    public String name;
    
    public List<Type> formals;
    
    public List<Type> exceptions;
    
    public MethodBody body;
    
   
    public static Method method(List<Modifier> modifiers, Type returnType, String name, List<Type> formals, List<Type> exceptions, MethodBody body)  {
      return new Method(modifiers, returnType, name, formals, exceptions, body);
    }
    
    public Method(List<Modifier> modifiers, Type returnType, String name, List<Type> formals, List<Type> exceptions, MethodBody body) {
     
       this.modifiers = modifiers;  
     
       this.returnType = returnType;  
     
       this.name = name;  
     
       this.formals = formals;  
     
       this.exceptions = exceptions;  
     
       this.body = body;  
       
    } 
    @Override
    public IConstructor createVallangInstance(IValueFactory vf) {
      HashMap<String, IValue> map = new HashMap<>(); 
      
      
      IList iv_modifiers = vf.list();
      
      for(Modifier v: modifiers) {
       iv_modifiers = iv_modifiers.append(v.createVallangInstance(vf));   
      }
      map.put("modifiers", iv_modifiers);
              
      
      map.put("returnType", returnType.createVallangInstance(vf));
      
      map.put("name", vf.string(name));
      
      IList iv_formals = vf.list();
      
      for(Type v: formals) {
       iv_formals = iv_formals.append(v.createVallangInstance(vf));   
      }
      map.put("formals", iv_formals);
              
      
      IList iv_exceptions = vf.list();
      
      for(Type v: exceptions) {
       iv_exceptions = iv_exceptions.append(v.createVallangInstance(vf));   
      }
      map.put("exceptions", iv_exceptions);
              
      
      map.put("body", body.createVallangInstance(vf));
      
        
      return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
    }
   
   
    @Override
    public io.usethesource.vallang.type.Type[] children() {
      return new io.usethesource.vallang.type.Type[] { 
          tf.listType(tf.valueType()), returnType.getVallangConstructor(), tf.stringType(), tf.listType(tf.valueType()), tf.listType(tf.valueType()), body.getVallangConstructor()
      };
    } 
   
    @Override
    public String getConstructor() {
       return "method";
    }
     
                                
    
}