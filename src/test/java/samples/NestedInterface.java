package samples;

interface MyInterfaceA{  
    void display();  
}  
      
class NestedInterface 
    implements MyInterfaceA{  
     public void display(){
         System.out.println("Nested interface method");
     }  
      
     public static void main(String args[]){  
         MyInterfaceA obj=
                 new NestedInterface(); 
      obj.display();  
     }  
}