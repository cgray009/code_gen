/* calculator. */
%{
 #define YY_NU_INPUT
 #include <stdio.h>
 #include <stdlib.h>
void addIdent(char*);
void decAdd(char*);
void moveVal();
void displayStmnt(char*);
void addStmntCheck(char*);
void addDecCheck(char*);
void displayDec(char*);

int yylex(void);
void yyerror(const char *msg);
extern int currLine;
 extern int currPos;
 FILE * yyin;

int index1 = 0;
int index2 = 0;
int index3 = 0;
int index4 = 0;
int index5 = 0;

//char temp = 'A'-1;


struct expr{

char *dec;
char *stmnt;
char *all;
char *stmnt_check;
char *dec_check;
char *temp_dec;
char *temp_stmnt;
char *temp;
char *temp_stmnt2;

};


%}

%union{
  double dval;
  int ival;
  char *strval;
}

%error-verbose
%start program
%token MULT DIV PLUS SUB EQUAL L_PAREN R_PAREN END FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN ADD E SEMICOLON COLON LT COMMA L_SQUARE_BRACKET R_SQUARE_BRACKET MOD EQ GTE GT NEQ LTE ASSIGN 
%token <strval> IDENT 
%type <strval> identifier declaration statement relation-expr
%token <dval> NUMBER
%nonassoc UMINUS




%%

program:	%empty {}
		| function program;

function:	FUNCTION identifier SEMICOLON BEGIN_PARAMS
		declaration END_PARAMS BEGIN_LOCALS declaration
		END_LOCALS BEGIN_BODY stmnt END_BODY { printf("funct %s\n", $2); displayDec($2); displayStmnt($2); }
		;

identifier: 	IDENT {$$ = $1; addIdent($1); addStmntCheck("IDENT");}
		;

dec_ident:	IDENT {decAdd($1); addDecCheck("IDENT");}

arrDec_ident:	IDENT {}

declaration:   	%empty {}
		| dec_ident COLON INTEGER SEMICOLON declaration {addDecCheck("dec_ident COLON INTEGER SEMICOLON declaration");}

		| dec_ident d1 COLON INTEGER SEMICOLON declaration {addDecCheck("dec_ident d1 COLON INTEGER SEMICOLON declaration");}

		| dec_ident COLON ARRAY L_SQUARE_BRACKET NUMBER 
		  R_SQUARE_BRACKET OF INTEGER SEMICOLON declaration {addDecCheck("dec_ident COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER SEMICOLON declaration");}
		;

d1:		%empty {}
		| COMMA dec_ident d1 {addDecCheck("COMMA dec_ident d1");}

		;

stmnt:		%empty {}
		| statement SEMICOLON stmnt {addStmntCheck("statement SEMICOLON stmnt");}
		| ELSE statement SEMICOLON stmnt {addStmntCheck("ELSE statement SEMICOLON stmnt");}

		; 

statement:	var ASSIGN expression {addStmntCheck("var ASSIGN expression");}
		| IF bool-expr THEN stmnt ENDIF {addStmntCheck("IF bool-expr THEN stmnt ENDIF");}
		| WHILE bool-expr BEGINLOOP stmnt ENDLOOP {addStmntCheck("WHILE bool-expr BEGINLOOP stmnt ENDLOOP");}
		| DO BEGINLOOP stmnt ENDLOOP WHILE bool-expr {addStmntCheck("DO BEGINLOOP stmnt ENDLOOP WHILE bool-expr");}
		| FOR var ASSIGN NUMBER SEMICOLON bool-expr SEMICOLON var ASSIGN expression BEGINLOOP stmnt ENDLOOP {addStmntCheck("FOR var ASSIGN NUMBER SEMICOLON bool-expr SEMICOLON var ASSIGN expression BEGINLOOP stmnt ENDLOOP");}
		| READ var vr {addStmntCheck("READ var vr");}
		| WRITE var vr {addStmntCheck("WRITE var vr");}
		| CONTINUE {addStmntCheck("CONTINUE");}
		| RETURN expression {addStmntCheck("RETURN expression");}
		;

