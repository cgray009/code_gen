bison -v -d --file-prefix=y parse.y
flex parse.lex
gcc -o parser y.tab.c lex.yy.c -lfl
