%Author: Nicholas Otto
%Date Due: 10/29/2012, Assignment #8
%
% 3 part MMIX program
%   1. Take in user input, storing only ASCII digits
%   2. Convert ASCII digits to numerical value
%   3. Convert back to ASCII digits, print result

BufSize IS      160
ChPosi  IS      $0
CurChar IS      $1
tmpChar IS      $2
ind1    IS      $3
ind2    IS      $4
DecNum  IS      $5
numVal  IS      $6
fChar   IS      $8
temp    IS      $9

%Memory for input
        LOC     Data_Segment
        GREG    @
BufAd   LOC     @+BufSize
ArgBlc  OCTA    BufAd
        OCTA    BufSize

%Memory for output
PrntBlc OCTA    0            %will be address of first char
        OCTA    0            % will be # of digits

        
        LOC     #100
Main    LDA     $255,ArgBlc     % Prepare for input,
        TRAP    0,Fgets,StdIn   % Input!

% Find first ASCII digit
        SET     ChPosi,0                % 'index' tracker
        LDA     fChar,BufAd             % first character
1H      CMPU    $7,ChPosi,BufSize       % avoid infinite loops
        BNN     $7,2F                   % if taken, BufSize chars seen
        LDB     CurChar,fChar,ChPosi    % get char 'index'
        ADD     ChPosi,ChPosi,1         % index++

    %check if the character is a number (in ascii)
        SUB     tmpChar,CurChar,'0'
        CMP     ind1,tmpChar,0      % if value <0, -1-(-1) = 0
        CMP     ind2,tmpChar,9      % if value >9, 1-1 = 0
        SUB     ind1,ind1,ind2      % will equal 0 if not a digit
        PBZ     ind1,1B             % if not a digit, get another char
2H      SET     numVal,tmpChar      % else, continue
        JMP     2F                  % jump inside next loop

%get the numerical value entered by user.  Store in numVal
3H      MUL     numVal,numVal,10       % make room for next digit 
        ADD     numVal,numVal,tmpChar  % add next digit
2H      LDB     CurChar,fChar,ChPosi   
        ADD     ChPosi,ChPosi,1     %get next digit, same as before
        SUB     tmpChar,CurChar,'0'
        CMP     ind1,tmpChar,0
        CMP     ind2,tmpChar,9
        SUB     ind1,ind1,ind2      % will equal 0 if not a digit
        PBNZ    ind1,3B             % if is a digint, add to sum

%Some preliminary setup before printing numerical value
        SET     ChPosi,0            % ChPosi an index value
        LDA     fChar,PrntBlc       % fChar = index of last char+1
        SUB     ChPosi,ChPosi,1     % add from back to front

%make last two characters #0a00 = \n+NULL
        SET     tmpChar,0
        STB     tmpChar,fChar,ChPosi    % last char = #00
        SUB     ChPosi,ChPosi,1         % index--
        SET     tmpChar,#a              
        STB     tmpChar,fChar,ChPosi    % last chars = #0a00
        SUB     ChPosi,ChPosi,1         % index--

        JMP     5F      %this allows for case when no digits added

%Convert numVal into string of ASCII digits, store right to left
4H      DIV     numVal,numVal,10
        GET     $7,rR
        ADD     CurChar,$7,'0'
        STB     CurChar,fChar,ChPosi
        SUB     ChPosi,ChPosi,1
5H      PBP     numVal,4B

%Print out the numerical Value
        ADD     ChPosi,ChPosi,1     % Undo last add
        ADD     ChPosi,ChPosi,fChar % Address of first char
        SUB     fChar,fChar,ChPosi  % number of chars
        STO     ChPosi,PrntBlc      % store address
        STO     fChar,PrntBlc+8     % store size

        LDA     $255,PrntBlc        % Prepare for output,
        TRAP    0,Fwrite,StdOut     % Output!
        TRAP    0,Halt,0            %exit
        
