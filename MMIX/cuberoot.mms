% cuberoot.mms
%   calculates the cube root of a number interactively passed into $0
%   Uses Newton's method as described in the subroutine
%   Requires the user to insert the number to find the cube root of 
%       into $0 interactively at the beginning of runtime.  To see
%       the result, the user must again ask to see.

fA      IS      $2
x       IS      $3
ep      IS      $4


        LOC     #100
Main    SET     x,$0        % $0 needs to be set with interactive mode
        SET     fA,0        % temporarily save number 0.
        SETH    ep,#3f00    % sets ep to 1e-15
        FCMP    fA,x,fA     % first approximation == +-1 based on s(x)
        FLOT    fA,fA       % convert +-1 to floating point
        PUSHJ   0,CbRt      % get cube root of x
        TRAP    0,Halt,0    % quit



    PREFIX  CbRt:
%   Find the cube root of some number x
%   Uses successive approximations, ri+1 = 2/3 ri + 1/3 x/ri^2
%       ala Newton's method
%   Parameters: $1 = ri, last approximation
%               $2 = x, number to find cube root of
%               $3 = epsilon, max relative error
%   if ri+1 satisfies relative error, return in $0,
%   otherwise recursive call until we find it.

retAd   IS      $0      % return address of subroutine, for recursion
ri      IS      $1      % last approximation
x       IS      $2      % number to compute cube root
ep      IS      $3      % max relative error
temp1   IS      $4      % in this order for a reason
temp2   IS      $5
ripp    IS      $6      % ri+1
two     IS      $7
three   IS      $8

:CbRt   FLOT    two,2           %2.0
        FLOT    three,3         %3.0
        FMUL    temp1,ri,ri     % temp1=ri^2
        FMUL    temp2,temp1,three   % temp2 = 3*(ri^2)
        FDIV    temp1,x,temp2   % temp1 = (1/3)*(x/ri^2)
        FMUL    temp2,ri,two      % temp2 = ri*2
        FDIV    temp2,temp2,three   % temp2 = (2/3)*ri       
        FADD    ripp,temp1,temp2   %temp1 = ri+1

        FSUB    temp1,ripp,ri   %temp1 = ri - ri+1
        ANDNH   temp1,#8000     %abs(temp1)
        FMUL    temp2,ep,ri     %temp2 = epsilon*ri
        ANDNH   temp2,#8000     %abs(temp2)

        FCMP    temp1,temp1,temp2   %met our relative error condition?
        BN      temp1,1F        % if met return
        GET     retAd,:rJ       % need another approx, get rtn addr
        SET     $5,ep           % set up to pass parameters correctly
        SET     $4,x
        SET     $3,ripp
        PUSHJ   1,:CbRt          % get next approx, ans returned in $1
        PUT     :rJ,retAd       % set up to return
        POP     2,0             % return ans
1H      POP     7,0             % we found the answer return ripp
    PREFIX :
