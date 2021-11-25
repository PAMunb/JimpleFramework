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
 * Java representation of the Statement construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 

@EqualsAndHashCode
public abstract class Statement extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "Statement";
   } 
   
   
   public static Statement label(String label, Integer stmtId, String methodSignature)  {
     return new c_label(label, stmtId, methodSignature);
   }
   
   public static Statement breakpoint(Integer stmtId, String methodSignature)  {
     return new c_breakpoint(stmtId, methodSignature);
   }
   
   public static Statement enterMonitor(Immediate immediate, Integer stmtId, String methodSignature)  {
     return new c_enterMonitor(immediate, stmtId, methodSignature);
   }
   
   public static Statement exitMonitor(Immediate immediate, Integer stmtId, String methodSignature)  {
     return new c_exitMonitor(immediate, stmtId, methodSignature);
   }
   
   public static Statement tableSwitch(Immediate immediate, Integer min, Integer max, List<CaseStmt> stmts, Integer stmtId, String methodSignature)  {
     return new c_tableSwitch(immediate, min, max, stmts, stmtId, methodSignature);
   }
   
   public static Statement lookupSwitch(Immediate immediate, List<CaseStmt> stmts, Integer stmtId, String methodSignature)  {
     return new c_lookupSwitch(immediate, stmts, stmtId, methodSignature);
   }
   
   public static Statement identity(String local, String identifier, Type idType, Integer stmtId, String methodSignature)  {
     return new c_identity(local, identifier, idType, stmtId, methodSignature);
   }
   
   public static Statement identityNoType(String local, String identifier, Integer stmtId, String methodSignature)  {
     return new c_identityNoType(local, identifier, stmtId, methodSignature);
   }
   
   public static Statement assign(Variable var, Expression expression, Integer stmtId, String methodSignature)  {
     return new c_assign(var, expression, stmtId, methodSignature);
   }
   
   public static Statement ifStmt(Expression exp, String target, Integer stmtId, String methodSignature)  {
     return new c_ifStmt(exp, target, stmtId, methodSignature);
   }
   
   public static Statement retEmptyStmt(Integer stmtId, String methodSignature)  {
     return new c_retEmptyStmt(stmtId, methodSignature);
   }
   
   public static Statement retStmt(Immediate immediate, Integer stmtId, String methodSignature)  {
     return new c_retStmt(immediate, stmtId, methodSignature);
   }
   
   public static Statement returnEmptyStmt(Integer stmtId, String methodSignature)  {
     return new c_returnEmptyStmt(stmtId, methodSignature);
   }
   
   public static Statement returnStmt(Immediate immediate, Integer stmtId, String methodSignature)  {
     return new c_returnStmt(immediate, stmtId, methodSignature);
   }
   
   public static Statement throwStmt(Immediate immediate, Integer stmtId, String methodSignature)  {
     return new c_throwStmt(immediate, stmtId, methodSignature);
   }
   
   public static Statement invokeStmt(InvokeExp invokeExpression, Integer stmtId, String methodSignature)  {
     return new c_invokeStmt(invokeExpression, stmtId, methodSignature);
   }
   
   public static Statement gotoStmt(String target, Integer stmtId, String methodSignature)  {
     return new c_gotoStmt(target, stmtId, methodSignature);
   }
   
   public static Statement nop(Integer stmtId, String methodSignature)  {
     return new c_nop(stmtId, methodSignature);
   }
    
   
   @EqualsAndHashCode
   public static class c_label extends Statement {
     
     public String label;
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_label(String label, Integer stmtId, String methodSignature) {
      
        this.label = label;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("label", vf.string(label));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType(), tf.integerType(), tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "label";
     }
   }
   
   @EqualsAndHashCode
   public static class c_breakpoint extends Statement {
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_breakpoint(Integer stmtId, String methodSignature) {
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_enterMonitor(Immediate immediate, Integer stmtId, String methodSignature) {
      
        this.immediate = immediate;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("immediate", immediate.createVallangInstance(vf));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         immediate.getVallangConstructor(), tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_exitMonitor(Immediate immediate, Integer stmtId, String methodSignature) {
      
        this.immediate = immediate;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("immediate", immediate.createVallangInstance(vf));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         immediate.getVallangConstructor(), tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_tableSwitch(Immediate immediate, Integer min, Integer max, List<CaseStmt> stmts, Integer stmtId, String methodSignature) {
      
        this.immediate = immediate;  
      
        this.min = min;  
      
        this.max = max;  
      
        this.stmts = stmts;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("immediate", immediate.createVallangInstance(vf));
       
       map.put("min", vf.integer(min));
       
       map.put("max", vf.integer(max));
       
       IList iv_stmts = vf.list();
       
       for(CaseStmt v: stmts) {
        iv_stmts = iv_stmts.append(v.createVallangInstance(vf));   
       }
       map.put("stmts", iv_stmts);
               
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         immediate.getVallangConstructor(), tf.integerType(), tf.integerType(), tf.listType(tf.valueType()), tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_lookupSwitch(Immediate immediate, List<CaseStmt> stmts, Integer stmtId, String methodSignature) {
      
        this.immediate = immediate;  
      
        this.stmts = stmts;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("immediate", immediate.createVallangInstance(vf));
       
       IList iv_stmts = vf.list();
       
       for(CaseStmt v: stmts) {
        iv_stmts = iv_stmts.append(v.createVallangInstance(vf));   
       }
       map.put("stmts", iv_stmts);
               
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         immediate.getVallangConstructor(), tf.listType(tf.valueType()), tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_identity(String local, String identifier, Type idType, Integer stmtId, String methodSignature) {
      
        this.local = local;  
      
        this.identifier = identifier;  
      
        this.idType = idType;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("local", vf.string(local));
       
       map.put("identifier", vf.string(identifier));
       
       map.put("idType", idType.createVallangInstance(vf));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType(), tf.stringType(), idType.getVallangConstructor(), tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_identityNoType(String local, String identifier, Integer stmtId, String methodSignature) {
      
        this.local = local;  
      
        this.identifier = identifier;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("local", vf.string(local));
       
       map.put("identifier", vf.string(identifier));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType(), tf.stringType(), tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_assign(Variable var, Expression expression, Integer stmtId, String methodSignature) {
      
        this.var = var;  
      
        this.expression = expression;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("var", var.createVallangInstance(vf));
       
       map.put("expression", expression.createVallangInstance(vf));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         var.getVallangConstructor(), expression.getVallangConstructor(), tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_ifStmt(Expression exp, String target, Integer stmtId, String methodSignature) {
      
        this.exp = exp;  
      
        this.target = target;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("exp", exp.createVallangInstance(vf));
       
       map.put("target", vf.string(target));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         exp.getVallangConstructor(), tf.stringType(), tf.integerType(), tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "ifStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_retEmptyStmt extends Statement {
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_retEmptyStmt(Integer stmtId, String methodSignature) {
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_retStmt(Immediate immediate, Integer stmtId, String methodSignature) {
      
        this.immediate = immediate;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("immediate", immediate.createVallangInstance(vf));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         immediate.getVallangConstructor(), tf.integerType(), tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "retStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_returnEmptyStmt extends Statement {
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_returnEmptyStmt(Integer stmtId, String methodSignature) {
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_returnStmt(Immediate immediate, Integer stmtId, String methodSignature) {
      
        this.immediate = immediate;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("immediate", immediate.createVallangInstance(vf));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         immediate.getVallangConstructor(), tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_throwStmt(Immediate immediate, Integer stmtId, String methodSignature) {
      
        this.immediate = immediate;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("immediate", immediate.createVallangInstance(vf));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         immediate.getVallangConstructor(), tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_invokeStmt(InvokeExp invokeExpression, Integer stmtId, String methodSignature) {
      
        this.invokeExpression = invokeExpression;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("invokeExpression", invokeExpression.createVallangInstance(vf));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         invokeExpression.getVallangConstructor(), tf.integerType(), tf.stringType()
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
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_gotoStmt(String target, Integer stmtId, String methodSignature) {
      
        this.target = target;  
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("target", vf.string(target));
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType(), tf.integerType(), tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "gotoStmt";
     }
   }
   
   @EqualsAndHashCode
   public static class c_nop extends Statement {
     
     public Integer stmtId;
     
     public String methodSignature;
     
     public c_nop(Integer stmtId, String methodSignature) {
      
        this.stmtId = stmtId;  
      
        this.methodSignature = methodSignature;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       HashMap<String, IValue> map = new HashMap<>(); 
       
       
       map.put("stmtId", vf.integer(stmtId));
       
       map.put("methodSignature", vf.string(methodSignature));
       
         
       return vf.constructor(getVallangConstructor()).asWithKeywordParameters().setParameters(map); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.integerType(), tf.stringType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "nop";
     }
   }
    
    
}