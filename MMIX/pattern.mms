%Author: Nicholas Otto
%Date Due: 11/14/2012, Assignment sheet #12
%
% Outline:
% 1. Read in two string, 'pattern' then 'target'
% 2. Find (first) position of 'pattern' in 'target'
% 3. Print out position.
% Note: I interpret the empty string to never be a position of
%       a target substring, even if the target is empty.

inputSize IS 100        % Seems big enough (100 char long stirng)
Addr    IS $0           %Will hold address of digit to print
ret     IS $1           %Will be non-zero if printing number<0
PatAd   IS $2           %Will hold address of pattern string
TarAd   IS $3           %Will hold address of target string
psize   IS $4           %"      "  size of pattern string
tsize   IS $5           %Will hold size of target string


%Initializing helpful memory blocks
        LOC Data_Segment
        GREG @
Pattrn  LOC @+inputSize %space for pattern string
Target  LOC @+inputSize %space for target string
pArg    OCTA Pattrn     %argument block for receiving pat String
        OCTA inputSize  
tArg    OCTA Target     %argument block for receiving tar String
        OCTA inputSize
        GREG @
Prompt1 BYTE "Enter the pattern string:",#a,0
Prompt2 BYTE "Enter the target string:",#a,0
Found   BYTE "The first position is: ",0
Value   LOC @+100 %we only reserve space for input <100 chars
NewLn   BYTE #0a %terminate output with \n00
        BYTE #00
NotFnd  BYTE "The pattern was not found! ",0

        LOC #100
Main    LDA $255,Prompt1        %prompt for pattern input
        TRAP 0,Fputs,StdOut
        LDA PatAd,Pattrn        %get address of Pattrn
        LDA $255,pArg           %prepare for pattern input,
        TRAP 0,Fgets,StdIn      %Input!
        SUB psize,$255,1        %save size

        LDA $255,Prompt2        %prompt for target input
        TRAP 0,Fputs,StdOut
        LDA TarAd,Target        %get address of Target
        LDA $255,tArg           %prepare for Target input,
        TRAP 0,Fgets,StdIn      %Input!
        SUB tsize,$255,1        %save target size

        PUSHJ 1,:Mstr           %find location of pattern in
                                % target.  pass in arguments:
                                %PatAd,TarAd,psize,tsize
                                %index returned to $1
        LDA $2,NewLn            %Prep to pass end of value block
        PUSHJ 0,:intPnt         %convert integer ($1) to ASCII 
                                %returns $0<-address of first ASCII
                                %        $1<-negative indicator
        BNZ     ret,1F          %if positive, print appropriate msg
        LDA     $255,Found
        TRAP 0,Fputs,StdOut
        JMP     2F
1H      LDA     $255,NotFnd     %if negative, print appropriate msg
        TRAP 0,Fputs,StdOut
2H      SET $255,Addr           %print number
        TRAP 0,Fputs,StdOut


        TRAP 0,Halt,0           %exit


        PREFIX Mstr: %MMIX version of C-style strstr
% I wrote this to take in the address of the two strings so that
%   in the future, the address does not need to be hard-coded
%   into the source code.
%Caveat!: If the pattern string is empty, then subroutine will
%   always return 0.  Justification: let P = pattern, T = target,
%   we are essentially looking for if P<subset>T.  If P={} (the empty
%   set), then P must be a subset of any other set.
paddr   IS $0 %address of target substring
taddr   IS $1 %address of pattern string
plen    IS $2 %length of pattern substring
tlen    IS $3 %length of target string
outeri  IS $4 %outer loop counter (goes down length of target)
inneri  IS $5 %inner loop counter
tchar   IS $6 %character from target string
pchar   IS $7 %character from pattern string
temp    IS $8   

:Mstr   SET outeri,0    %Initialize
        SET inneri,0
        BZ  plen,4F     %empty pattern always in target
        JMP 2F
        
1H      ADD outeri,outeri,1     %update outer loop
        CMP temp,tlen,outeri    %test if seen too many
        BN temp,3F              %   yes? return -1
        SET inneri,0            %reset inner loop counter
        ADD taddr,taddr,1       %move up one on target string

2H      LDB tchar,taddr,inneri %get target and pattern char
        LDB pchar,paddr,inneri
        ADD inneri,inneri,1     %update inner counter
        CMP temp,tchar,pchar    %target==pattern?
        PBNZ temp,1B            %   no->go back to outer loop
        CMP temp,plen,inneri    %   yes->check if complete match
        PBNZ temp,2B            %not complete match, repeat inner
4H      POP 5,0                 %complete match, return index(outeri)
3H      POP 9,0                 %no match, return -1(stored in temp)



        PREFIX :


        PREFIX intPnt: %Generic integer printing subroutine
base    IS 10
A0      IS '0' % offset is ASCII 0
int     IS $0 %the int to print, passed to subroutine
Addr    IS $1 %address to store characters, passed in
isN     IS $2 %if negative, value will be non-zero
t1      IS $3 %temp1
t2      IS $4 %temp2
nextB   IS $5 %counter that holds "nextByte" to store ASCII in mem


:intPnt ZSN isN,int,'-'     %If int is <0, set isN to ASCII '-'
        ZSNN t1,int,int     %Get absolute value of int...
        ZSNP t2,int,int
        SUB int,t1,t2       %int = Math.abs(int)
        SET nextB,0

1H      SUB nextB,nextB,1   %move to previous byte
        DIV int,int,base    %integer divide by 10
        GET t1,:rR          %t1 = int%10
        ADD t1,t1,A0        %convert t1 to ASCII
        STB t1,Addr,nextB   %store in mem
        PBP int,1B          %if int>0, loop back for more
        PBZ isN,2F          %if isN==0, int was originally positive, 
        SUB nextB,nextB,1   %else, need to tack on '-'
        STB isN,Addr,nextB  %tacking '-'
2H      ADDU Addr,Addr,nextB %will return Address of first ASCII char
        SET $0,isN          %prep to return negative indicator
        POP 2,0             %return Addr,isN
        

        PREFIX :
