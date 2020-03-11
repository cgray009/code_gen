bison -v -d --file-prefix=y 862009848.y
flex 862009848.lex
gcc -o parser y.tab.c lex.yy.c -lfl
