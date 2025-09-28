/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

%}

/*
 * Define names for regular expressions here.
 */


/* DEFINE STATES */

%x STRING

%x NESTEDCOMMENT

 /* DEFINE ERROR STATES */

%x INVALID_STRING



 /* NAMES AND REGEX */

DARROW          =>
LE              <=
ASSIGN          <-


DIGIT           [0-9]
DIGITS          [0-9]+

LETTER          [a-zA-Z]           

CLASS           [cC][lL][aA][sS][sS]
ELSE            [eE][lL][sS][eE]
FI              [fF][iI]
IF              [iI][fF]
IN              [iI][nN]
INHERITS        [iI][nN][hH][eE][rR][iI][tT][sS]
LET             [lL][eE][tT]
LOOP            [lL][oO][oO][pP]
POOL            [pP][oO][lL][lL]
THEN            [tT][hH][eE][nN]
WHILE           [wW][hH][iI][lL][eE]
CASE            [cC][aA][sS][eE]
ESAC            [eE][sS][aA][cC]
OF              [oO][fF]
NEW             [nN][eE][wW]  
ISVOID          [iI][sS][vV][oO][iI][dD]
INT_CONST       (DIGITS)+

BOOL_CONST     (t[rR][Uu][Ee]|f[aA][lL][sS][eE]) 
NOT       [nN][oO][tT]

WHITESPACE [\t ]*

TYPEID    [A-Z]({LETTER}|{DIGIT}|\_)*
OBJECTID  [a-z]({LETTER}|{DIGIT}|\_)*

NEWLINE   \r?\n

 // Comments

SINGLECOMMENT "--"(.)*


%%

 /*
  * new lines
  */

{NEWLINE} {

  curr_lineno++;

}


 /*Whitespaces are ignored*/
{WHITESPACE}		{}


 /*
  * Single comments
 */

{SINGLECOMMENT} {
  
}


 /*
  *  Nested comments
  */

"(*" {
  BEGIN(NESTEDCOMMENT)
  printf("Possible comment")
}

{NESTEDCOMMENT}"*)" {
  BEGIN(INITIAL)
}



 /*
  *  The multiple-character operators.
  */

"."			{ return '.';}
"@"			{ return '@';}
"~"			{ return '~';}
"*"			{ return '*';}
"/"			{ return '/';}
"+"			{ return '+';}
"-"			{ return '-';}
"<"			{ return '<';}
"="			{ return '=';}
","			{ return ',';}
"{"			{ return '{';}
"}"			{ return '}';}
"("			{ return '(';}
")"			{ return ')';}
":"			{ return ':';}
";"			{ return ';';}



 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */


{DARROW}		{ return (DARROW); }
{LE}			  { return (LE);}
{ASSIGN}		{ return (ASSIGN);}

{CLASS} 		{ return CLASS;}
{ELSE} 			{ return ELSE;}
{IF} 			{ return IF;}
{FI} 			{ return FI;}
{IN}	 		{ return IN;}
{INHERITS} 		{ return INHERITS;}
{ISVOID} 		{ return ISVOID;}
{LET} 			{ return LET;}
{LOOP} 			{ return LOOP;}
{POOL}		 	{ return POOL;}
{THEN} 		        { return THEN;}
{WHILE}			{ return WHILE;}
{CASE} 			{ return CASE;}
{ESAC}	 		{ return ESAC;}
{NEW}	 		{ return NEW;}
{OF}	 		{ return OF;}
{NOT}	 		{ return NOT;}

 /*
  *  TYPEID
  */


{TYPEID} {
  cool_yylval.symbol = inttable.add_string(yytext);
  return TYPEID;
}

 /*
  *  TYPEID
  */
{OBJECTID} {
  cool_yylval.symbol = inttable.add_string(yytext);
  return OBJECTID;
}

  /*
  * INT CONSTANT
  */

{DIGITS} {
  cool_yylval.symbol = inttable.add_string(yytext);
  return INT_CONST;
}

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

\" {

    string_buf_ptr = string_buf;
    BEGIN(STRING);
}

 /*
  * End string
  *
  */

<STRING>\" {
  string_buf_ptr = 0;
  cool_yylval.symbol = stringtable.add_string(string_buf);
  BEGIN(INITIAL);
  return STR_CONST;
  
}


 /*
  * If EOF before closing string, send error
  */

<STRING><<EOF>> {
    
    cool_yylval.error_msg = "EOF in string constant";
    BEGIN(INITIAL);
    return ERROR;
    
}

 /* 
  * if newline without scape, send error 
  */ 

<STRING>\n {
    
    curr_lineno++;
    cool_yylval.error_msg = "Unterminated string constant";
    BEGIN(INITIAL);
    return ERROR;
   

}

 /*
  * Null character in string throws error
  */

<STRING>\0 {
    
    cool_yylval.error_msg = "String contains null character";
    BEGIN(INITIAL);
    return ERROR;
}

 /*
  * Normal cases
  */

<STRING>\\\n { curr_lineno++; }

<STRING>\\[^ntbf] {
    
    *string_buf_ptr++ = yytext[1];
}

<STRING>\\[n] {
   
    *string_buf_ptr++ = '\n';
}

<STRING>\\[t] {

    *string_buf_ptr++ = '\t';
}

<STRING>\\[b] {

    *string_buf_ptr++ = '\b';
}

<STRING>\\[f] {

    *string_buf_ptr++ = '\f';
}

<STRING>. {
 
    *string_buf_ptr++ = *yytext;
}


 /*
  *
  * Handle errors
 */

.   { /* manejar caracteres inesperados */
      fprintf(stderr, "Unexpected character: %s\n", yytext);
      return ERROR; /* o simplemente ignorar */
}




%%