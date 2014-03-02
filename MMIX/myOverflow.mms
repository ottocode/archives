% Adapted from Dr. Langton's overflow.mms, University of San Diego
% demonstrates integer overflow from two directions

t       IS      $255

        LOC     #20
        PUSHJ   255,Err
        PUT     rJ,$255
        GET     $255,rB
        RESUME

        LOC     #100
Main    SET     t,#4000
        PUT     rA,t
        ORN     $0,$0,0
        ANDNH   $0,#8000
        ADD     $0,$0,1
        SET     $0,0
        SETH    $0,#8000
        SUB     $0,$0,1
        GETA    t,End
        TRAP    0,Fputs,StdOut
        TRAP    0,Halt,0
End     BYTE    "End of program",#a,0

Err     SET     $0,$255
        GETA    t,Emes
        TRAP    0,Fputs,StdOut
%        GET     t,rW
%        INCL    t,4
%        PUT     rW,t
        SET     $255,$0
        POP     0,0
Emes    BYTE    "Error: integer overflow",#a,0
