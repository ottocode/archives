%   Calculate the nth Fibonacci number
%       n is given by user input
%       F(0) = 0
%       F(1) = 1
%       F(n) = F(n-1)+F(n-2) if n>1
%   Author: Nicholas Otto

inputSize   IS  20  % 2^64 has 20 digits, good place
                    %   to stop
outputSize  IS  20  % room for 20 digits
f0          IS  0   % f(0)
f1          IS  1   % f(1)


%Memory for input
        LOC     Data_Segment
        GREG    @
Prompt  BYTE    "Enter the nth Fibonacci number you want to know:",#a,0
Mesg    BYTE    "The Finobacci number is ",0
inAd    LOC     @+inputSize         %space for user input
inArg   OCTA    inAd                %Argument block for Fgets
        OCTA    inputSize
        OCTA    @+outputSize        %room for fibo result
outAd   OCTA    #0a00000000000000   %terminate output with \n00

        LOC     #100
Main    PUSHJ   2,getIn             % get Input
        PUSHJ   1,Fibo              % Calculate Fibonacci number
        LDA     $255,Mesg           % Human friendly program
        TRAP    0,Fputs,StdOut
        PUSHJ   0,pOut              % Display the Fibonaccii number
        TRAP    0,Halt,0            % Exit

        PREFIX  getIn:
% Subroutine to get user input.
%   User is expected to type one integer then \n
%   Subroutine returns user input to hole register
base    IS      10
n       IS      $0                  % the value of user input
fB      IS      $1                  % addr of first input byte
nextB   IS      $2                  % fB+nextB = current byte
tmp     IS      $3                  % temp
A0      IS      '0'                 % offset is ASCII 0

:getIn  LDA     $255,:Prompt
        TRAP    0,:Fputs,:StdOut
        SET     n,0                 % Start with 0
        SET     nextB,0             % first byte is addr+0
        LDA     $255,:inArg         % Prepare for input
        TRAP    0,:Fgets,:StdIn     % Input!
        LDA     fB,:inAd            % fB = addr of first input
        JMP     2F
1H      MUL     n,n,base            % n*10
        ADD     n,n,tmp             % n0 + tmp = ntmp
2H      LDB     tmp,fB,nextB        % load in next input byte
        ADD     nextB,nextB,1       % nextB++
        SUB     tmp,tmp,A0          % covert byte from ASCII to DEC
        PBNN    tmp,1B              % if digit, update n and repeat
        POP     1,0                 % return 'n' to main
        PREFIX :


        PREFIX  :Fibo
% Subroutine to calculate the nth Fibonacci number
%   Calculate from F(0) up
%   @param n    located in $0
%   @return F(n)    return to hole register
n       IS      $0                  % the argument passed to subroutine
t       IS      $1                  % counter variable
a       IS      $2                  % holds F(t-2)
b       IS      $3                  % holds F(t-1)
F       IS      $4                  % holds F(t)
temp    IS      $5

:Fibo   CMPU    t,n,2               % if n<2
        BN      t,3F                %   return n
        SET     a,0                 % F(0) = 0
        SET     b,1                 % F(1) = 1
        SET     t,1                 % counter = t
        JMP     2F
1H      ADDU    t,t,1               % t++
        ADDU    F,a,b               % F(t) = F(t-1) + F(t-2)
        SET     a,b                 % a = F(t-1)
        SET     b,F                 % b = F(t)
2H      CMPU    temp,n,t            % if t<n, repeat
        PBP     temp,1B
        SET     n,F                 % set up for a return
3H      POP     1,0                 % return F value
        PREFIX  :


        PREFIX  pOut:
% Subroutine to print out an integer
%   @param binV the number to print out
%   print out binV, return nothing
base    IS      10
A0      IS      '0'                 % offset is ASCII 0
binV    IS      $0                  % binary num value of output
fB      IS      $1                  % addr of first input byte
nextB   IS      $2                  % fB+nextB = current byte
temp    IS      $3

:pOut   LDA     fB,:outAd           % address of \n
        SET     nextB,0             
        PBP     binV,1F             % if number>0, convert to ASCII
        SUB     nextB,nextB,1       %   else, prepare to print '0'
        SET     temp,A0          
        STB     temp,fB,nextB       % store '0'
        JMP     3F
1H      SUB     nextB,nextB,1       % store digits right to left
        DIV     binV,binV,base      % binV = binV/10
        GET     temp,:rR            % temp = binV % 10
        ADD     temp,temp,A0        % temp = ASCII(temp)
        STB     temp,fB,nextB       % store temp into memory
2H      PBP     binV,1B             % if binV>0, more digits to get
3H      LDA     $255,fB,nextB       % prepare to print digits
        TRAP    0,:Fputs,:StdOut    % print, conveniently ended with \n
        POP     0,0                 % return

        PREFIX  :
