module lang::jimple::core::ConcreteSyntax


start syntax JimpleClassOrInterfaceDeclaration 
  = classDecl: JimpleModifier* modifiers "class" JimpleType classType "extends" JimpleType superClass  ("implements" {JimpleType ","}+)? interfaces
    "{"
        JimpleField* fields
        JimpleMethod*  methods
    "}" 
  | interfaceDecl: JimpleModifier* modifiers "interface" JimpleType interfaceType ("extends" {JimpleType ","}+)? interfaces 
    "{"
    	JimpleField* fields 
    	JimpleMethod*  methods
    "}"
  ;
     

syntax JimpleField = field: JimpleModifier* modifiers JimpleType fieldtype ID name ";";

syntax JimpleMethod = method: JimpleModifier* modifiers JimpleType returnType ID name "(" {JimpleType ","}* formals ")" ("throws" {JimpleType ","}*)? exceptions JimpleMethodBody body;

syntax JimpleMethodBody 
  = signatureOnly: ";"
  ;
                      
syntax JimpleType 
  = TByte: "byte"
  | TBoolean: "boolean"
  | TShort: "short"
  | TCharacter: "char"
  | TInteger: "int"
  | TFloat: "float"
  | TDouble: "double"
  | TLong: "long"
  | TObject: QualifiedName
  | TVoid: "void" 
  ;


syntax JimpleModifier 
  = Public: "public"
  | Protected: "protected"
  | Private: "private"  
  | Abstract: "abstract"
  | Static: "static"  
  | Final: "final"
  | Synchronized: "synchronized"
  | Native: "native"
  | Strictfp: "strictfp"
  | Transient: "transient"
  | Volatile: "volatile"
  | Enum: "enum"
  | Annotation: "annotation"
  | Synthetic: "synthetic"
  ;



// Lexical Definitions 


lexical QualifiedName = ID \ Keyword
                      | (ID "." QualifiedName) \ Keyword; 

lexical SignedInteger =
  [+ \-]? [0-9]+ 
  ;
  
lexical LEX_StringLiteral =
   string: "\"" StringPart* "\"" 
  ;

lexical HexaSignificand =
  [0] [X x] [0-9 A-F a-f]* "." [0-9 A-F a-f]* 
  | [0] [X x] [0-9 A-F a-f]+ 
  ;

lexical OctaNumeral =
  [0] [0-7]+ 
  ;

lexical HexaNumeral =
  [0] [X x] [0-9 A-F a-f]+ 
  ;
  
lexical LEX_CharLiteral =
   char: "\'" CharContent "\'" 
  ;

lexical EscChar =
  "\\" 
  ;

lexical OctaEscape 
  = "\\" [0-3] [0-7]+ !>> [0-7] 
  | "\\" [0-7] !>> [0-7] 
  | "\\" [4-7] [0-7] 
  ;

lexical EscEscChar =
  "\\\\" 
  ;

lexical DeciNumeral =
  "0"
  | [1-9]
  | [1-9] [0-9 _]* [0-9];
 
 
keyword HexaSignificandKeywords =
  [0] [X x] "." 
  ;

lexical BinaryNumeral =
  "0" [b B] [0-1] [0-1 _]* !>> [0-1]*
  ;

lexical StringChars =
  FooStringChars 
  ;

lexical LAYOUT =
  [\t-\n \a0C-\a0D \ ] 
  | Comment 
  ;

lexical CharContent =
  EscapeSeq 
  | UnicodeEscape 
  |  single: SingleChar 
  ;

lexical Comment =
  "/**/" 
  | "//" EOLCommentChars !>> ![\n \a0D] LineTerminator 
  | "/*" !>> [*] CommentPart* "*/" 
  | "/**" !>> [/] CommentPart* "*/" 
  ;

syntax FloatingPointLiteral =
   float: HexaFloatLiteral !>> [D F d f] 
  |  float: DeciFloatLiteral \ DeciFloatLiteralKeywords !>> [D F d f] 
  ;

lexical OctaLiteral =
  OctaNumeral !>> [0-7] [L l]? 
  ;

lexical HexaFloatNumeral =
  HexaSignificand \ HexaSignificandKeywords !>> [0-9 A-F a-f] BinaryExponent 
  ;

syntax IntegerLiteral =
   hexa: HexaLiteral !>> [L l.] 
  |  octa: OctaLiteral !>> [L l] 
  |  deci: DeciLiteral !>> [L l] 
  |  binary: BinaryIntegerLiteral !>> [L l]
  ;

lexical HexaLiteral =
  HexaNumeral !>> [0-9 A-F a-f] [L l]? 
  ;

lexical DeciFloatLiteral =
  DeciFloatNumeral [D F d f]? 
  ;
  
