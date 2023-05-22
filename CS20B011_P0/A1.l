%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
void yyerror(); 
int yyparse(); 
%}

DIGIT       [0-9]
INTEGER     {DIGIT}+
SPACE       "\t"|"\n"|"\r"|"\f"|" "
IDENTIFIER  [a-zA-Z][a-zA-Z0-9_]*

%%
"//".*		                {;}

"/*"("*"[^/]|[^*])*"*/"     {;}

{SPACE}                     {;}

"main"                      { 
                                return MAIN;
                            }

"new"                       {
                                return NEW;
                            }

"int"                       {
                                /*printf("inr\n");*/
                                return INT;
                            }

"public"                    {
                                /*printf("pub\n");*/
                                return PUBLIC;
                            }

"static"                    {
                                return STATIC;
                            }

"void"                      {
                                return VOID;
                            }

"class"                     {
                                return CLASS;
                            }

"String"                    {
                                return STRING;
                            }

"this"                      {
                                return THIS;
                            }

"true"                      {
                                return TRUE;
                            }

"false"                     {
                                return FALSE;
                            }

"boolean"                   {
                                return BOOLEAN;
                            }

"while"                     {
                               /*printf("whle\n");*/
                                return WHILE;
                            }

"if"                        {
                                return IF;
                            }

"else"                      {
                                return ELSE;
                            }

".length"                   {
                                return LENGTH;
                            }

"System.out.println"        {
                                return PRINT;
                            }

"extends"                   {
                                return EXTENDS;
                            }

"return"                    {
                                return RETURN;
                            }

"+"                         {
                                return PLUS;
                            }

"-"                         {
                                return MINUS;
                            }

"*"                         {
                                return MULTIPLICATION;
                            }

"/"                         {
                                return DIVISION;
                            }

"!"                         {
                                return NOT;
                            }

"="                         {
                                return EQUAL;
                            }

"?"                         {
                                return QUESTION;
                            }

";"                         {
                                return SEMICOLON;
                            }

"."                         {
                                return DOT;
                            }

","                         {
                                return COMMA;
                            }

"&&"                         {
                                return AND;
                            }

"||"                        {
                                return OR;
                            }

"!="                        {
                                return NOTEQ;
                            }

"<="                        {
                                /*printf("le\n");*/
                                return COMPARE;
                            }

"("                         {
                                /*printf("LB\n");*/
                                return LB;
                            }

")"                         {
                                /*printf("RB\n");*/
                                return RB;
                            }

"["                         {
                                return LSB;
                            }

"]"                         {
                                return RSB;
                            }

"{"                         {
                                /*printf("LCB\n");*/
                                return LCB;
                            }

"}"                         {
                                /*printf("RCB\n");*/
                                return RCB;
                            }

"#defineExpr"               {
                                return DEFINEEXPR;
                            }

"#defineExpr0"              {
                                return DEFINEEXPR0;
                            }

"#defineExpr1"              {
                                return DEFINEEXPR1;
                            }

"#defineExpr2"              {
                                return  DEFINEEXPR2;
                            }

"#defineStmt"               {
                                return DEFINESTMT;
                            }

"#defineStmt0"              {
                                return DEFINESTMT0;
                            }

"#defineStmt1"              {
                                return DEFINESTMT1;
                            }

"#defineStmt2"              {
                                return  DEFINESTMT2;
                            }
 

{INTEGER}                   {
                                yylval.string_id = strdup(yytext);
                                return INTEGR; 
                            }

{IDENTIFIER}                {
                                /*printf("here\n");*/
                                yylval.string_id = strdup(yytext);
                                return ID;
                            }

<<EOF>>                     {
                                return 0;
                            }

.                           {
                                yyerror();
                            }
%%

void yyerror()
{
    printf("//Failed to parse input code at %s\n",yytext);
}