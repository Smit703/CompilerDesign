%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>
extern int yylex();
extern void yyerror();
extern int yyparse();

struct node
{
	char *data;
	struct node *next;
};

struct list
{
	struct node *head;
	struct node *tail;
};

/*struct macro_struct
    {
        int args;
        char* argument_vals[65]; 
        struct node* to_convert;
        struct node* value_converted;
        struct macro_struct* next;
    };
*/

void insert(struct list *l, char *s)
{
	struct node *temp;
	temp = malloc(sizeof(struct node));

	temp-> data = malloc(sizeof(char)*strlen(s));
	strcpy(temp-> data, s);
	temp->next = NULL;
	
	if(l->head)
	{
		l->tail->next = temp;
		l->tail = temp;
	}
	else
	{
		l->head = temp;
		l->tail = temp;
	}
}

struct list* merge(struct list *l1, struct list *l2)
{
	if(!l2->head)
	{
		return l1;
	}	
	if(!l1->head )
	{
		return l2;
	}

	l1->tail->next = l2->head;
	l1->tail = l2->tail;
	return l1;
}

struct list* init()
{
	struct list *temp = malloc(sizeof(struct list));
	temp->head = NULL;
	temp->tail = NULL;
	return temp; 
}

void print(struct list *l)
{
	struct node *temp = l->head;
	while(temp){
		printf("%s ", temp->data);
		if(strcmp(temp->data,";") == 0)
		{
			printf("\n");
		}	
		if(strcmp(temp->data,"}") == 0)
		{
			printf("\n");
		}	
		temp = temp->next;
	}
}

struct Macrolist
{
	struct list *macro;
	struct Macrolist *next;
};

struct Macrolist *Macros = NULL;

struct list* find(char *s)
{
	struct Macrolist *temp = Macros;
	while(temp)
	{
		if(strcmp(temp->macro->head->data, s) == 0)
		{
			return temp->macro;
		}	
		temp = temp->next;
	}
	return NULL;
}

void add(struct list *l){
	l->head = l->head->next;

	struct list *Exists = find(l->head->data);
	if(Exists)
	{
		yyerror();
		exit(0);
	}

	struct Macrolist *t = malloc(sizeof(struct Macrolist));
	t-> macro = l;
	t-> next = NULL;

	if(!Macros)
	{
		Macros = t;
	}
	else
	{
		t->next = Macros;
		Macros = t;
	}
}


%}


%union 
{
    int num;
	char* string_id;
    struct list *tokenlist;
}

%token  MAIN NEW INT PUBLIC STATIC VOID CLASS STRING THIS TRUE FALSE BOOLEAN WHILE IF ELSE LENGTH PRINT EXTENDS RETURN
       PLUS MINUS MULTIPLICATION DIVISION NOT EQUAL QUESTION SEMICOLON DOT COMMA AND OR NOTEQ COMPARE LSB RSB LCB RCB
       DEFINEEXPR DEFINEEXPR0 DEFINEEXPR1 DEFINEEXPR2 DEFINESTMT DEFINESTMT0 DEFINESTMT1 DEFINESTMT2 LB RB

%token <string_id> ID INTEGR

%type <tokenlist> Goal MainClass TypeDeclaration MethodDeclaration Type Statement Expression PrimaryExpression MacroDefinition MacroStatement 
                  Identifier Integer MacroExpression MacroDef Types Star1 Methods Star2 Star5 Statements Star3 Star6 Star4 Star7
                  Ifelse Term MacroExpression0 MacroExpression1 MacroExpression2 MacroStatement0 MacroStatement1 MacroStatement2 

%nonassoc NO_ELSE
%nonassoc NO_EXPR

%start Goal

%%

Goal:  MacroDef MainClass Types 	 {
										$$ = merge($1,$2);
										$$ = merge($$,$3);
									 	print($$);
									 }

