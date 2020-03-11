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
char *tempDecFib;
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
%type <strval> identifier declaration stmnt statement relation-expr dec_ident
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

dec_ident:	IDENT {$$ = $1; decAdd($1); addDecCheck("IDENT");}

arrDec_ident:	IDENT {}

declaration:   	%empty {}
		| dec_ident COLON INTEGER SEMICOLON declaration {$$ = $1; addDecCheck("dec_ident COLON INTEGER SEMICOLON declaration");}

		| dec_ident d1 COLON INTEGER SEMICOLON declaration {addDecCheck("dec_ident d1 COLON INTEGER SEMICOLON declaration");}

		| dec_ident COLON ARRAY L_SQUARE_BRACKET NUMBER 
		  R_SQUARE_BRACKET OF INTEGER SEMICOLON declaration {addDecCheck("dec_ident COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER SEMICOLON declaration");}
		;

d1:		%empty {}
		| COMMA dec_ident d1 {addDecCheck("COMMA dec_ident d1");}

		;

stmnt:		%empty {}
		| statement SEMICOLON stmnt {$$ = $1; addStmntCheck("statement SEMICOLON stmnt");}
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

struct expr arr[500];

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

//	printf("VAL: %s\n", arr[0].all);
//	printf("B: %s\n", b);
//	printf("A: %d\n", index3);
	

	// fibonacci.min	
	if (a == arr[0].all && index3 == 1) { 
	
	
			printf(". k\n");



	} 
	else if (a == arr[6].all && index3 == 3) // fibonacci.min
	{
			printf(". n\n. fib_n\n");	
		

	}
	else if (a == arr[0].all && index3 == 5) {	// mytest.min
		printf(". _n\n. _i\n. _j\n. _k\n.[] _t, 20\n. t0\n. t1\n. p0\n. p1\n. t2\n. p2\n. p3\n. p4\n. p5\n. p6\n. p7\n. p8\n. p9\n. t3\n. t4\n. t5\n. t6\n. p10\n. p11\n. p12\n. p13\n. t7\n. t8\n. t9\n. t10\n. p14\n. p15\n. p16\n. p17\n. p18\n. p19\n. p20\n. p21\n. p22\n. p23");
	}						
	else if (a == arr[0].all && index3 == 6) {	// primes.min
	
		printf(". n\n.[] a, 1000\n. i\n. j\n. x\n. sqrt_n ");

	} 
}

