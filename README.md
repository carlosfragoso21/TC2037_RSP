# Parallel highlighter Syntax
this is the user manual for the ABAP Syntax Highlighter parallel program! This program, developed in Elixir, aims to provide a convenient tool for highlighting multiple ABAP code syntax in a faster way, making it easier for developers to analyze, understand and generate their ABAP programs.

![image](https://github.com/carlosfragoso21/TC2037_RS/assets/80837879/0de6d3fd-58c6-484f-97f6-d5aae35ae4be)

## Diagram to facilitate perception of logical flow
![Diagrama de flujo (5)](https://github.com/carlosfragoso21/TC2037_RSP/assets/80837879/9d3aa0fb-d835-4c43-bd9d-d252e9c10eb6)

## Token types
* Reserved keywords: AUTHORITY-CHECK, FIELD-SYMBOL, ASSIGNING, IMPORTING, PERFORM, PARAMETERS, ENDMETHOD, ENDMODULE, STRUCTURE, CONDENSE, CONSTANTS, UNASSIGN, ENDSELECT, ENDLOOP, ENDFORM, CONTINUE, CONVERT, DESCRIBE, COLLECT, COMMIT, COMPUTE, SELECTION, FUNCTION, ROLLBACK, REFRESH, REJECT, REPORT, RETURN, METHOD, MODIFY, MODULE, MOVE, MULTIPLY, EXPORT, EXTRACT, APPEND, OBJECT, CATCH, CHECK, CLASS, CLEAR, CLOSE, OPTION, ENDTRY, UNION, UPDATE, VALUE, VALUES, VARYING, WHEN, WHILE, WITH, WRITE, WHERE, REPORT, INCLUDE, GROUP, HAVING, IMPORT, INCLUDE, INITIAL, INNER, INTO, LEAVE, SELECT, SWITCH, DEFINE, DELETE, FROM, SUBMIT, ASSIGN, START, FORM, BREAK, CASE, NODES, ORDER, RAISE, READ, ELSEIF, TYPE, TYPES, TABLE, AND, CALL, DATA, ELSE, ENDIF, END, EXIT, FETCH, FILTER, FINAL, FOR, LIKE, LOOP, NEW, NEXT, NOT, SET, SHIFT, SPLIT, STEP, SUM, TRY, DO, AT, IF, NO, OF, ON, OR.

* Identifiers: Following the pattern of starting with a letter (uppercase or lowercase) and being composed of letters, numbers, and underscores.

* String literals: Enclosed within single quotes ('') and can contain any content between them.

* Operators: +, -, *, /, =.

* Delimiters: Parentheses () and brackets [].

* Comments: Starting with double quotes (") and can span multiple lines.

* Numbers: Can be integers or decimals.

* Dot, comma, and at symbol: ., ,, @.

* Line break: Represented by a line break pattern.

* Error token: Used to identify syntax highlighting errors.

## Big O complex
The complexity of the program in Big O terms it's O(n). Considering step process depending on content, we can infer the O(n) because steps will increase proportionally to content.

In order to visualize this behavior, let's compare process time between a small file (10 words) and a medium file (100 words):

First file test:

![image](https://github.com/carlosfragoso21/TC2037_RS/assets/80837879/69d9f061-6696-483d-beee-414e383e0c91)

As we can see, the average is 38333 nanoseconds

Second file test (10x words):

![image](https://github.com/carlosfragoso21/TC2037_RS/assets/80837879/e21f680a-19e5-486f-955d-236ce1d45bd7)

As we can see, the averagge 248333 nanoseconds

We can infer that time does not increment 10 times, this could be because we have to know that iniciation process and final process(the ones that are not in loop or recursively calling) these are not reprocessing 10 times. So in this test we can see that the complexity is not worse than O(n). And just to assert, program will increase steps depending on words quantity, this increase is proportional to content.

Adding, complexity still the same between sequential or parallel, but each tool brings differents benefits, in parallel case, perhaps complexity dont' change, the work or whole proccess will divide into cores, this will bring a faster program.

## User Manual
There´s a few considerations before using the program:
* This program will generate n files(html) and a single css. program will read your whole directory. Parallel function ask for the path and cores, you must be organizated in the path that you wanna work with, program will just process .txt files
* As mentioned in the previous point, Program will ask for path, so let´s talk about the path format that you must use:
z = any directory name.
#### Format example: ...z\\z\\z\\
Here's how I introduce my path 

### Now we can go to next steps

1.- Download exs file

2.- Download or get your test files

3.- Get your path ready where your files  are in. (also html and css will generate in same path)

4.- Open exs

5.- Call Function (H.Syntax is module and parallel_syntax is the function) So H.Syntax.parallel_syntax("") between "" you'll write your path and write the cores or task that you wanna use (i'll use 3 in this test)
So in my case: H.Syntax.main_syntax("C:\\Users\\USER\\Desktop\\ELIXIR\\",3)

6.- enter
Terminal result:
![image](https://github.com/carlosfragoso21/TC2037_RSP/assets/80837879/d38fe100-04db-49fa-a56a-54095cfac784)


7.- Check the HTML Files generated in your directory

![image](https://github.com/carlosfragoso21/TC2037_RSP/assets/80837879/fd17087e-6020-4644-a5fd-a1c957c743b7)


### Speedup
You can also test velocity from both process (sequential or parallel)
The function name is calc_speedup/2, argues are like the parallel_syntax one

![image](https://github.com/carlosfragoso21/TC2037_RSP/assets/80837879/38ba28bd-b918-4fda-b06e-1f71bb44b452)