lexical BinaryIntegerLiteral =
  BinaryNumeral [L l]?
  ; 
  
lexical ID =
	// Yes, this would be more correct, but REALLY slow at the moment
	//JavaLetter JavaLetterDigits* 
	//
	// therefore we go the ascii route:
  [$ A-Z _ a-z] [$ 0-9 A-Z _ a-z]* 
  ; 
  
lexical DeciFloatDigits =
  [0-9]+ 
  | [0-9]* "." [0-9]* 
  ;

lexical DeciLiteral =
  DeciNumeral !>> [. 0-9 D F d f] [L l]? 
  ;

lexical EscapeSeq =
  NamedEscape 
  | OctaEscape 
  ;

layout LAYOUTLIST  =
  LAYOUT* !>> [\t-\n \a0C-\a0D \ ] !>> (  [/]  [*]  ) !>> (  [/]  [/]  ) !>> "/*" !>> "//"
  ;

lexical NamedEscape =
   namedEscape: "\\" [\" \' \\ b f n r t] 
  ;
 
 
lexical BinaryExponent =
  [P p] SignedInteger !>> [0-9] 
  ;

lexical BlockCommentChars =
  ![* \\]+ 
  ;
  
  
keyword Keyword =
   "package" 
  | "short" 
  | "boolean" 
  | "extends" 
  | "strictfp" 
  | "if" 
  | "enum" 
  | "synchronized" 
  | "interface" 
  | "return" 
  | "private" 
  | "volatile" 
  | "throws" 
  | "static" 
  | "long" 
  | "throw" 
  | "this" 
  | "catch" 
  | "super" 
  | "const" 
  | "switch" 
  | "int" 
  | "implements" 
  | "native" 
  | "abstract" 
  | "goto" 
  | "final" 
  | "class" 
  | "byte" 
  | "instanceof" 
  | "void" 
  | "finally" 
  | "try" 
  | "new" 
  | "float" 
  | "public" 
  | "transient" 
  | "char" 
  | "assert" 
  | "case" 
  | "double" 
  | "protected" 
  | "import" 
  ;

lexical FooStringChars =
  ([\a00] | ![\n \a0D \" \\])+ 
  ;

lexical StringPart =
  UnicodeEscape 
  | EscapeSeq 
  |  chars: StringChars !>> ![\n \a0D \" \\]  !>> [\a00]
  ;

keyword FieldAccessKeywords =
  ExpressionName "." ID 
  ;

lexical EOLCommentChars =
  ![\n \a0D]* 
  ;

lexical SingleChar =
  ![\n \a0D \' \\] 
  ;

keyword ElemValKeywords =
  LeftHandSide "=" Expression 
  ;

lexical CommentPart =
  UnicodeEscape 
  | BlockCommentChars !>> ![* \\] 
  | EscChar !>> [\\ u] 
  | Asterisk !>> [/] 
  | EscEscChar 
  ;

syntax Identifier =
   id: [$ A-Z _ a-z] !<< ID \ IDKeywords !>> [$ 0-9 A-Z _ a-z] 
  ;
  
//keyword ArrayAccessKeywords =
//  ArrayCreationExpression ArrayAccess 
//  ;

syntax BooleanLiteral
  = \false: "false" 
  | \true: "true" 
  ;

lexical DeciFloatExponentPart =
  [E e] SignedInteger !>> [0-9] 
  ;

lexical EndOfFile =
  
  ;

keyword DeciFloatLiteralKeywords =
  [0-9]+ 
  ;

keyword DeciFloatDigitsKeywords =
  "." 
  ;

keyword IDKeywords =
  "null" 
  | Keyword 
  | "true" 
  | "false" 
  ;

lexical DeciFloatNumeral
	= [0-9] !<< [0-9]+ DeciFloatExponentPart
	| [0-9] !<< [0-9]+ >> [D F d f]
	| [0-9] !<< [0-9]+ "." [0-9]* !>> [0-9] DeciFloatExponentPart?
	| [0-9] !<< "." [0-9]+ !>> [0-9] DeciFloatExponentPart?
  ;

lexical CarriageReturn =
  [\a0D] 
  ;
  
lexical UnicodeEscape =
   unicodeEscape: "\\" [u]+ [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] 
  ;

lexical LineTerminator =
  [\n] 
  | EndOfFile !>> ![] 
  | [\a0D] [\n] 
  | CarriageReturn !>> [\n] 
  ;

lexical HexaFloatLiteral =
  HexaFloatNumeral [D F d f]? 
  ;

lexical Asterisk =
  "*" 
  ;
  
syntax CharacterLiteral =
  LEX_CharLiteral 
  ;  
  
syntax StringLiteral =
  LEX_StringLiteral 
  ;  
  
syntax Null = "null" ;   

syntax NullLiteral = Null ;