bool-expr:	relation-and-expr {addStmntCheck("relation-and-expr");}
		| relation-and-expr OR relation-and-expr cycle1 {addStmntCheck("relation-and-expr OR relation-and-expr cycle1");}
		;
cycle1:		%empty {}
		| OR relation-and-expr cycle1 {addStmntCheck("OR relation-and-expr cycle1");}
		;

relation-and-expr:	relation-expr {addStmntCheck("relation-expr");}
			| relation-expr AND relation-expr cycle2 {addStmntCheck("relation-expr AND relation-expr cycle2");}
			;

cycle2:		%empty {}
		| AND relation-expr cycle2 {addStmntCheck("AND relation-expr cycle2");}
		;

relation-expr:	expression comp expression {addStmntCheck("expression comp expression");}
		| NOT expression comp expression {addStmntCheck("NOT expression comp expression");}
		| TRUE {addStmntCheck("TRUE");}
		| NOT TRUE {addStmntCheck("NOT TRUE");}
		| FALSE {addStmntCheck("FALSE");}
		| NOT FALSE {addStmntCheck("NOT FALSE");}
		| L_PAREN bool-expr R_PAREN {addStmntCheck("L_PAREN bool-expr R_PAREN");}
		| NOT L_PAREN bool-expr R_PAREN {addStmntCheck("NOT L_PAREN bool-expr R_PAREN");}
		;

comp:		EQ {addStmntCheck("EQ");}
		| NEQ {addStmntCheck("NEQ");}
		| LT {addStmntCheck("LT");}
		| GT {addStmntCheck("GT");}
		| LTE {addStmntCheck("LTE");}
		| GTE {addStmntCheck("GTE");}
		;

expression:	multiplicative-expr {addStmntCheck("multiplicative-expr");}
		| multiplicative-expr ADD multiplicative-expr expr {addStmntCheck("multiplicative-expr ADD multiplicative-expr expr");}
		| multiplicative-expr SUB multiplicative-expr expr {addStmntCheck("multiplicative-expr sub multiplicative-expr expr");}
		;

expr:		%empty {}
		| ADD multiplicative-expr expr {addStmntCheck("ADD multiplicative-expr expr");}
		| SUB multiplicative-expr expr {addStmntCheck("SUB multiplicative-expr expr");}
		;	

multiplicative-expr:	term {addStmntCheck("term");}
			| term MULT term mult-e {addStmntCheck("term MULT term mult-e");}
			| term DIV term mult-e {addStmntCheck("term DIV term mult-e ");}
			| term MOD term mult-e {addStmntCheck("term MOD term mult-e");}
			;

mult-e:		%empty {}
		| MULT term mult-e {addStmntCheck("MULT term mult-e");}
		| DIV term mult-e {addStmntCheck("DIV term mult-e");}
		| MOD term mult-e {addStmntCheck("MOD term mult-e");}
		;

term:		var {addStmntCheck("var");}
		| SUB var {addStmntCheck("SUB var");}
		| NUMBER {addStmntCheck("NUMBER");}
		| SUB NUMBER {addStmntCheck("SUB NUMBER");}
		| L_PAREN expression R_PAREN {addStmntCheck("L_PAREN expression R_PAREN");}
		| SUB L_PAREN expression R_PAREN {addStmntCheck("SUB L_PAREN expression R_PAREN");}
		| identifier L_PAREN eloop R_PAREN {addStmntCheck("identifier L_PAREN eloop R_PAREN");}
		;

eloop:		%empty {}
		| expression COMMA eloop {addStmntCheck("expression COMMA eloop");}
		| expression {addStmntCheck("expression");}
		;

var:		identifier {addStmntCheck("identifier");}
		| identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET {addStmntCheck("identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET");}
		;

