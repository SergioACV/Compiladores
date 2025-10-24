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

int comment_level = 0; /* to track nested comments */

/*function to check the length of the string exceeds max len*/
bool isLong();

/*function to print error if maximum length is exceeded*/
int maxlen_error(); 

%}

/*
 * Define names for regular expressions here.
 */


/* DEFINE STATES */

%x STRING

%x COMMENT

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
POOL            [pP][oO][oO][lL]
THEN            [tT][hH][eE][nN]
WHILE           [wW][hH][iI][lL][eE]
CASE            [cC][aA][sS][eE]
ESAC            [eE][sS][aA][cC]
OF              [oO][fF]
NEW             [nN][eE][wW]  
ISVOID          [iI][sS][vV][oO][iI][dD]
INT_CONST       (DIGITS)+
 
NOT       [nN][oO][tT]

WHITESPACE [\n\t\f\r\v ]*

TYPEID  [A-Z]([a-zA-Z0-9_])*
OBJECTID  [a-z]([a-zA-Z0-9_])*

NEWLINE   \r?\n

 // Comments

SINGLECOMMENT "--"(.)*

 //Booleans

TRUE     t[rR][uU][eE]
FALSE    f[aA][lL][sS][eE]


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
  * Single comments: ignore them
 */

{SINGLECOMMENT} {
  
}

 /* unmatched *) */

"*)"			{ 
    cool_yylval.error_msg = "Unmatched *)";
    return ERROR;
  
}



 /*
  *  Nested comments
*/
"(*"			{ 
  BEGIN(COMMENT); 
  comment_level = 1;

}

<COMMENT><<EOF>>	{ 
        BEGIN(INITIAL);
        cool_yylval.error_msg = "EOF in comment";
        return ERROR; 
      }

 /*
  *  Inside comments, we must handle newlines and nested comments.
  *  Other characters are ignored.
  */

<COMMENT>"(*"		{ comment_level++;  }
<COMMENT>\n		{ curr_lineno++; }
<COMMENT>. { }

<COMMENT>"*)"		{ 
        comment_level--; 
        if (comment_level == 0) {
          BEGIN(INITIAL);
        }
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

{TRUE}          { cool_yylval.boolean = true; return BOOL_CONST; }
{FALSE}         { cool_yylval.boolean = false; return BOOL_CONST; }

 /*
  *  TYPEID
  */


{TYPEID} {
  cool_yylval.symbol = inttable.add_string(yytext);
  return TYPEID;
}

 /*
  *  OBEJCT D
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

  if (isLong()){
				return maxlen_error();
	}
  
  *string_buf_ptr = '\0'; /* null terminate the string */
  cool_yylval.symbol = stringtable.add_string(string_buf);
  BEGIN(INITIAL);
  return STR_CONST;
  
}


 /*
  * If EOF before closing string, send error
  */

<STRING><<EOF>> {

    if (isLong()){
				return maxlen_error();
    }
    
    cool_yylval.error_msg = "EOF in string constant";
    BEGIN(INITIAL);
    return ERROR;
    
}

 /* 
  * if newline without scape, send error 
  */ 

<STRING>\n {

    if (isLong()){
				return maxlen_error();
    }
    
    curr_lineno++;
    cool_yylval.error_msg = "Unterminated string constant";
    BEGIN(INITIAL);
    return ERROR;
   

}

 /*
  * Null character in string throws error
  */

<STRING>\\?\0		{
			BEGIN(INVALID_STRING);
			cool_yylval.error_msg = "String contains null character";
			return ERROR;
}

 /*
  * Normal cases
  */

<STRING>\\\n { 
  if (isLong()){
				return maxlen_error();
  }
  
  *string_buf_ptr++ = '\n';
  curr_lineno++; 
}

<STRING>\\[^ntbf] {

  if (isLong()){
				return maxlen_error();
  }
    
    *string_buf_ptr++ = yytext[1];
}

<STRING>\\[n] {
    if (isLong()){
				return maxlen_error();
    }
   
    *string_buf_ptr++ = '\n';
}

<STRING>\\[t] {

  if (isLong()){
				return maxlen_error();
  }

  *string_buf_ptr++ = '\t';
}

<STRING>\\[b] {

    if (isLong()){
				return maxlen_error();
    }

    *string_buf_ptr++ = '\b';
}

<STRING>\\[f] {

    if (isLong()){
				return maxlen_error();
    }

    *string_buf_ptr++ = '\f';
}

<STRING>. {

    if (isLong()){
				return maxlen_error();
    }
 
    *string_buf_ptr++ = *yytext;
}

 /*_________________________________________________________________________________________________________________________________

	The INVALID_STRING state that's used to deal with the string after invalid component is detected.
   __________________________________________________________________________________________________________________________________

  */

 /* If an inverted comma " is detected, the end of the invalid string is encountered. Therefore, return to INITIAL state*/
<INVALID_STRING>\" 	{BEGIN(INITIAL);}

 /*If a next line is detected inside an invalid string, increase line number and go to INITIAL state to start tokenizing the next line*/
<INVALID_STRING>\n 	{ 
			 curr_lineno++;
			 BEGIN(INITIAL);
  }

 /*Capture escaped newline inside invalid string, and increase line number*/
<INVALID_STRING>\\\n	{curr_lineno++;}

 /* If any char encountered after \, stay in this state because the string is not yet terminated*/
<INVALID_STRING>\\.	;

 /*If any character except \,\n," encountered, stay in this state because the string is not yet terminated*/
<INVALID_STRING>[^\\\n\"]+ ;




 /*
  *
  * Handle errors
 */

.   {
      cool_yylval.error_msg = strdup(yytext);
			return ERROR;
    }


%%


	/* ___________________________Helper functions used in STRING state________________________________________*/


/*function to check the length of the string*/
bool isLong(){

	/* String length =  ending pointer position of string - starting pointer position of string +1
			 = string_buf_ptr - string_buf+1
	
	if string length > MAX_STR_CONST -> return TRUE
	if string length < MAX_STR_CONST -> return FALSE
	*/
	return (string_buf_ptr - string_buf + 1 > MAX_STR_CONST);

}

/*function to print error if maximum length is exceeded*/
int maxlen_error(){
	BEGIN(INVALID_STRING); ///should continue reading the string
	cool_yylval.error_msg = "String constant too long";
	
	return ERROR;
}

