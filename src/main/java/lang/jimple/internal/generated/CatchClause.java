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
 * Java representation of the CatchClause construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 
@Builder
@EqualsAndHashCode
public  class CatchClause extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "CatchClause";
   } 
   
   
    
    public Type exception;
    
    public String from;
    
    public String to;
    
    public String with;
    
   
    public static CatchClause catchClause(Type exception, String from, String to, String with)  {
      return new CatchClause(exception, from, to, with);
    }
    
    public CatchClause(Type exception, String from, String to, String with) {
     
       this.exception = exception;  
     
       this.from = from;  
     
       this.to = to;  
     
       this.with = with;  
       
    } 
    @Override
    public IConstructor createVallangInstance(IValueFactory vf) {
      HashMap<String, IValue> map = new HashMap<>(); 
      
      
      map.put("exception", exception.createVallangInstance(vf));
      
      map.put("from", vf.string(from));
      
      map.put("to", vf.string(to));
      
      map.put("with", vf.string(with));
      
        
      return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
    }
   
   
    @Override
    public io.usethesource.vallang.type.Type[] children() {
      return new io.usethesource.vallang.type.Type[] { 
          exception.getVallangConstructor(), tf.stringType(), tf.stringType(), tf.stringType()
      };
    } 
   
    @Override
    public String getConstructor() {
       return "catchClause";
    }
     
                                
    
}