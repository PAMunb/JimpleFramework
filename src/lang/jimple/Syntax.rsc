module lang::jimple::Syntax

alias Name = str;
alias Label = str;
alias Identifier = str; 

data Immediate 
 = local(str local) 
 | intValue(int iv)
 | floatValue(real fv)
 | stringValue(str sv)
 | nullValue(); 
 
data ClassOrInterfaceDeclaration 
 = class(Type \type,
 	 list[Modifier] modifiers = [],
     Type super = object(),
     list[Type] interfaces = [],
     list[Field] fields = [],
     list[Method] methods = []
   ) 
 | interface(list[Modifier] modifiers,
     Type \type, 
     list[Type] interfaces, 
     list[Field] fields,
     list[Method] methods
   );    
 
ClassOrInterfaceDeclaration basicClassConstructor(Type \type) = class([], \type, object(), [], [], []); 

ClassOrInterfaceDeclaration basicInterfaceConstructor(Type \type) = interface([], \type, [], [], []); 

data Field 
  = field(list[Modifier] modifiers, Type \type, Name name)
  ;  

data Method 
  = method(list[Modifier] modifiers, Type \type, Name name, list[Formal] formals, list[Type] exceptions, MethodBody body)
  ;
  
data Formal 
  = foramlArg(Type \type)
  ; 
     
data MethodBody 
  = methodBody(list[Declaration] decls, list[Statement] stmts)//, list[CatchClause] catchClauses)
  ; 

data Declaration 
  = declaration(Type \type, Identifier local)
  ; 

data Statement  
  = label(Label label)  
  | breakpoint()
  | enterMonitor(Immediate immediate)
  | exitMonitor(Immediate immediate)
  | tableSwitch(Immediate immediate, list[CaseStmt] stmts)
  | lookupSwitch(Immediate immediate, list[CaseStmt] stmts)
  | identity(Name local, Name identifier, Type \type)
  | identityNoType(Name local, Name identifier)
  | assign(Name variable, Expression exp)
  | ifStmt(Expression exp, GotoStmt stmt)
  | retEmptyStmt()
  | retStmt(Immediate immediate)
  | returnEmptyStmt() 
  | returnStmt(Immediate immediate)
  | throwStmt(Immediate immediate)
  | invokeStmt(InvokeExp expression)
  ;        
 
 data CaseStmt 
   = \case(int const, GotoStmt targetStmt) 
   | \default(GotoStmt targetStmt)
   ; 

data GotoStmt = goto(Label label); 

data Expression 
  = newInstance(Type \type)
  | newArray(Type \type, list[ArrayDescriptor] dims)
  | cast(Type \type, Immediate immeadiate)
  | instanceOf(Type \type, Immediate immediate)
  | invokeExp(InvokeExp expression)
  | arraySubscript(Identifier name, Immediate immediate)
  | stringSubscript(str string, Immediate immediate)
  | localFieldRef(Name local, Name className, Type fieldType, Name fieldName)
  | fieldRef(Name className, Type fieldType, Name fieldName)
  | and(Immediate lhs, Immediate rhs)
  | or(Immediate lhs, Immediate rhs)
  | xor(Immediate lhs, Immediate rhs)
  | \mod(Immediate lhs, Immediate rhs)
  | cmp(Immediate lhs, Immediate rhs) 
  | cmpg(Immediate lhs, Immediate rhs) 
  | cmpl(Immediate lhs, Immediate rhs)
  | cmpeq(Immediate lhs, Immediate rhs) 
  | cmpne(Immediate lhs, Immediate rhs) 
  | cmpgt(Immediate lhs, Immediate rhs) 
  | cmpge(Immediate lhs, Immediate rhs)
  | cmplt(Immediate lhs, Immediate rhs) 
  | cmple(Immediate lhs, Immediate rhs)
  | shl(Immediate lhs, Immediate rhs) 
  | shr(Immediate lhs, Immediate rhs) 
  | ushr(Immediate lhs, Immediate rhs)
  | plus(Immediate lhs, Immediate rhs) 
  | minus(Immediate lhs, Immediate rhs) 
  | mult(Immediate lhs, Immediate rhs) 
  | div(Immediate lhs, Immediate rhs)
  | lengthOf(Immediate immediate)
  | neg(Immediate) 
  | immediate(Immediate immediate)
  ;
  
data ArrayDescriptor 
  = fixedSize(int size)
  | variableSize() 
  ;
  
data InvokeExp
  = instanceMethodInvoke(Name local, MethodSignature signature1, list[Immediate] args)
  | staticMethodInvoke(MethodSignature signature2, list[Immediate] args)
  | dynamicInvoke(str string, UnnamedMethodSignature signature3, list[Immediate] args1, MethodSignature, list[Immediate] args2)
  ;   

data MethodSignature 
  = methodSignature(Name className, Type \type, list[Formal] formals)
  ; 
  
data UnnamedMethodSignature 
  = unnamedMethodSignature(Type \type, list[Formal] formals)
  ;   
    
data Modifier 
  = Abstract()
  | Final()
  | Native()
  | Public() 
  | Protected() 
  | Private() 
  | Static() 
  | Synchronized() 
  | Transient() 
  | Volatile() 
  | Strictfp() 
  | Enum() 
  | Annotation()
  ;
  
/**
 * I think that we will have to review this 
 * type declaration.  
 */  
data Type
  = byte()
  | boolean()
  | short()
  | character()
  | integer()
  | float()
  | double()
  | long()
  | object(str name)  
  | array(Type arg)
  | \void()
  | string()
  | null_type()
  | unknown()            // it might be useful in the first phase of Jimple Body creation 
  ;  
  
Type object() = object("java.lang.Object");