MainClass: CLASS Identifier LCB PUBLIC STATIC VOID MAIN LB STRING LSB RSB Identifier RB LCB PRINT LB Expression RB SEMICOLON RCB RCB 	
				{
					$$ = init(); 
					insert($$, "class");
					$$ = merge($$, $2);
					insert($$, "{");
					insert($$, "public");
					insert($$, "static");
					insert($$, "void");
					insert($$, "main");
					insert($$, "(");
					insert($$, "String");
					insert($$, "[");
					insert($$, "]");
					$$ = merge($$, $12);
					insert($$, ")");
					insert($$, "{");
					insert($$, "System.out.println");
					insert($$, "(");
					$$ = merge($$, $17);
					insert($$, ")");
					insert($$, ";");
					insert($$, "}");
					insert($$, "}");
				}

Types: TypeDeclaration Types		{ $$ = merge($1, $2);}
		| 							{ $$ = init(); }

TypeDeclaration: CLASS Identifier LCB Star1 Methods RCB 
				{
					$$ = init();
					insert($$, "class");
					$$ = merge($$, $2);
					insert($$, "{");
					$$ = merge($$, $4);
					$$ = merge($$, $5);
					insert($$, "}");
				}
				| CLASS Identifier EXTENDS Identifier LCB Star1 Methods RCB {
					$$ = init();
					insert($$, "class");
					$$ = merge($$, $2);
					insert($$, "extends");
					$$ = merge($$, $4);
					insert($$, "{");
					$$ = merge($$, $6);
					$$ = merge($$, $7);
					insert($$, "}");
				}

Methods: MethodDeclaration Methods	{ $$ = merge($1, $2); }
		|		{ $$ = init(); }

MethodDeclaration: PUBLIC Type Identifier LB Star5 RB LCB Star1 Statements RETURN Expression SEMICOLON RCB 
				{
					$$ = init();
					insert($$, "public");
					$$ = merge($$, $2);
					$$ = merge($$, $3);
					insert($$, "(");
					$$ = merge($$, $5);
					insert($$, ")");
					insert($$, "{");
					$$ = merge($$, $8);
					$$ = merge($$, $9);
					insert($$, "return");
					$$ = merge($$, $11);
					insert($$, ";");
					insert($$, "}");
				}

Type: INT LSB RSB { $$ = init(); insert($$, "int"); insert($$, "["); insert($$, "]");}
	| BOOLEAN	{ $$ = init(); insert($$, "boolean");}
	| INT 		{ $$ = init(); insert($$, "int");}
	| Identifier { $$ = $1; }

Statements: 	Statement Statements	{ $$ = merge($1, $2); }
			| 	{ $$ = init(); }

Statement: LCB Statements RCB 	{ /*printf("insl\n")*/; $$ = init(); insert($$, "{"); $$ = merge($$, $2); insert($$, "}"); }
		|  PRINT LB Expression RB SEMICOLON 	{ $$ = init(); insert($$, "System.out.println"); insert($$, "("); $$ = merge($$,$3); insert($$, ")"); insert($$, ";"); }
		|  Identifier EQUAL Expression SEMICOLON	{ $$ = $1; insert($$, "="); $$ = merge($$, $3); insert($$,";"); }
		|  Identifier LSB Expression RSB EQUAL Expression SEMICOLON  { $$ = $1; insert($$,"["); $$ = merge($$, $3); insert($$,"]"); insert($$,"="); $$ = merge($$, $6); insert($$,";");}
		|  Identifier LB Star6 RB SEMICOLON	{  $$ = $1; insert($$, "("); $$ = merge($$, $3); insert($$, ")"); insert($$, ";"); }
		|  Ifelse	{ $$ = $1; }
		|  WHILE LB Expression RB Statement	{ /*printf("inwhile\n");*/ $$ = init(); insert($$, "while"); insert($$, "("); $$ = merge($$,$3); insert($$, ")"); $$ = merge($$,$5); }

Ifelse: IF LB Expression RB Statement ELSE Statement	{
					$$ = init();
					insert($$, "if");
					insert($$, "(");
					$$ = merge($$, $3);
					insert($$, ")");
					$$ = merge($$, $5);
					insert($$, "else");
					$$ = merge($$, $7);
				}
			|  IF LB Expression RB Statement	%prec NO_ELSE {
					$$ = init();
					insert($$, "if");
					insert($$, "(");
					$$ = merge($$, $3);
					insert($$, ")");
					$$ = merge($$, $5);
				}

