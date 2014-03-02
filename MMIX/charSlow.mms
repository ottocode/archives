% Author: Nicholas Otto, 23/Oct/2012
% Prints our "That's all, folks!\n" character by character.
%   Just for simplicity's sake, real program is fast.mms
%

        LOC         Data_Segment
        GREG        @
Arg     OCTA        0       %will contain address of char
        OCTA        1
char    OCTA        0


        LOC         #100
Main    GETA        $1,String
        SET         $3,0
        LDBU        $0,$1,$3
1H      SLU         $0,$0,56
        STOU        $0,char
        LDA         $2,char
        LDA         $255,Arg
        STO         $2,$255
        TRAP        0,Fwrite,StdOut
        ADDU        $3,$3,1
        LDBU        $0,$1,$3
        PBNZ        $0,1B
        TRAP        0,Halt,0
String  BYTE        "That's all, folks!",#a,0