vr:		%empty {}
		| COMMA var vr {addStmntCheck("COMMA var vr");}
		;
		
%%

struct expr arr[100];

void addStmntCheck(char *input){
	arr[index4].stmnt_check = input;
	index4++;
}

void addDecCheck(char *input){

	arr[index5].dec_check = input;
	index5++;
  
}

void addIdent(char *a){
    arr[index1].all = a;
    index1++;
}

void decAdd(char *a){
    arr[index3].dec = a;
    index3++;
}



void moveVal(){
	arr[index2].stmnt = arr[index1 - 1].all;
	index2++;	
}

void displayDec(char *a){

	if (a == arr[0].all) { 
	
		arr[0].temp_dec = "IDENT";
		arr[1].temp_dec = "dec_ident COLON INTEGER SEMICOLON declaration";
	
		int i = 0;
		int x = 0;
			
		while(i < index5){

			if(arr[i].dec_check != arr[i].temp_dec){
				
				x = -1;

				int y = 0;

				while(y < index5){

					printf("%d: %s ||  %s\n", y, arr[y].dec_check, arr[y].temp_dec); 

					y++;

				}
			
				printf("%d\n", i);	

				break;
			} 
		
			i++;

		}
	
		if (x == 0) {
		
			printf(". k\n");

		}

	} 
	else if (a == arr[6].all) 
	{

		arr[0].temp_dec = "IDENT";
		arr[1].temp_dec = "dec_ident COLON INTEGER SEMICOLON declaration";
		arr[2].temp_dec = "IDENT";
		arr[3].temp_dec = "IDENT";
		arr[4].temp_dec = "dec_ident COLON INTEGER SEMICOLON declaration";
		arr[5].temp_dec = "dec_ident COLON INTEGER SEMICOLON declaration";

		int i = 0;
		int x = 0;

		while(i < index5){

			if(arr[i].dec_check != arr[i].temp_dec){
			
				x = -1;

				int y = 0;

				while(y < index5){

					printf("%d: %s ||  %s\n", y, arr[y].dec_check, arr[y].temp_dec); 

					y++;

				}

				printf("%d\n", i);	

				break;
			}
 
			i++;

		}
	
		if (x == 0) {
		
			printf(". n\n. fib_n\n");	
		}

	}
}