Expression: PrimaryExpression OR PrimaryExpression	{ $$ = $1;  insert($$,"||"); $$ = merge($$, $3);}
        |   PrimaryExpression AND PrimaryExpression { $$ = $1;  insert($$,"&&"); $$ = merge($$, $3);}        
		|	PrimaryExpression NOTEQ PrimaryExpression	{ $$ = $1; insert($$,"!="); $$ = merge($$, $3);}
        |	PrimaryExpression COMPARE PrimaryExpression	{ /*printf("inexp\n");*/$$ = $1; insert($$,"<="); $$ = merge($$, $3);}
		|	PrimaryExpression PLUS PrimaryExpression	{ $$ = $1; insert($$,"+");    $$ = merge($$, $3);}
        |	PrimaryExpression MINUS PrimaryExpression	{ $$ = $1; insert($$,"-");    $$ = merge($$, $3);}
        |	PrimaryExpression MULTIPLICATION PrimaryExpression	{ $$ = $1; insert($$,"*");    $$ = merge($$, $3);}
        |	PrimaryExpression DIVISION PrimaryExpression	{ $$ = $1; insert($$,"/");    $$ = merge($$, $3);}
		|	PrimaryExpression LSB PrimaryExpression RSB	{ $$ = $1; insert($$,"["); $$ = merge($$, $3); insert($$,"]"); }
		|	PrimaryExpression DOT Identifier LB Star6 RB	{ $$ = $1; insert($$,"."); $$ = merge($$, $3); insert($$,"("); $$ = merge($$, $5); insert($$,")"); }
		| 	PrimaryExpression LENGTH	{ $$ = $1; insert($$,"."); insert($$,"length"); }
		| 	PrimaryExpression %prec NO_EXPR { $$ = $1; }
		|	Identifier LB Star6 RB	{ $$ = $1; insert($$,"("); $$ = merge($$, $3); insert($$,")"); }

PrimaryExpression: 	NEW INT LSB Expression RSB	{ $$ = init(); insert($$, "new"); insert($$, "int"); insert($$, "["); $$ = merge($$, $4); insert($$, "]"); }
				|	NEW Identifier LB RB	{ $$ = init(); insert($$, "new"); $$ = merge($$, $2); insert($$, "("); insert($$, ")"); }
				|	LB Expression RB	{ $$ = init(); insert($$, "("); $$ = merge($$, $2); insert($$, ")"); }
				|	Term	{ $$ = $1; }
				|	NOT Expression 	{ $$ = init(); insert($$, "!"); $$ = merge($$, $2); }

Term:	Integer 	{ $$ = $1; }
	|	TRUE		{ $$ = init(); insert($$, "true");}
	| 	FALSE		{ $$ = init(); insert($$, "false");}
	|	Identifier	{ $$ = $1; }
	|	THIS		{ $$ = init(); insert($$, "this");}

MacroDef: MacroDef MacroDefinition	{ add($2); $$ = $1; }
		|  								{ $$ = init(); }

MacroDefinition: MacroExpression	{ $$ = $1; }
			|	 MacroExpression0	{ $$ = $1; }
			|	 MacroExpression1	{ $$ = $1; }
			|	 MacroExpression2	{ $$ = $1; }
			|	 MacroStatement		{ $$ = $1; }
			|	 MacroStatement0	{ $$ = $1; }
			|	 MacroStatement1	{ $$ = $1; }
			|	 MacroStatement2	{ $$ = $1; }

MacroStatement: DEFINESTMT Identifier LB Identifier COMMA Identifier COMMA Star7 RB LCB Statements RCB {
					$$ = init();
					insert($$, "#defineStmt");
					$$ = merge($$, $2);
					insert($$, "(");
					$$ = merge($$, $4);
					$$ = merge($$, $6);
					$$ = merge($$, $8);
					insert($$, ")");
					insert($$, "{");
					$$ = merge($$, $11);
					insert($$, "}");
				}

MacroStatement0: DEFINESTMT0 Identifier LB RB LCB Statements RCB {
					$$ = init();
					insert($$, "#defineStmt0");
					$$ = merge($$, $2);
					insert($$, "(");
					insert($$, ")");
					insert($$, "{");
					$$ = merge($$, $6);
					insert($$, "}");
				}

