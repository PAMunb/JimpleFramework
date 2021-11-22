package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 

import lombok.*; 

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 


@EqualsAndHashCode
public abstract class ClassOrInterfaceDeclaration extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "ClassOrInterfaceDeclaration";
   } 

   
   
   public static ClassOrInterfaceDeclaration classDecl(List<Modifier> modifiers, Type classType, Type superClass, List<Type> interfaces, List<Field> fields, List<Method> methods)  {
     return new c_classDecl(modifiers, classType, superClass, interfaces, fields, methods);
   }
   
   public static ClassOrInterfaceDeclaration interfaceDecl(List<Modifier> modifiers, Type interfaceType, List<Type> interfaces, List<Field> fields, List<Method> methods)  {
     return new c_interfaceDecl(modifiers, interfaceType, interfaces, fields, methods);
   }
    

   
   @EqualsAndHashCode
   public static class c_classDecl extends ClassOrInterfaceDeclaration {
     
     public List<Modifier> modifiers;
     
     public Type classType;
     
     public Type superClass;
     
     public List<Type> interfaces;
     
     public List<Field> fields;
     
     public List<Method> methods;
     
   
       public c_classDecl(List<Modifier> modifiers, Type classType, Type superClass, List<Type> interfaces, List<Field> fields, List<Method> methods) {
        
          this.modifiers = modifiers;  
        
          this.classType = classType;  
        
          this.superClass = superClass;  
        
          this.interfaces = interfaces;  
        
          this.fields = fields;  
        
          this.methods = methods;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IList iv_modifiers = vf.list();
         
         for(Modifier v: modifiers) {
          iv_modifiers = iv_modifiers.append(v.createVallangInstance(vf));   
         }
                 
       
         IValue iv_classType = classType.createVallangInstance(vf);
       
         IValue iv_superClass = superClass.createVallangInstance(vf);
       
         IList iv_interfaces = vf.list();
         
         for(Type v: interfaces) {
          iv_interfaces = iv_interfaces.append(v.createVallangInstance(vf));   
         }
                 
       
         IList iv_fields = vf.list();
         
         for(Field v: fields) {
          iv_fields = iv_fields.append(v.createVallangInstance(vf));   
         }
                 
       
         IList iv_methods = vf.list();
         
         for(Method v: methods) {
          iv_methods = iv_methods.append(v.createVallangInstance(vf));   
         }
                 
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_modifiers 
               
                , iv_classType 
               
                , iv_superClass 
               
                , iv_interfaces 
               
                , iv_fields 
               
                , iv_methods 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.listType(), classType.getVallangConstructor(), superClass.getVallangConstructor(), tf.listType(), tf.listType(), tf.listType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "classDecl";
     }
   }
   
   @EqualsAndHashCode
   public static class c_interfaceDecl extends ClassOrInterfaceDeclaration {
     
     public List<Modifier> modifiers;
     
     public Type interfaceType;
     
     public List<Type> interfaces;
     
     public List<Field> fields;
     
     public List<Method> methods;
     
   
       public c_interfaceDecl(List<Modifier> modifiers, Type interfaceType, List<Type> interfaces, List<Field> fields, List<Method> methods) {
        
          this.modifiers = modifiers;  
        
          this.interfaceType = interfaceType;  
        
          this.interfaces = interfaces;  
        
          this.fields = fields;  
        
          this.methods = methods;  
          
       } 
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
     
       
         IList iv_modifiers = vf.list();
         
         for(Modifier v: modifiers) {
          iv_modifiers = iv_modifiers.append(v.createVallangInstance(vf));   
         }
                 
       
         IValue iv_interfaceType = interfaceType.createVallangInstance(vf);
       
         IList iv_interfaces = vf.list();
         
         for(Type v: interfaces) {
          iv_interfaces = iv_interfaces.append(v.createVallangInstance(vf));   
         }
                 
       
         IList iv_fields = vf.list();
         
         for(Field v: fields) {
          iv_fields = iv_fields.append(v.createVallangInstance(vf));   
         }
                 
       
         IList iv_methods = vf.list();
         
         for(Method v: methods) {
          iv_methods = iv_methods.append(v.createVallangInstance(vf));   
         }
                 
       
         
       return vf.constructor(getVallangConstructor()
                
                , iv_modifiers 
               
                , iv_interfaceType 
               
                , iv_interfaces 
               
                , iv_fields 
               
                , iv_methods 
               
                ); 
     }
   
     @Override
     public io.usethesource.vallang.type.Type[] children() {
       return new io.usethesource.vallang.type.Type[] { 
           tf.listType(), interfaceType.getVallangConstructor(), tf.listType(), tf.listType(), tf.listType()
       };
     }
    
     @Override
     public String getConstructor() {
       return "interfaceDecl";
     }
   }
    
    
}