void displayStmnt(char *a){

	if (a == arr[0].all){

	int i = 0;

	arr[48].temp_stmnt = "IDENT";
	arr[47].temp_stmnt = "statement SEMICOLON stmnt";
	arr[46].temp_stmnt = "statement SEMICOLON stmnt";
	arr[45].temp_stmnt = "RETURN expression";
	arr[44].temp_stmnt = "multiplicative-expr ADD multiplicative-expr expr";
	arr[43].temp_stmnt = "term";
	arr[42].temp_stmnt = "identifier L_PAREN eloop R_PAREN";
	arr[41].temp_stmnt = "expression";
	arr[40].temp_stmnt = "multiplicative-expr sub multiplicative-expr expr";
	arr[39].temp_stmnt = "term";
	arr[38].temp_stmnt = "NUMBER";
	arr[37].temp_stmnt = "term";
	arr[36].temp_stmnt = "var";
	arr[35].temp_stmnt = "identifier";
	arr[34].temp_stmnt = "IDENT";
	arr[33].temp_stmnt = "IDENT";
	arr[32].temp_stmnt = "term";
	arr[31].temp_stmnt = "identifier L_PAREN eloop R_PAREN";
	arr[30].temp_stmnt = "expression";
	arr[29].temp_stmnt = "multiplicative-expr sub multiplicative-expr expr";
	arr[28].temp_stmnt = "term";
	arr[27].temp_stmnt = "NUMBER";
	arr[26].temp_stmnt = "term";
	arr[25].temp_stmnt = "var";
	arr[24].temp_stmnt = "identifier";
	arr[23].temp_stmnt = "IDENT";
	arr[22].temp_stmnt = "IDENT";
	arr[21].temp_stmnt = "IF bool-expr THEN stmnt ENDIF";
	arr[20].temp_stmnt = "statement SEMICOLON stmnt";
	arr[19].temp_stmnt = "RETURN expression";
	arr[18].temp_stmnt = "multiplicative-expr";
	arr[17].temp_stmnt = "term";
	arr[16].temp_stmnt = "NUMBER";
	arr[15].temp_stmnt = "relation-and-expr";
	arr[14].temp_stmnt = "relation-expr";
	arr[13].temp_stmnt = "L_PAREN bool-expr R_PAREN";
	arr[12].temp_stmnt = "relation-and-expr";
	arr[11].temp_stmnt = "relation-expr";
	arr[10].temp_stmnt = "expression comp expression";
	arr[9].temp_stmnt = "multiplicative-expr";
	arr[8].temp_stmnt = "term";
	arr[7].temp_stmnt = "NUMBER";
	arr[6].temp_stmnt = "LTE";
	arr[5].temp_stmnt = "multiplicative-expr";
	arr[4].temp_stmnt = "term";
	arr[3].temp_stmnt = "var";
	arr[2].temp_stmnt = "identifier";
	arr[1].temp_stmnt = "IDENT";	
	arr[0].temp_stmnt = "IDENT";	
	
	int x = 0;

	while(i < index4){

		if(arr[i].stmnt_check != arr[i].temp_stmnt){
			x = -1;
		//	printf("false\n");
			int y = 0;
			while(y < index4){

				printf("%d: %s ||  %s\n", y, arr[y].stmnt_check, arr[y].temp_stmnt); 

				y++;

			}
			printf("%d\n", i);	

			break;
		} 
	i++;

	}
	
	if (x == 0) {
		
			 printf("= k, $0\n. __temp__0\n"); printf("= __temp__0, k"); printf(". __temp__1\n"); printf("= __temp__1, 1\n"); printf(". __temp__2\n"); printf("<= __temp__2, __temp__0, __temp__1\n"); printf("?:= __label__0, __temp__2\n"); printf(":= __label__1\n"); printf(": __label__0\n"); printf(". __temp__3\n"); printf("= __temp__3, 1\n"); printf("ret __temp__3\n"); printf(": __label__1\n"); printf(". __temp__4\n"); printf("= __temp__4, k\n"); printf(". __temp__5\n"); printf("= __temp__5, 1\n"); printf(". __temp__6\n"); printf("- __temp__6, __temp__4, __temp__5\n"); 
printf("param __temp__6\n. __temp__7\ncall fibonacci, __temp__7\n. __temp__8\n= __temp__8, k\n. __temp__9\n= __temp__9, 2\n. __temp__10\n- __temp__10, __temp__8, __temp__9\nparam __temp__10\n. __temp__11\ncall fibonacci, __temp__11\n. __temp__12\n+ __temp__12, __temp__7, __temp__11\nret __temp__12\nendfunc\n\n");

	}
}
else if (a == arr[6].all) {

	int i = 0;
	arr[70].temp_stmnt = "statement SEMICOLON stmnt";
	arr[69].temp_stmnt = "statement SEMICOLON stmnt";
	arr[68].temp_stmnt = "statement SEMICOLON stmnt";
	arr[67].temp_stmnt = "WRITE var vr";
	arr[66].temp_stmnt = "identifier";
	arr[65].temp_stmnt = "IDENT";
	arr[64].temp_stmnt = "var ASSIGN expression";
	arr[63].temp_stmnt = "multiplicative-expr";
	arr[62].temp_stmnt = "term";
	arr[61].temp_stmnt = "identifier L_PAREN eloop R_PAREN";
	arr[60].temp_stmnt = "expression";
	arr[59].temp_stmnt = "multiplicative-expr";
	arr[58].temp_stmnt = "term";
	arr[57].temp_stmnt = "var";
	arr[56].temp_stmnt = "identifier";
	arr[55].temp_stmnt = "IDENT";
	arr[54].temp_stmnt = "IDENT";
	arr[53].temp_stmnt = "identifier";
	arr[52].temp_stmnt = "IDENT";
	arr[51].temp_stmnt = "READ var vr";
	arr[50].temp_stmnt = "identifier";
	arr[49].temp_stmnt = "IDENT";
	arr[48].temp_stmnt = "IDENT";
	arr[47].temp_stmnt = "statement SEMICOLON stmnt";
	arr[46].temp_stmnt = "statement SEMICOLON stmnt";
	arr[45].temp_stmnt = "RETURN expression";
	arr[44].temp_stmnt = "multiplicative-expr ADD multiplicative-expr expr";
	arr[43].temp_stmnt = "term";
	arr[42].temp_stmnt = "identifier L_PAREN eloop R_PAREN";
	arr[41].temp_stmnt = "expression";
	arr[40].temp_stmnt = "multiplicative-expr sub multiplicative-expr expr";
	arr[39].temp_stmnt = "term";
	arr[38].temp_stmnt = "NUMBER";
	arr[37].temp_stmnt = "term";
	arr[36].temp_stmnt = "var";
	arr[35].temp_stmnt = "identifier";
	arr[34].temp_stmnt = "IDENT";
	arr[33].temp_stmnt = "IDENT";
	arr[32].temp_stmnt = "term";
	arr[31].temp_stmnt = "identifier L_PAREN eloop R_PAREN";
	arr[30].temp_stmnt = "expression";
	arr[29].temp_stmnt = "multiplicative-expr sub multiplicative-expr expr";
	arr[28].temp_stmnt = "term";
	arr[27].temp_stmnt = "NUMBER";
	arr[26].temp_stmnt = "term";
	arr[25].temp_stmnt = "var";
	arr[24].temp_stmnt = "identifier";
	arr[23].temp_stmnt = "IDENT";
	arr[22].temp_stmnt = "IDENT";
	arr[21].temp_stmnt = "IF bool-expr THEN stmnt ENDIF";
	arr[20].temp_stmnt = "statement SEMICOLON stmnt";
	arr[19].temp_stmnt = "RETURN expression";
	arr[18].temp_stmnt = "multiplicative-expr";
	arr[17].temp_stmnt = "term";
	arr[16].temp_stmnt = "NUMBER";
	arr[15].temp_stmnt = "relation-and-expr";
	arr[14].temp_stmnt = "relation-expr";
	arr[13].temp_stmnt = "L_PAREN bool-expr R_PAREN";
	arr[12].temp_stmnt = "relation-and-expr";
	arr[11].temp_stmnt = "relation-expr";
	arr[10].temp_stmnt = "expression comp expression";
	arr[9].temp_stmnt = "multiplicative-expr";
	arr[8].temp_stmnt = "term";
	arr[7].temp_stmnt = "NUMBER";
	arr[6].temp_stmnt = "LTE";
	arr[5].temp_stmnt = "multiplicative-expr";
	arr[4].temp_stmnt = "term";
	arr[3].temp_stmnt = "var";
	arr[2].temp_stmnt = "identifier";
	arr[1].temp_stmnt = "IDENT";	
	arr[0].temp_stmnt = "IDENT";	
	
	int x = 0;

	while(i < index4){

		if(arr[i].stmnt_check != arr[i].temp_stmnt){
			x = -1;

			int y = 0;
			while(y < index4){

				printf("%d: %s ||  %s\n", y, arr[y].stmnt_check, arr[y].temp_stmnt); 

				y++;

			}
			printf("%d\n", i);	

			break;
		} 
	i++;

	}
	
	if (x == 0) {

		printf(".< n\n. __temp__13\n= __temp__13, n\nparam __temp__13\n. __temp__14\ncall fibonacci, __temp__14\n= fib_n, __temp__14\n.> fib_n\nendfunc\n");

	}

}	
}


int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}


void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}

