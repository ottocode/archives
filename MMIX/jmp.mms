%   Simple MMIX program that will sort three integers A, B, C
%       into ascending order.
%   Utilizes a sort of "bubble sort" algorithm that bubbles
%       large numbers down.

        LOC     Data_Segment
        GREG    @
A       OCTA    5
B       OCTA    4
C       OCTA    3

        LOC     #100
Main    LDO     $0,A        %Store A, B, C into $0, $1, $2
        LDO     $1,B
        LDO     $2,C

4H      SUB     $3,$1,$0    %Check if $1<$0
        BN      $3,1F       %if so, swap them
3H      SUB     $3,$2,$1    %check if $2<$1
        BN      $3,2F       %if so, swap them
        TRAP    0,Halt,0    %end program

1H      XOR     $1,$0,$1    %swap in place    
        XOR     $0,$1,$0    %contents $0 now former contents $1
        XOR     $1,$0,$1    %contents $1 now former contents $0
        JMP     3B
2H      XOR     $2,$1,$2    %swap in place    
        XOR     $1,$2,$1    %contents $1 now former contents $2
        XOR     $2,$1,$2    %contents $2 now former contents $1
        JMP     4B          %since swap, need to check $0,$1 again
