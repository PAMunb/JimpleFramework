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
 * Java representation of the InvokeExp construct. 
 * 
 * @see lang::jimple::core::Syntax
 * @see lang::jimple::decompiler::internal::RascalJavaConverter
 */ 

@EqualsAndHashCode
public abstract class InvokeExp extends JimpleAbstractDataType {
  
   @Override 
   public String getBaseType() { 
     return "InvokeExp";
   } 
   
   
   public static InvokeExp specialInvoke(String local, MethodSignature sig, List<Immediate> args)  {
     return new c_specialInvoke(local, sig, args);
   }
   
   public static InvokeExp virtualInvoke(String local, MethodSignature sig, List<Immediate> args)  {
     return new c_virtualInvoke(local, sig, args);
   }
   
   public static InvokeExp interfaceInvoke(String local, MethodSignature sig, List<Immediate> args)  {
     return new c_interfaceInvoke(local, sig, args);
   }
   
   public static InvokeExp staticMethodInvoke(MethodSignature sig, List<Immediate> args)  {
     return new c_staticMethodInvoke(sig, args);
   }
   
   public static InvokeExp dynamicInvoke(MethodSignature bsmSig, List<Immediate> bsmArgs, MethodSignature sig, List<Immediate> args)  {
     return new c_dynamicInvoke(bsmSig, bsmArgs, sig, args);
   }
    
   
   @EqualsAndHashCode
   public static class c_specialInvoke extends InvokeExp {
     
     public String local;
     
     public MethodSignature sig;
     
     public List<Immediate> args;
     
     public c_specialInvoke(String local, MethodSignature sig, List<Immediate> args) {
      
        this.local = local;  
      
        this.sig = sig;  
      
        this.args = args;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_local = vf.string(local);
       
         IValue iv_sig = sig.createVallangInstance(vf);
       
         IList iv_args = vf.list();
         
         for(Immediate v: args) {
          iv_args = iv_args.append(v.createVallangInstance(vf));   
         }
                 
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_local 
          
            , iv_sig 
          
            , iv_args 
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType(), sig.getVallangConstructor(), tf.listType(tf.valueType())
       };
     }
    
     @Override
     public String getConstructor() {
       return "specialInvoke";
     }
   }
   
   @EqualsAndHashCode
   public static class c_virtualInvoke extends InvokeExp {
     
     public String local;
     
     public MethodSignature sig;
     
     public List<Immediate> args;
     
     public c_virtualInvoke(String local, MethodSignature sig, List<Immediate> args) {
      
        this.local = local;  
      
        this.sig = sig;  
      
        this.args = args;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_local = vf.string(local);
       
         IValue iv_sig = sig.createVallangInstance(vf);
       
         IList iv_args = vf.list();
         
         for(Immediate v: args) {
          iv_args = iv_args.append(v.createVallangInstance(vf));   
         }
                 
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_local 
          
            , iv_sig 
          
            , iv_args 
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType(), sig.getVallangConstructor(), tf.listType(tf.valueType())
       };
     }
    
     @Override
     public String getConstructor() {
       return "virtualInvoke";
     }
   }
   
   @EqualsAndHashCode
   public static class c_interfaceInvoke extends InvokeExp {
     
     public String local;
     
     public MethodSignature sig;
     
     public List<Immediate> args;
     
     public c_interfaceInvoke(String local, MethodSignature sig, List<Immediate> args) {
      
        this.local = local;  
      
        this.sig = sig;  
      
        this.args = args;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_local = vf.string(local);
       
         IValue iv_sig = sig.createVallangInstance(vf);
       
         IList iv_args = vf.list();
         
         for(Immediate v: args) {
          iv_args = iv_args.append(v.createVallangInstance(vf));   
         }
                 
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_local 
          
            , iv_sig 
          
            , iv_args 
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         tf.stringType(), sig.getVallangConstructor(), tf.listType(tf.valueType())
       };
     }
    
     @Override
     public String getConstructor() {
       return "interfaceInvoke";
     }
   }
   
   @EqualsAndHashCode
   public static class c_staticMethodInvoke extends InvokeExp {
     
     public MethodSignature sig;
     
     public List<Immediate> args;
     
     public c_staticMethodInvoke(MethodSignature sig, List<Immediate> args) {
      
        this.sig = sig;  
      
        this.args = args;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_sig = sig.createVallangInstance(vf);
       
         IList iv_args = vf.list();
         
         for(Immediate v: args) {
          iv_args = iv_args.append(v.createVallangInstance(vf));   
         }
                 
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_sig 
          
            , iv_args 
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         sig.getVallangConstructor(), tf.listType(tf.valueType())
       };
     }
    
     @Override
     public String getConstructor() {
       return "staticMethodInvoke";
     }
   }
   
   @EqualsAndHashCode
   public static class c_dynamicInvoke extends InvokeExp {
     
     public MethodSignature bsmSig;
     
     public List<Immediate> bsmArgs;
     
     public MethodSignature sig;
     
     public List<Immediate> args;
     
     public c_dynamicInvoke(MethodSignature bsmSig, List<Immediate> bsmArgs, MethodSignature sig, List<Immediate> args) {
      
        this.bsmSig = bsmSig;  
      
        this.bsmArgs = bsmArgs;  
      
        this.sig = sig;  
      
        this.args = args;  
        
     } 
    
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
       
         IValue iv_bsmSig = bsmSig.createVallangInstance(vf);
       
         IList iv_bsmArgs = vf.list();
         
         for(Immediate v: bsmArgs) {
          iv_bsmArgs = iv_bsmArgs.append(v.createVallangInstance(vf));   
         }
                 
       
         IValue iv_sig = sig.createVallangInstance(vf);
       
         IList iv_args = vf.list();
         
         for(Immediate v: args) {
          iv_args = iv_args.append(v.createVallangInstance(vf));   
         }
                 
       
         
          return vf.constructor(getVallangConstructor()
          
            , iv_bsmSig 
          
            , iv_bsmArgs 
          
            , iv_sig 
          
            , iv_args 
          
          ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
         bsmSig.getVallangConstructor(), tf.listType(tf.valueType()), sig.getVallangConstructor(), tf.listType(tf.valueType())
       };
     }
    
     @Override
     public String getConstructor() {
       return "dynamicInvoke";
     }
   }
    
    
}