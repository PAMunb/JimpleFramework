package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 

import lombok.*; 

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 


@EqualsAndHashCode
public abstract class Expression extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "Expression";
   } 

   
   
   public static Expression newInstance(Type instanceType)  {
     return new c_newInstance(instanceType);
   }
   
   public static Expression newArray(Type baseType, List<ArrayDescriptor> dims)  {
     return new c_newArray(baseType, dims);
   }
   
   public static Expression cast(Type toType, Immediate immeadiate)  {
     return new c_cast(toType, immeadiate);
   }
   
   public static Expression instanceOf(Type baseType, Immediate immediate)  {
     return new c_instanceOf(baseType, immediate);
   }
   
   public static Expression invokeExp(InvokeExp expression)  {
     return new c_invokeExp(expression);
   }
   
   public static Expression arraySubscript(String name, Immediate immediate)  {
     return new c_arraySubscript(name, immediate);
   }
   
   public static Expression stringSubscript(String string, Immediate immediate)  {
     return new c_stringSubscript(string, immediate);
   }
   
   public static Expression localFieldRef(String local, String className, Type fieldType, String fieldName)  {
     return new c_localFieldRef(local, className, fieldType, fieldName);
   }
   
   public static Expression fieldRef(String className, Type fieldType, String fieldName)  {
     return new c_fieldRef(className, fieldType, fieldName);
   }
   
   public static Expression and(Immediate lhs, Immediate rhs)  {
     return new c_and(lhs, rhs);
   }
   
   public static Expression or(Immediate lhs, Immediate rhs)  {
     return new c_or(lhs, rhs);
   }
   
   public static Expression xor(Immediate lhs, Immediate rhs)  {
     return new c_xor(lhs, rhs);
   }
   
   public static Expression reminder(Immediate lhs, Immediate rhs)  {
     return new c_reminder(lhs, rhs);
   }
   
   public static Expression isNull(Immediate immediate)  {
     return new c_isNull(immediate);
   }
   
   public static Expression isNotNull(Immediate immediate)  {
     return new c_isNotNull(immediate);
   }
   
   public static Expression cmp(Immediate lhs, Immediate rhs)  {
     return new c_cmp(lhs, rhs);
   }
   
   public static Expression cmpg(Immediate lhs, Immediate rhs)  {
     return new c_cmpg(lhs, rhs);
   }
   
   public static Expression cmpl(Immediate lhs, Immediate rhs)  {
     return new c_cmpl(lhs, rhs);
   }
   
   public static Expression cmpeq(Immediate lhs, Immediate rhs)  {
     return new c_cmpeq(lhs, rhs);
   }
   
   public static Expression cmpne(Immediate lhs, Immediate rhs)  {
     return new c_cmpne(lhs, rhs);
   }
   
   public static Expression cmpgt(Immediate lhs, Immediate rhs)  {
     return new c_cmpgt(lhs, rhs);
   }
   
   public static Expression cmpge(Immediate lhs, Immediate rhs)  {
     return new c_cmpge(lhs, rhs);
   }
   
   public static Expression cmplt(Immediate lhs, Immediate rhs)  {
     return new c_cmplt(lhs, rhs);
   }
   
   public static Expression cmple(Immediate lhs, Immediate rhs)  {
     return new c_cmple(lhs, rhs);
   }
   
   public static Expression shl(Immediate lhs, Immediate rhs)  {
     return new c_shl(lhs, rhs);
   }
   
   public static Expression shr(Immediate lhs, Immediate rhs)  {
     return new c_shr(lhs, rhs);
   }
   
   public static Expression ushr(Immediate lhs, Immediate rhs)  {
     return new c_ushr(lhs, rhs);
   }
   
   public static Expression plus(Immediate lhs, Immediate rhs)  {
     return new c_plus(lhs, rhs);
   }
   
   public static Expression minus(Immediate lhs, Immediate rhs)  {
     return new c_minus(lhs, rhs);
   }
   
   public static Expression mult(Immediate lhs, Immediate rhs)  {
     return new c_mult(lhs, rhs);
   }
   
   public static Expression div(Immediate lhs, Immediate rhs)  {
     return new c_div(lhs, rhs);
   }
   
   public static Expression lengthOf(Immediate immediate)  {
     return new c_lengthOf(immediate);
   }
   
   public static Expression neg(Immediate immediate)  {
     return new c_neg(immediate);
   }
   
   public static Expression immediate(Immediate immediate)  {
     return new c_immediate(immediate);
   }
    

   
   @EqualsAndHashCode
   public static class c_newInstance extends Expression {
     
     public Type instanceType;
     
   
       public c_newInstance(Type instanceType) {
        
          this.instanceType = instanceType;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_instanceType = instanceType.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_instanceType 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           instanceType.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "newInstance";
     }
   }
   
   @EqualsAndHashCode
   public static class c_newArray extends Expression {
     
     public Type baseType;
     
     public List<ArrayDescriptor> dims;
     
   
       public c_newArray(Type baseType, List<ArrayDescriptor> dims) {
        
          this.baseType = baseType;  
        
          this.dims = dims;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_baseType = baseType.createVallangInstance(vf);
       
         IList iv_dims = vf.list();
         
         for(ArrayDescriptor v: dims) {
          iv_dims = iv_dims.append(v.createVallangInstance(vf));   
         }
                 
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_baseType 
               
                , iv_dims 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           baseType.getVallangConstructor(), tf.listType(tf.valueType())
       };
     }
    
     @Override
     public String getConstructor() {
       return "newArray";
     }
   }
   
   @EqualsAndHashCode
   public static class c_cast extends Expression {
     
     public Type toType;
     
     public Immediate immeadiate;
     
   
       public c_cast(Type toType, Immediate immeadiate) {
        
          this.toType = toType;  
        
          this.immeadiate = immeadiate;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_toType = toType.createVallangInstance(vf);
       
         IValue iv_immeadiate = immeadiate.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_toType 
               
                , iv_immeadiate 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           toType.getVallangConstructor(), immeadiate.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "cast";
     }
   }
   
   @EqualsAndHashCode
   public static class c_instanceOf extends Expression {
     
     public Type baseType;
     
     public Immediate immediate;
     
   
       public c_instanceOf(Type baseType, Immediate immediate) {
        
          this.baseType = baseType;  
        
          this.immediate = immediate;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_baseType = baseType.createVallangInstance(vf);
       
         IValue iv_immediate = immediate.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_baseType 
               
                , iv_immediate 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           baseType.getVallangConstructor(), immediate.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "instanceOf";
     }
   }
   
   @EqualsAndHashCode
   public static class c_invokeExp extends Expression {
     
     public InvokeExp expression;
     
   
       public c_invokeExp(InvokeExp expression) {
        
          this.expression = expression;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_expression = expression.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_expression 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           expression.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "invokeExp";
     }
   }
   
   @EqualsAndHashCode
   public static class c_arraySubscript extends Expression {
     
     public String name;
     
     public Immediate immediate;
     
   
       public c_arraySubscript(String name, Immediate immediate) {
        
          this.name = name;  
        
          this.immediate = immediate;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_name = vf.string(name);
       
         IValue iv_immediate = immediate.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_name 
               
                , iv_immediate 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.stringType(), immediate.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "arraySubscript";
     }
   }
   
   @EqualsAndHashCode
   public static class c_stringSubscript extends Expression {
     
     public String string;
     
     public Immediate immediate;
     
   
       public c_stringSubscript(String string, Immediate immediate) {
        
          this.string = string;  
        
          this.immediate = immediate;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_string = vf.string(string);
       
         IValue iv_immediate = immediate.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_string 
               
                , iv_immediate 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.stringType(), immediate.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "stringSubscript";
     }
   }
   
   @EqualsAndHashCode
   public static class c_localFieldRef extends Expression {
     
     public String local;
     
     public String className;
     
     public Type fieldType;
     
     public String fieldName;
     
   
       public c_localFieldRef(String local, String className, Type fieldType, String fieldName) {
        
          this.local = local;  
        
          this.className = className;  
        
          this.fieldType = fieldType;  
        
          this.fieldName = fieldName;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_local = vf.string(local);
       
         IValue iv_className = vf.string(className);
       
         IValue iv_fieldType = fieldType.createVallangInstance(vf);
       
         IValue iv_fieldName = vf.string(fieldName);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_local 
               
                , iv_className 
               
                , iv_fieldType 
               
                , iv_fieldName 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.stringType(), tf.stringType(), fieldType.getVallangConstructor(), tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "localFieldRef";
     }
   }
   
   @EqualsAndHashCode
   public static class c_fieldRef extends Expression {
     
     public String className;
     
     public Type fieldType;
     
     public String fieldName;
     
   
       public c_fieldRef(String className, Type fieldType, String fieldName) {
        
          this.className = className;  
        
          this.fieldType = fieldType;  
        
          this.fieldName = fieldName;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_className = vf.string(className);
       
         IValue iv_fieldType = fieldType.createVallangInstance(vf);
       
         IValue iv_fieldName = vf.string(fieldName);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_className 
               
                , iv_fieldType 
               
                , iv_fieldName 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.stringType(), fieldType.getVallangConstructor(), tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "fieldRef";
     }
   }
   
   @EqualsAndHashCode
   public static class c_and extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_and(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "and";
     }
   }
   
   @EqualsAndHashCode
   public static class c_or extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_or(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "or";
     }
   }
   
   @EqualsAndHashCode
   public static class c_xor extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_xor(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "xor";
     }
   }
   
   @EqualsAndHashCode
   public static class c_reminder extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_reminder(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "reminder";
     }
   }
   
   @EqualsAndHashCode
   public static class c_isNull extends Expression {
     
     public Immediate immediate;
     
   
       public c_isNull(Immediate immediate) {
        
          this.immediate = immediate;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_immediate = immediate.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_immediate 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           immediate.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "isNull";
     }
   }
   
   @EqualsAndHashCode
   public static class c_isNotNull extends Expression {
     
     public Immediate immediate;
     
   
       public c_isNotNull(Immediate immediate) {
        
          this.immediate = immediate;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_immediate = immediate.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_immediate 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           immediate.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "isNotNull";
     }
   }
   
   @EqualsAndHashCode
   public static class c_cmp extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_cmp(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "cmp";
     }
   }
   
   @EqualsAndHashCode
   public static class c_cmpg extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_cmpg(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "cmpg";
     }
   }
   
   @EqualsAndHashCode
   public static class c_cmpl extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_cmpl(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "cmpl";
     }
   }
   
   @EqualsAndHashCode
   public static class c_cmpeq extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_cmpeq(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "cmpeq";
     }
   }
   
   @EqualsAndHashCode
   public static class c_cmpne extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_cmpne(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "cmpne";
     }
   }
   
   @EqualsAndHashCode
   public static class c_cmpgt extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_cmpgt(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "cmpgt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_cmpge extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_cmpge(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "cmpge";
     }
   }
   
   @EqualsAndHashCode
   public static class c_cmplt extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_cmplt(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "cmplt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_cmple extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_cmple(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "cmple";
     }
   }
   
   @EqualsAndHashCode
   public static class c_shl extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_shl(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "shl";
     }
   }
   
   @EqualsAndHashCode
   public static class c_shr extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_shr(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "shr";
     }
   }
   
   @EqualsAndHashCode
   public static class c_ushr extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_ushr(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "ushr";
     }
   }
   
   @EqualsAndHashCode
   public static class c_plus extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_plus(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "plus";
     }
   }
   
   @EqualsAndHashCode
   public static class c_minus extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_minus(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "minus";
     }
   }
   
   @EqualsAndHashCode
   public static class c_mult extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_mult(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "mult";
     }
   }
   
   @EqualsAndHashCode
   public static class c_div extends Expression {
     
     public Immediate lhs;
     
     public Immediate rhs;
     
   
       public c_div(Immediate lhs, Immediate rhs) {
        
          this.lhs = lhs;  
        
          this.rhs = rhs;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_lhs = lhs.createVallangInstance(vf);
       
         IValue iv_rhs = rhs.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_lhs 
               
                , iv_rhs 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           lhs.getVallangConstructor(), rhs.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "div";
     }
   }
   
   @EqualsAndHashCode
   public static class c_lengthOf extends Expression {
     
     public Immediate immediate;
     
   
       public c_lengthOf(Immediate immediate) {
        
          this.immediate = immediate;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_immediate = immediate.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_immediate 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           immediate.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "lengthOf";
     }
   }
   
   @EqualsAndHashCode
   public static class c_neg extends Expression {
     
     public Immediate immediate;
     
   
       public c_neg(Immediate immediate) {
        
          this.immediate = immediate;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_immediate = immediate.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_immediate 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           immediate.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "neg";
     }
   }
   
   @EqualsAndHashCode
   public static class c_immediate extends Expression {
     
     public Immediate immediate;
     
   
       public c_immediate(Immediate immediate) {
        
          this.immediate = immediate;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_immediate = immediate.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_immediate 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           immediate.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "immediate";
     }
   }
    
    
}