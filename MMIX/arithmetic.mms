%   Computes arithmetic sum of a + iD for i_0^{N-1} Or rather:
%       \sum_{i=0}^{N-1}A+iD in LaTeX notation

        LOC     Data_Segment
        GREG    @
A       OCTA    1
D       OCTA    2
N       OCTA    5 
S       OCTA    0

        LOC     #100
Main    LDO     $0,A            %load A
        LDO     $1,N            %load N
        LDO     $2,D            %load D
        SUB     $1,$1,1         % make that N-1
        SET     $4,0            % the answer register

i       GREG    0
temp    IS      $3
n       IS      $1
a       IS      $0
sum     IS      $4
d       IS      $2
dt      GREG    0
1H      SUB     temp,n,i
        PBNN    temp,2F                  %If $1-i>=0, need another sum
        STO     sum,S
        TRAP    0,Halt,0
%add next sum element
2H      ADD     sum,sum,a                %add A to sum
        SET     temp,i
4H      PBP     temp,3F                 %need to get iD
        ADD     sum,sum,dt              %add iD to sum
        ADD     i,i,1                   %i++
        SET     dt,0                    %reset dt
        JMP     1B

3H      ADD     dt,dt,d                 %dt = dt+d
        SUB     temp,temp,1             %temp--
        JMP     4B