MacroStatement1: DEFINESTMT1 Identifier LB Identifier RB LCB Statements RCB {
					$$ = init();
					insert($$, "#defineStmt1");
					$$ = merge($$, $2);
					insert($$, "(");
					$$ = merge($$, $4);
					insert($$, ")");
					insert($$, "{");
					$$ = merge($$, $7);
					insert($$, "}");
				}

MacroStatement2: DEFINESTMT2 Identifier LB Identifier COMMA Identifier RB LCB Statements RCB {
					$$ = init();
					insert($$, "#defineStmt2");
					$$ = merge($$, $2);
					insert($$, "(");
					$$ = merge($$, $4);
					$$ = merge($$, $6);
					insert($$, ")");
					insert($$, "{");
					$$ = merge($$, $9);
					insert($$, "}");
				}

MacroExpression: DEFINEEXPR Identifier LB Identifier COMMA Identifier COMMA Star7 RB LB Expression RB	{
					$$ = init();
					insert($$, "#defineExpr");
					$$ = merge($$, $2);
					insert($$, "(");
					$$ = merge($$, $4);
					$$ = merge($$, $6);
					$$ = merge($$, $8);
					insert($$, ")");
					insert($$, "(");
					$$ = merge($$, $11);
					insert($$, ")");
				}

MacroExpression0: DEFINEEXPR0 Identifier LB RB LB Expression RB {
					/*printf("Iamhere\n");*/
					$$ = init();
					insert($$, "#defineExpr0");
					$$ = merge($$, $2);
					insert($$, "(");
					insert($$, ")");
					insert($$, "{");
					$$ = merge($$, $6);
					insert($$, "}");
				}

MacroExpression1: DEFINEEXPR1 Identifier LB Identifier RB LB Expression RB {
					$$ = init();
					insert($$, "#defineExpr1");
					$$ = merge($$, $2);
					insert($$, "(");
					$$ = merge($$, $4);
					insert($$, ")");
					insert($$, "{");
					$$ = merge($$, $7);
					insert($$, "}");
				}

MacroExpression2: DEFINEEXPR2 Identifier LB Identifier COMMA Identifier RB LB Expression RB {
					$$ = init();
					insert($$, "#defineExpr2");
					$$ = merge($$, $2);
					insert($$, "(");
					$$ = merge($$, $4);
					$$ = merge($$, $6);
					insert($$, ")");
					insert($$, "{");
					$$ = merge($$, $9);
					insert($$, "}");
				}

Identifier: ID 	{
					$$ = init();
					insert($$, $1);	
				}


Integer: INTEGR {
					$$ = init();
					insert($$, $1);
				}

Star1: Star1 Type Identifier SEMICOLON { 
					$$ = merge($1, $2);
					$$ = merge($$, $3);
					insert($$, ";");
				}
		| 	{ $$ = init(); }

Star2: COMMA Type Identifier Star2	{
					$$ = init();
					insert($$, ",");
					$$ = merge($$, $2);
					$$ = merge($$, $3);
					$$ = merge($$, $4);
				}
		| 	{ $$ = init(); }

Star3: COMMA Expression Star3	{ 
					$$ = init();
					insert($$, ",");
					$$ = merge($$, $2);
					$$ = merge($$, $3);
				}
		|	{ $$ = init(); }

Star4: COMMA Identifier Star4	{ $$ = init(); insert($$, ","); $$ = merge($$, $2); $$ = merge($$, $3); }
		|	{ $$ = init(); }

Star5: Type Identifier Star2	{
					$$ = merge($1, $2);
					$$ = merge($$, $3);
				}
		|	{ $$ = init(); }
	
Star6: Expression Star3	{ $$ = merge($1, $2); }
		|	{ $$ = init(); }

Star7: Identifier Star4 	{ $$ = merge($1, $2); }
		|	{ $$ = init(); }

%%

/*void yyerror()
{
    printf("//Failed to parse code\n");
}*/

int main()
{
    yyparse();
}

#include "lex.yy.c"