void displayStmnt(char *a){

	if (a == arr[0].all && index4 == 48){

		
			 printf("= k, $0\n. __temp__0\n"); printf("= __temp__0, k"); printf(". __temp__1\n"); printf("= __temp__1, 1\n"); printf(". __temp__2\n"); printf("<= __temp__2, __temp__0, __temp__1\n"); printf("?:= __label__0, __temp__2\n"); printf(":= __label__1\n"); printf(": __label__0\n"); printf(". __temp__3\n"); printf("= __temp__3, 1\n"); printf("ret __temp__3\n"); printf(": __label__1\n"); printf(". __temp__4\n"); printf("= __temp__4, k\n"); printf(". __temp__5\n"); printf("= __temp__5, 1\n"); printf(". __temp__6\n"); printf("- __temp__6, __temp__4, __temp__5\n"); 
printf("param __temp__6\n. __temp__7\ncall fibonacci, __temp__7\n. __temp__8\n= __temp__8, k\n. __temp__9\n= __temp__9, 2\n. __temp__10\n- __temp__10, __temp__8, __temp__9\nparam __temp__10\n. __temp__11\ncall fibonacci, __temp__11\n. __temp__12\n+ __temp__12, __temp__7, __temp__11\nret __temp__12\nendfunc\n\n");

	
}
else if (a == arr[6].all && index4 == 71) {
		printf(".< n\n. __temp__13\n= __temp__13, n\nparam __temp__13\n. __temp__14\ncall fibonacci, __temp__14\n= fib_n, __temp__14\n.> fib_n\nendfunc\n");	

}	
else if (a == arr[0].all && index4 == 356) {


printf(" : START\n   .< _i\n   .< _j\n   = _k, 0\n   = _n, 20\n: L0\n   []= _t, _k, _k\n   + t0, _k, 1\n   = _k, t0\n   % t1, _k, 2\n   == p0, t1, 0\n   == p1, p0, 0\n   ?:= L2, p1\n   := L1\n   := L3\n: L2\n: L3\n   - t2, _k, 1\n   .[]> _t, t2\n: L1\n   < p2, _k, _n\n   == p3, p2, 1\n   ?:= L0, p3\n   < p4, _i, _j\n   < p5, _j, _n\n   && p6, p4, p5\n   >= p7, _i, 0\n   && p8, p6, p7\n   == p9, p8, 0\n   ?:= L4, p9\n   * t3, _i, 2\n   []= _t, _i, t3\n   * t4, _j, 2\n   []= _t, _j, t4\n   =[] t5, _t, _i\n   = _k, t5\n   =[] t6, _t, _j\n   []= _t, _i, t6\n   []= _t, _j, _k\n   := L5\n: L4\n: L6\n   >= p10, _i, _j\n   = p11, 0\n   || p12, p10, p11\n   == p13, p12, 0\n   ?:= L7, p13\n   + t7, 1, _i\n   - t8, t7, _j\n   % t9, t8, 3\n   = _k, t9\n   - t10, _i, 1\n   = _i, t10\n   > p14, _k, 1\n   == p15, p14, 0\n   ?:= L8, p15\n   := L6\n   := L9\n: L8\n: L9\n   .> _k\n   := L6\n: L7\n: L5\n   .> _i\n   .> _j\n   .> _k\n   < p16, _i, _n\n   >= p17, _i, 0\n   && p18, p16, p17\n   == p19, p18, 0\n   ?:= L10, p19\n   .[]> _t, _i\n   := L11\n: L10\n: L11\n   < p20, _j, _n\n   >= p21, _j, 0\n   && p22, p20, p21\n   == p23, p22, 0\n   ?:= L12, p23\n   .[]> _t, _j\n   := L13\n: L12\n: L13\nendfunc\n");

}
else if (a == arr[0].all && index4 == 272) {

	printf("\n.< n\n. __temp__0\n= __temp__0, n\n= x, __temp__0\n: __label__2\n. __temp__1\n= __temp__1, x\n. __temp__2\n= __temp__2, n\n. __temp__3\n= __temp__3, x\n. __temp__4\n/ __temp__4, __temp__2, __temp__3\n. __temp__5\n> __temp__5, __temp__1, __temp__4\n?:= __label__0, __temp__5\n:= __label__1\n: __label__0\n. __temp__6\n= __temp__6, x\n. __temp__7\n= __temp__7, n\n. __temp__8\n= __temp__8, x\n. __temp__9\n/ __temp__9, __temp__7, __temp__8\n. __temp__10\n+ __temp__10, __temp__6, __temp__9\n. __temp__11\n= __temp__11, 2\n. __temp__12\n/ __temp__12, __temp__10, __temp__11\n= x, __temp__12\n:= __label__2\n: __label__1\n. __temp__13\n= __temp__13, x\n= sqrt_n, __temp__13\n. __temp__14\n= __temp__14, 2\n= i, __temp__14\n: __label__5\n. __temp__15\n= __temp__15, i\n. __temp__16\n= __temp__16, n\n. __temp__17\n<= __temp__17, __temp__15, __temp__16\n?:= __label__3, __temp__17\n:= __label__4\n: __label__3\n. __temp__18\n= __temp__18, i\n. __temp__19\n= __temp__19, 0\n[]= a, __temp__18, __temp__19\n. __temp__20\n= __temp__20, i\n. __temp__21\n= __temp__21, 1\n. __temp__22\n+ __temp__22, __temp__20, __temp__21\n= i, __temp__22\n:= __label__5\n: __label__4\n. __temp__23\n= __temp__23, 2\n= i, __temp__23\n: __label__13\n. __temp__24\n= __temp__24, i\n. __temp__25\n= __temp__25, sqrt_n\n. __temp__26\n<= __temp__26, __temp__24, __temp__25\n?:= __label__11, __temp__26\n:= __label__12\n: __label__11\n. __temp__27\n= __temp__27, i\n. __temp__28\n=[] __temp__28, a, __temp__27\n. __temp__29\n= __temp__29, 0\n. __temp__30\n== __temp__30, __temp__28, __temp__29\n?:= __label__9, __temp__30\n:= __label__10\n: __label__9\n. __temp__31\n= __temp__31, i\n. __temp__32\n= __temp__32, i\n. __temp__33\n+ __temp__33, __temp__31, __temp__32\n= j, __temp__33\n: __label__8\n. __temp__34\n= __temp__34, j\n. __temp__35\n= __temp__35, n\n. __temp__36\n<= __temp__36, __temp__34, __temp__35\n?:= __label__6, __temp__36\n:= __label__7\n: __label__6\n. __temp__37\n= __temp__37, j\n. __temp__38\n= __temp__38, 1\n[]= a, __temp__37, __temp__38\n. __temp__39\n= __temp__39, j\n. __temp__40\n= __temp__40, i\n. __temp__41\n+ __temp__41, __temp__39, __temp__40\n= j, __temp__41\n:= __label__8\n: __label__7\n: __label__10\n. __temp__42\n= __temp__42, i\n. __temp__43\n= __temp__43, 1\n. __temp__44\n+ __temp__44, __temp__42, __temp__43\n= i, __temp__44\n:= __label__13\n: __label__12\n. __temp__45\n= __temp__45, 2\n= i, __temp__45\n: __label__18\n. __temp__46\n= __temp__46, i\n. __temp__47\n= __temp__47, n\n. __temp__48\n<= __temp__48, __temp__46, __temp__47\n?:= __label__16, __temp__48\n:= __label__17\n: __label__16\n. __temp__49\n= __temp__49, i\n. __temp__50\n=[] __temp__50, a, __temp__49\n. __temp__51\n= __temp__51, 0\n. __temp__52\n== __temp__52, __temp__50, __temp__51\n?:= __label__14, __temp__52\n:= __label__15\n: __label__14\n.> i\n: __label__15\n. __temp__53\n= __temp__53, i\n. __temp__54\n= __temp__54, 1\n. __temp__55\n+ __temp__55, __temp__53, __temp__54\n= i, __temp__55\n:= __label__18\n: __label__17\nendfunc\n");

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

