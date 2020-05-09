package lang.jimple.internal.generated;

import lang.jimple.internal.JimpleAbstractDataType; 
import java.util.List; 
import java.util.HashMap;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory; 

public abstract class ClassOrInterfaceDeclaration extends JimpleAbstractDataType {
   @Override 
   public String getBaseType() { 
     return "ClassOrInterfaceDeclaration";
   } 

   
   public static ClassOrInterfaceDeclaration classDecl(Type typeName, List<Modifier> modifiers, Type superClass, List<Type> interfaces, List<Field> fields, List<Method> methods)  {
     return new c_classDecl(typeName, modifiers, superClass, interfaces, fields, methods);
   }
   
   public static ClassOrInterfaceDeclaration interfaceDecl(Type typeName, List<Modifier> modifiers, List<Type> interfaces, List<Field> fields, List<Method> methods)  {
     return new c_interfaceDecl(typeName, modifiers, interfaces, fields, methods);
   }
    

   
   public static class c_classDecl extends ClassOrInterfaceDeclaration {
     
     public Type typeName;
     
     public List<Modifier> modifiers;
     
     public Type superClass;
     
     public List<Type> interfaces;
     
     public List<Field> fields;
     
     public List<Method> methods;
     
   
     public c_classDecl(Type typeName, List<Modifier> modifiers, Type superClass, List<Type> interfaces, List<Field> fields, List<Method> methods) {
      
        this.typeName = typeName;  
      
        this.modifiers = modifiers;  
      
        this.superClass = superClass;  
      
        this.interfaces = interfaces;  
      
        this.fields = fields;  
      
        this.methods = methods;  
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       IValue iv_typeName = typeName.createVallangInstance(vf);
       
       IList iv_modifiers = vf.list();
       
       for(Modifier v: modifiers) {
        iv_modifiers = iv_modifiers.append(v.createVallangInstance(vf));   
       }
               
       
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
                
                , iv_typeName 
                
                , iv_modifiers 
                
                , iv_superClass 
                
                , iv_interfaces 
                
                , iv_fields 
                
                , iv_methods 
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "classDecl";
     }
   }
   
   public static class c_interfaceDecl extends ClassOrInterfaceDeclaration {
     
     public Type typeName;
     
     public List<Modifier> modifiers;
     
     public List<Type> interfaces;
     
     public List<Field> fields;
     
     public List<Method> methods;
     
   
     public c_interfaceDecl(Type typeName, List<Modifier> modifiers, List<Type> interfaces, List<Field> fields, List<Method> methods) {
      
        this.typeName = typeName;  
      
        this.modifiers = modifiers;  
      
        this.interfaces = interfaces;  
      
        this.fields = fields;  
      
        this.methods = methods;  
        
     }
     
     @Override
     public IConstructor createVallangInstance(IValueFactory vf) {
   
       
       IValue iv_typeName = typeName.createVallangInstance(vf);
       
       IList iv_modifiers = vf.list();
       
       for(Modifier v: modifiers) {
        iv_modifiers = iv_modifiers.append(v.createVallangInstance(vf));   
       }
               
       
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
                
                , iv_typeName 
                
                , iv_modifiers 
                
                , iv_interfaces 
                
                , iv_fields 
                
                , iv_methods 
                
                ); 
     }
     @Override
     public String getConstructor() {
       return "interfaceDecl";
     }
   }
    
}