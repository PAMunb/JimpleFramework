package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import java.util.HashMap;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

public abstract class InvokeExp extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "InvokeExp";
   } 

   
   public static InvokeExp instanceMethodInvoke(String local, MethodSignature sig, List<Immediate> args)  {
     return new c_instanceMethodInvoke(local, sig, args);
   }
   
   public static InvokeExp staticMethodInvoke(MethodSignature sig, List<Immediate> args)  {
     return new c_staticMethodInvoke(sig, args);
   }
   
   public static InvokeExp dynamicInvoke(String string, UnnamedMethodSignature usig, List<Immediate> args1, MethodSignature sig, List<Immediate> args2)  {
     return new c_dynamicInvoke(string, usig, args1, sig, args2);
   }
    

   
   public static class c_instanceMethodInvoke extends InvokeExp {
     
     public String local;
     
     public MethodSignature sig;
     
     public List<Immediate> args;
     
   
     public c_instanceMethodInvoke(String local, MethodSignature sig, List<Immediate> args) {
      
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
     public String getConstructor() {
       return "instanceMethodInvoke";
     }
   }
   
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
     public String getConstructor() {
       return "staticMethodInvoke";
     }
   }
   
   public static class c_dynamicInvoke extends InvokeExp {
     
     public String string;
     
     public UnnamedMethodSignature usig;
     
     public List<Immediate> args1;
     
     public MethodSignature sig;
     
     public List<Immediate> args2;
     
   
     public c_dynamicInvoke(String string, UnnamedMethodSignature usig, List<Immediate> args1, MethodSignature sig, List<Immediate> args2) {
      
        this.string = string;  
      
        this.usig = usig;  
      
        this.args1 = args1;  
      
        this.sig = sig;  
      
        this.args2 = args2;  
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       IValue iv_string = vf.string(string);
       
       IValue iv_usig = usig.createVallangInstance(vf);
       
       IList iv_args1 = vf.list();
       
       for(Immediate v: args1) {
        iv_args1 = iv_args1.append(v.createVallangInstance(vf));   
       }
               
       
       IValue iv_sig = sig.createVallangInstance(vf);
       
       IList iv_args2 = vf.list();
       
       for(Immediate v: args2) {
        iv_args2 = iv_args2.append(v.createVallangInstance(vf));   
       }
               
       
       
       return vf.constructor(getVallangConstructor()
                
                , iv_string 
                
                , iv_usig 
                
                , iv_args1 
                
                , iv_sig 
                
                , iv_args2 
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "dynamicInvoke";
     }
   }
    
}