//This fun little guy was developed for the StackOverflow question 
// http://stackoverflow.com/questions/16967136/mmix-neg-and-negu-opcodes

t       IS      $255

        LOC     #20
        PUSHJ   255,Err
        PUT     rJ,$255
        GET     $255,rB
        RESUME

        LOC     #100
Main    SET     t,#4000
        PUT     rA,t
        SETH    $0,#8000
        NEG     $1,0,$0
        GETA    t,End
        TRAP    0,Fputs,StdOut
        TRAP    0,Halt,0
End     BYTE    "End of program",#a,0

Err     SET     $0,$255
        GETA    t,Emes
        TRAP    0,Fputs,StdOut
        GET     t,rW
        INCL    t,4
        PUT     rW,t
        SET     $255,$0
        POP     0,0
Emes    BYTE    "Error: integer overflow",#a,0
