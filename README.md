# CompilerDesign
A 5 step compiler for minijava, a subset of java.

MiniJava is a subset of Java. The meaning of a MiniJava program is given by its meaning as a Java program. Overloading is not allowed in MiniJava. The MiniJava statement System.out.println( ... ); can only print integers. The MiniJava expression e1 && e2 is of type boolean, and both e1 and e2 must be of type boolean.

Specification

                     Goal ::= MainClass ( TypeDeclaration )* <EOF>
                MainClass ::= "class" Identifier "{" "public" "static" "void" "main" "(" "String" "[" "]" Identifier ")" "{" PrintStatement "}" "}"
          TypeDeclaration ::= ClassDeclaration
                            | ClassExtendsDeclaration
         ClassDeclaration ::= "class" Identifier "{" ( VarDeclaration )* ( MethodDeclaration )* "}"
  ClassExtendsDeclaration ::= "class" Identifier "extends" Identifier "{" ( VarDeclaration )* ( MethodDeclaration )* "}"
           VarDeclaration ::= Type Identifier ";"
        MethodDeclaration ::= AccessType Type Identifier "(" ( FormalParameterList )? ")" "{" ( VarDeclaration )* ( Statement )* "return" Expression ";" "}"
      FormalParameterList ::= FormalParameter ( FormalParameterRest )*
          FormalParameter ::= Type Identifier
      FormalParameterRest ::= "," FormalParameter
                     Type ::= ArrayType
                            | BooleanType
                            | IntegerType
                            | Identifier
               AccessType ::= PublicType
                            | PrivateType
                            | ProtectedType
                ArrayType ::= "int" "[" "]"
              BooleanType ::= "boolean"
              IntegerType ::= "int"
               PublicType ::= "public"
             PrivatedType ::= "private"
            ProtectedType ::= "protected"
                Statement ::= Block
                            | AssignmentStatement
                            | ArrayAssignmentStatement
                            | IfStatement
                            | WhileStatement
                            | PrintStatement
                    Block ::= "{" ( Statement )* "}"
      AssignmentStatement ::= Identifier "=" Expression ";"
 ArrayAssignmentStatement ::= Identifier "[" Expression "]" "=" Expression ";"
              IfStatement ::= IfthenElseStatement
                            | IfthenStatement
          IfthenStatement ::= "if" "(" Expression ")" Statement
      IfthenElseStatement ::= "if" "(" Expression ")" Statement "else" Statement
           WhileStatement ::= "while" "(" Expression ")" Statement
           PrintStatement ::= "System.out.println" "(" Expression ")" ";"
               Expression ::= OrExpression
                            | AndExpression
                            | CompareExpression
                            | neqExpression
                            | PlusExpression
                            | MinusExpression
                            | TimesExpression
                            | DivExpression
                            | ArrayLookup
                            | ArrayLength
                            | MessageSend
                            | TernaryExpression
                            | PrimaryExpression
            AndExpression ::= PrimaryExpression "&&" PrimaryExpression
             OrExpression ::= PrimaryExpression "||" PrimaryExpression
        CompareExpression ::= PrimaryExpression "<=" PrimaryExpression
            neqExpression ::= PrimaryExpression "!=" PrimaryExpression
           PlusExpression ::= PrimaryExpression "+" PrimaryExpression
          MinusExpression ::= PrimaryExpression "-" PrimaryExpression
          TimesExpression ::= PrimaryExpression "*" PrimaryExpression
            DivExpression ::= PrimaryExpression "/" PrimaryExpression
              ArrayLookup ::= PrimaryExpression "[" PrimaryExpression "]"
              ArrayLength ::= PrimaryExpression "." "length"
              MessageSend ::= PrimaryExpression "." Identifier "(" ( ExpressionList )? ")"
        TernaryExpression ::= PrimaryExpression "?" PrimaryExpression ":" PrimaryExpression
           ExpressionList ::= Expression ( ExpressionRest )*
           ExpressionRest ::= "," Expression
        PrimaryExpression ::= IntegerLiteral
                            | TrueLiteral
                            | FalseLiteral
                            | Identifier
                            | ThisExpression
                            | ArrayAllocationExpression
                            | AllocationExpression
                            | NotExpression
                            | BracketExpression
           IntegerLiteral ::= <INTEGER_LITERAL>
              TrueLiteral ::= "true"
             FalseLiteral ::= "false"
               Identifier ::= <IDENTIFIER>
           ThisExpression ::= "this"
ArrayAllocationExpression ::= "new" "int" "[" Expression "]"
     AllocationExpression ::= "new" Identifier "(" ")"
            NotExpression ::= "!" Expression
        BracketExpression ::= "(" Expression ")"
           IdentifierList ::= Identifier ( IdentifierRest )*
           IdentifierRest ::= "," Identifier
