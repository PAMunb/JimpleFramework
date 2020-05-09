package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import java.util.HashMap;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

public abstract class Modifier extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "Modifier";
   } 

   
   public static Modifier Abstract()  {
     return new c_Abstract();
   }
   
   public static Modifier Final()  {
     return new c_Final();
   }
   
   public static Modifier Native()  {
     return new c_Native();
   }
   
   public static Modifier Public()  {
     return new c_Public();
   }
   
   public static Modifier Protected()  {
     return new c_Protected();
   }
   
   public static Modifier Private()  {
     return new c_Private();
   }
   
   public static Modifier Static()  {
     return new c_Static();
   }
   
   public static Modifier Synchronized()  {
     return new c_Synchronized();
   }
   
   public static Modifier Transient()  {
     return new c_Transient();
   }
   
   public static Modifier Volatile()  {
     return new c_Volatile();
   }
   
   public static Modifier Strictfp()  {
     return new c_Strictfp();
   }
   
   public static Modifier Enum()  {
     return new c_Enum();
   }
   
   public static Modifier Annotation()  {
     return new c_Annotation();
   }
    

   
   public static class c_Abstract extends Modifier {
     
   
     public c_Abstract() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Abstract";
     }
   }
   
   public static class c_Final extends Modifier {
     
   
     public c_Final() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Final";
     }
   }
   
   public static class c_Native extends Modifier {
     
   
     public c_Native() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Native";
     }
   }
   
   public static class c_Public extends Modifier {
     
   
     public c_Public() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Public";
     }
   }
   
   public static class c_Protected extends Modifier {
     
   
     public c_Protected() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Protected";
     }
   }
   
   public static class c_Private extends Modifier {
     
   
     public c_Private() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Private";
     }
   }
   
   public static class c_Static extends Modifier {
     
   
     public c_Static() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Static";
     }
   }
   
   public static class c_Synchronized extends Modifier {
     
   
     public c_Synchronized() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Synchronized";
     }
   }
   
   public static class c_Transient extends Modifier {
     
   
     public c_Transient() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Transient";
     }
   }
   
   public static class c_Volatile extends Modifier {
     
   
     public c_Volatile() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Volatile";
     }
   }
   
   public static class c_Strictfp extends Modifier {
     
   
     public c_Strictfp() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Strictfp";
     }
   }
   
   public static class c_Enum extends Modifier {
     
   
     public c_Enum() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Enum";
     }
   }
   
   public static class c_Annotation extends Modifier {
     
   
     public c_Annotation() {
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       
       return vf.constructor(getVallangConstructor()
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "Annotation";
     }
   }
    
}