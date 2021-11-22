package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 

import lombok.*; 

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 


@EqualsAndHashCode
public abstract class Statement extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "Statement";
   } 

   
   
   public static Statement label(String label)  {
     return new c_label(label);
   }
   
   public static Statement breakpoint()  {
     return new c_breakpoint();
   }
   
   public static Statement enterMonitor(Immediate immediate)  {
     return new c_enterMonitor(immediate);
   }
   
   public static Statement exitMonitor(Immediate immediate)  {
     return new c_exitMonitor(immediate);
   }
   
   public static Statement tableSwitch(Immediate immediate, Integer min, Integer max, List<CaseStmt> stmts)  {
     return new c_tableSwitch(immediate, min, max, stmts);
   }
   
   public static Statement lookupSwitch(Immediate immediate, List<CaseStmt> stmts)  {
     return new c_lookupSwitch(immediate, stmts);
   }
   
   public static Statement identity(String local, String identifier, Type idType)  {
     return new c_identity(local, identifier, idType);
   }
   
   public static Statement identityNoType(String local, String identifier)  {
     return new c_identityNoType(local, identifier);
   }
   
   public static Statement assign(Variable var, Expression expression)  {
     return new c_assign(var, expression);
   }
   
   public static Statement ifStmt(Expression exp, String target)  {
     return new c_ifStmt(exp, target);
   }
   
   public static Statement retEmptyStmt()  {
     return new c_retEmptyStmt();
   }
   
   public static Statement retStmt(Immediate immediate)  {
     return new c_retStmt(immediate);
   }
   
   public static Statement returnEmptyStmt()  {
     return new c_returnEmptyStmt();
   }
   
   public static Statement returnStmt(Immediate immediate)  {
     return new c_returnStmt(immediate);
   }
   
   public static Statement throwStmt(Immediate immediate)  {
     return new c_throwStmt(immediate);
   }
   
   public static Statement invokeStmt(InvokeExp invokeExpression)  {
     return new c_invokeStmt(invokeExpression);
   }
   
   public static Statement gotoStmt(String target)  {
     return new c_gotoStmt(target);
   }
   
   public static Statement nop()  {
     return new c_nop();
   }
    

   
   @EqualsAndHashCode
   public static class c_label extends Statement {
     
     public String label;
     
   
       public c_label(String label) {
        
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
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "label";
     }
   }
   
   @EqualsAndHashCode
   public static class c_breakpoint extends Statement {
     
   
       public c_breakpoint() {
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           
       };
     }
    
     @Override
     public String getConstructor() {
       return "breakpoint";
     }
   }
   
   @EqualsAndHashCode
   public static class c_enterMonitor extends Statement {
     
     public Immediate immediate;
     
   
       public c_enterMonitor(Immediate immediate) {
        
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
       return "enterMonitor";
     }
   }
   
   @EqualsAndHashCode
   public static class c_exitMonitor extends Statement {
     
     public Immediate immediate;
     
   
       public c_exitMonitor(Immediate immediate) {
        
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
       return "exitMonitor";
     }
   }
   
   @EqualsAndHashCode
   public static class c_tableSwitch extends Statement {
     
     public Immediate immediate;
     
     public Integer min;
     
     public Integer max;
     
     public List<CaseStmt> stmts;
     
   
       public c_tableSwitch(Immediate immediate, Integer min, Integer max, List<CaseStmt> stmts) {
        
          this.immediate = immediate;  
        
          this.min = min;  
        
          this.max = max;  
        
          this.stmts = stmts;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_immediate = immediate.createVallangInstance(vf);
       
         IValue iv_min = vf.integer(min);
       
         IValue iv_max = vf.integer(max);
       
         IList iv_stmts = vf.list();
         
         for(CaseStmt v: stmts) {
          iv_stmts = iv_stmts.append(v.createVallangInstance(vf));   
         }
                 
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_immediate 
               
                , iv_min 
               
                , iv_max 
               
                , iv_stmts 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           immediate.getVallangConstructor(), tf.integerType(), tf.integerType(), tf.listType(tf.valueType())
       };
     }
    
     @Override
     public String getConstructor() {
       return "tableSwitch";
     }
   }
   
   @EqualsAndHashCode
   public static class c_lookupSwitch extends Statement {
     
     public Immediate immediate;
     
     public List<CaseStmt> stmts;
     
   
       public c_lookupSwitch(Immediate immediate, List<CaseStmt> stmts) {
        
          this.immediate = immediate;  
        
          this.stmts = stmts;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_immediate = immediate.createVallangInstance(vf);
       
         IList iv_stmts = vf.list();
         
         for(CaseStmt v: stmts) {
          iv_stmts = iv_stmts.append(v.createVallangInstance(vf));   
         }
                 
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_immediate 
               
                , iv_stmts 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           immediate.getVallangConstructor(), tf.listType(tf.valueType())
       };
     }
    
     @Override
     public String getConstructor() {
       return "lookupSwitch";
     }
   }
   
   @EqualsAndHashCode
   public static class c_identity extends Statement {
     
     public String local;
     
     public String identifier;
     
     public Type idType;
     
   
       public c_identity(String local, String identifier, Type idType) {
        
          this.local = local;  
        
          this.identifier = identifier;  
        
          this.idType = idType;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_local = vf.string(local);
       
         IValue iv_identifier = vf.string(identifier);
       
         IValue iv_idType = idType.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_local 
               
                , iv_identifier 
               
                , iv_idType 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.stringType(), tf.stringType(), idType.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "identity";
     }
   }
   
   @EqualsAndHashCode
   public static class c_identityNoType extends Statement {
     
     public String local;
     
     public String identifier;
     
   
       public c_identityNoType(String local, String identifier) {
        
          this.local = local;  
        
          this.identifier = identifier;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_local = vf.string(local);
       
         IValue iv_identifier = vf.string(identifier);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_local 
               
                , iv_identifier 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.stringType(), tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "identityNoType";
     }
   }
   
   @EqualsAndHashCode
   public static class c_assign extends Statement {
     
     public Variable var;
     
     public Expression expression;
     
   
       public c_assign(Variable var, Expression expression) {
        
          this.var = var;  
        
          this.expression = expression;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_var = var.createVallangInstance(vf);
       
         IValue iv_expression = expression.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_var 
               
                , iv_expression 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           var.getVallangConstructor(), expression.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "assign";
     }
   }
   
   @EqualsAndHashCode
   public static class c_ifStmt extends Statement {
     
     public Expression exp;
     
     public String target;
     
   
       public c_ifStmt(Expression exp, String target) {
        
          this.exp = exp;  
        
          this.target = target;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_exp = exp.createVallangInstance(vf);
       
         IValue iv_target = vf.string(target);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_exp 
               
                , iv_target 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           exp.getVallangConstructor(), tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "ifStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_retEmptyStmt extends Statement {
     
   
       public c_retEmptyStmt() {
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           
       };
     }
    
     @Override
     public String getConstructor() {
       return "retEmptyStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_retStmt extends Statement {
     
     public Immediate immediate;
     
   
       public c_retStmt(Immediate immediate) {
        
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
       return "retStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_returnEmptyStmt extends Statement {
     
   
       public c_returnEmptyStmt() {
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           
       };
     }
    
     @Override
     public String getConstructor() {
       return "returnEmptyStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_returnStmt extends Statement {
     
     public Immediate immediate;
     
   
       public c_returnStmt(Immediate immediate) {
        
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
       return "returnStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_throwStmt extends Statement {
     
     public Immediate immediate;
     
   
       public c_throwStmt(Immediate immediate) {
        
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
       return "throwStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_invokeStmt extends Statement {
     
     public InvokeExp invokeExpression;
     
   
       public c_invokeStmt(InvokeExp invokeExpression) {
        
          this.invokeExpression = invokeExpression;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_invokeExpression = invokeExpression.createVallangInstance(vf);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_invokeExpression 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           invokeExpression.getVallangConstructor()
       };
     }
    
     @Override
     public String getConstructor() {
       return "invokeStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_gotoStmt extends Statement {
     
     public String target;
     
   
       public c_gotoStmt(String target) {
        
          this.target = target;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IValue iv_target = vf.string(target);
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_target 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "gotoStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_nop extends Statement {
     
   
       public c_nop() {
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           
       };
     }
    
     @Override
     public String getConstructor() {
       return "nop";
     }
   }
    
    
}