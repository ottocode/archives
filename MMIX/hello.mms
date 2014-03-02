        LOC     #100
Main    GETA    $255,String
        ADD     $0,$255,0
        LDA     $1,$255
        ADD     $255,$1,0
        TRAP    0,Fputs,StdOut
        TRAP    0,Halt,0
String  BYTE    "That's all, folks!",#a,0
