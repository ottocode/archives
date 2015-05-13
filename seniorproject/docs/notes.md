Development Notes
=================

I should have been doing this all along, but here will be the development notes for nocc

### prior to 2/26/14
Figured out what I want to do, create a C compiler.
Ultimately I decided that I will attempt to create a compiler for the ARMv6 architecture and compile C code into assembly, but not necessarily write an assembler as well.

Decided to break work into "modules," the scanner, parser/code-generator, preprocessor, and "backend"

Began developing the scanner.  Essentially created a big DFA for the id/keywords, constants, strings, and operators.

Need to figure out exact implementation of symbol table

"Finished" scanner around 2/25/14

### 2/26/14

I originally intended to create the preprocessor right after the scanner, but decided that since the preprocessor grammer includes the non-terminal symbol `constant-expression` that it might be best to simply create the parser first.
So I've copied the grammer from K&R book into cgrammer and need to manipulate it into an implementable version.  '

Since everything is being hand-coded, the parser will be a top-down, recursive-decent predictive parser (at least I hope to be that ambitious).
The predictive part may not get implemented, but the rest will.
Thus, the grammer in `cgrammer` needs to be modified to eliminate the left-recursion as well as the if-else / if-elseif-else ambiguity.


### 3/3/14

So, I have not been terribly good at keeping notes...
Anyway, after some more reading about parsing, particularly about creating the parse table, I am coming to the conclusion that a "hand-coded" parser may not be the best option.  What I have from K&R is a left-recursive grammer with the one ambiguity.  This is of course not terribly great for a top-down parser.  However, Red-Dragon gives algorithms for eliminating left recursion, eliminating ambiguity, and constructing a parse table.  Thus, I should be able to create the systems to convert the given grammer into the appropriate LL(1) grammar.


### 3/19/14
Unfortunately I did not get too much done during spring break, but then again that was okay.  I believe I have finished implementing the algorithms from the red-dragon book to eliminate left recursion from the grammar (page 177) and have added the file LLgrammar.  That was a very educational experience.  While the algorithm is given (hallelujah) the implementation was not.  The implementation turned out to be quite non-trivial (although I am sure there is a better way).
